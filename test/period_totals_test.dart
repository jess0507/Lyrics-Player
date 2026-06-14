import 'dart:ffi';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:seek_player/core/storage/isar_service.dart';
import 'package:seek_player/core/storage/preferences_service.dart';
import 'package:seek_player/features/music_list/track.dart';
import 'package:seek_player/features/profile/statistics/daily_track_stat_entity.dart';
import 'package:seek_player/features/profile/statistics/period_stat_entity.dart';
import 'package:seek_player/features/profile/statistics/statistics_service.dart';

DailyTrackStatEntity _stat(
  String day,
  String trackId,
  int playCount,
  int listenMs,
) {
  return DailyTrackStatEntity()
    ..day = day
    ..trackId = trackId
    ..title = 'T$trackId'
    ..playCount = playCount
    ..listenMs = listenMs;
}

PeriodStatEntity? _total(Isar isar, PeriodKind kind, String period) =>
    isar.periodStatEntitys.getByKindPeriodSync(kind, period);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late Isar isar;
  late ProviderContainer container;

  setUpAll(() async {
    // 測試 binding 會把 HttpClient 全擋成 400,Isar 內建的 download 走不通;
    // 改用 curl 預先抓 IsarCore 動態庫(只抓一次,落在 .dart_tool 下)。
    final lib = File('.dart_tool/isar_test/${Abi.current()}-libisar.dylib');
    if (!lib.existsSync()) {
      lib.parent.createSync(recursive: true);
      final result = Process.runSync('curl', [
        '-fsSL',
        '-o',
        lib.path,
        'https://github.com/isar/isar/releases/download/'
            '${Isar.version}/libisar_macos.dylib',
      ]);
      if (result.exitCode != 0) {
        fail('下載 IsarCore 失敗:${result.stderr}');
      }
    }
    await Isar.initializeIsarCore(libraries: {Abi.current(): lib.path});
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_test');
    isar = await Isar.open(
      [DailyTrackStatEntitySchema, PeriodStatEntitySchema],
      directory: tempDir.path,
      name: 'test',
    );
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(overrides: [
      isarProvider.overrideWithValue(isar),
      preferencesServiceProvider
          .overrideWithValue(await PreferencesService.create()),
    ]);
  });

  tearDown(() async {
    container.dispose();
    await isar.close();
    await tempDir.delete(recursive: true);
  });

  StatisticsController controller() =>
      container.read(statisticsControllerProvider.notifier);

  test('寫入後 totals 與明細同交易成對：day / month 各累加', () {
    const track = Track(id: '1', uri: 'file:///a', title: 'A');
    final c = controller();
    c.recordPlay(track);
    c.addListenTime(track, const Duration(seconds: 5));
    c.recordPlay(const Track(id: '2', uri: 'file:///b', title: 'B'));

    final now = DateTime.now();
    final day = StatisticsController.dayKey(now);
    final month = StatisticsController.monthKey(now);

    final dayTotal = _total(isar, PeriodKind.day, day)!;
    expect(dayTotal.playCount, 2);
    expect(dayTotal.listenMs, 5000);
    final monthTotal = _total(isar, PeriodKind.month, month)!;
    expect(monthTotal.playCount, 2);
    expect(monthTotal.listenMs, 5000);

    // 與明細加總一致。
    final details = isar.dailyTrackStatEntitys.where().findAllSync();
    expect(details.fold(0, (s, d) => s + d.playCount), dayTotal.playCount);
    expect(details.fold(0, (s, d) => s + d.listenMs), dayTotal.listenMs);
  });

  test('rebuildPeriodTotals 由明細重建 day / month 兩種粒度', () {
    isar.writeTxnSync(() => isar.dailyTrackStatEntitys.putAllSync([
          _stat('2026-05-30', '1', 2, 100),
          _stat('2026-05-31', '1', 1, 50),
          _stat('2026-06-01', '1', 3, 200),
          _stat('2026-06-01', '2', 1, 80),
        ]));
    controller().rebuildPeriodTotals();

    expect(_total(isar, PeriodKind.day, '2026-05-30')!.playCount, 2);
    expect(_total(isar, PeriodKind.day, '2026-06-01')!.playCount, 4);
    expect(_total(isar, PeriodKind.day, '2026-06-01')!.listenMs, 280);
    expect(_total(isar, PeriodKind.month, '2026-05')!.playCount, 3);
    expect(_total(isar, PeriodKind.month, '2026-05')!.listenMs, 150);
    expect(_total(isar, PeriodKind.month, '2026-06')!.playCount, 4);
  });

  test('build() backfill：明細非空且 totals 空時全量重建', () {
    isar.writeTxnSync(() => isar.dailyTrackStatEntitys
        .putAllSync([_stat('2026-06-01', '1', 3, 200)]));
    // 首次 read 觸發 build()。
    container.read(statisticsControllerProvider);
    expect(_total(isar, PeriodKind.day, '2026-06-01')!.playCount, 3);
    expect(_total(isar, PeriodKind.month, '2026-06')!.listenMs, 200);
  });

  test('v2 文件還原（無 monthlyTotals）：day / month 全由明細重建', () {
    controller().restoreFromRemote([
      _stat('2026-04-10', '1', 2, 100),
      _stat('2026-05-01', '1', 1, 30),
    ]);
    expect(_total(isar, PeriodKind.day, '2026-04-10')!.listenMs, 100);
    expect(_total(isar, PeriodKind.month, '2026-04')!.playCount, 2);
    expect(_total(isar, PeriodKind.month, '2026-05')!.playCount, 1);
  });

  test('v3 文件還原：月粒度以雲端為準、day totals 由明細重建', () {
    // 雲端 month total 比明細加總大——模擬明細已被截斷、
    // 歷史總量只剩 monthlyTotals 保有的情境。
    controller().restoreFromRemote(
      [_stat('2026-05-20', '1', 1, 30)],
      monthlyTotals: [
        PeriodStatEntity()
          ..kind = PeriodKind.month
          ..period = '2026-05'
          ..playCount = 9
          ..listenMs = 999,
      ],
    );
    expect(_total(isar, PeriodKind.day, '2026-05-20')!.listenMs, 30);
    final month = _total(isar, PeriodKind.month, '2026-05')!;
    expect(month.playCount, 9);
    expect(month.listenMs, 999);
  });

  test('還原整份覆寫：既有明細與 totals 先被清空', () {
    controller().restoreFromRemote([_stat('2026-01-01', '9', 5, 500)]);
    controller().restoreFromRemote([_stat('2026-02-02', '1', 1, 10)]);
    expect(_total(isar, PeriodKind.day, '2026-01-01'), isNull);
    expect(_total(isar, PeriodKind.month, '2026-01'), isNull);
    expect(_total(isar, PeriodKind.day, '2026-02-02')!.playCount, 1);
  });

  test('reset 同交易清空明細與 totals 兩個 collection', () {
    controller().recordPlay(const Track(id: '1', uri: 'u', title: 'A'));
    controller().reset();
    expect(isar.dailyTrackStatEntitys.countSync(), 0);
    expect(isar.periodStatEntitys.countSync(), 0);
  });

  test('recomputePeriods 定向重算指定日與其所屬月份', () {
    // 先觸發 build()(此時兩個 collection 皆空,backfill 不會啟動),
    // 再塞明細,確認定向重算只動指定的期間。
    final c = controller();
    isar.writeTxnSync(() => isar.dailyTrackStatEntitys.putAllSync([
          _stat('2026-06-01', '1', 3, 200),
          _stat('2026-06-02', '1', 2, 100),
        ]));
    c.recomputePeriods(['2026-06-01']);
    expect(_total(isar, PeriodKind.day, '2026-06-01')!.playCount, 3);
    // 未指定的日不重算。
    expect(_total(isar, PeriodKind.day, '2026-06-02'), isNull);
    // 所屬月份聚合的是整月明細。
    expect(_total(isar, PeriodKind.month, '2026-06')!.playCount, 5);
  });
}
