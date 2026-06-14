import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/storage/isar_service.dart';
import '../../../core/storage/preferences_service.dart';
import '../../../core/sync/sync_state_store.dart';
import '../../music_list/track.dart';
import 'daily_track_stat_entity.dart';
import 'period_stat_entity.dart';

/// 聆聽統計：由 Isar 的每日 × 每首歌記錄導出的 view。
///
/// 不存任何總和——累計總量、排行、每日總量皆於讀取時由 [days] 聚合導出，
/// 本機與雲端結構對稱，不會有「總計與明細對不上」的問題。
class StatisticsData {
  const StatisticsData(this.days);

  /// 每日 × 每首歌的記錄（依日期升冪）。
  final List<DailyTrackStatEntity> days;

  int get totalPlayCount => days.fold(0, (sum, d) => sum + d.playCount);

  int get totalListenMs => days.fold(0, (sum, d) => sum + d.listenMs);

  Duration get totalListenTime => Duration(milliseconds: totalListenMs);

  /// 某一天（本地日期）的統計子集：導出 getter 全部只算該日。
  StatisticsData onDay(DateTime date) =>
      _matching(StatisticsController.dayKey(date));

  /// 某一月的統計子集。
  StatisticsData inMonth(DateTime date) =>
      _matching('${StatisticsController.monthKey(date)}-');

  /// 某一年的統計子集。
  StatisticsData inYear(DateTime date) =>
      _matching('${StatisticsController.yearKey(date)}-');

  /// 期間內聽過的所有歌與各自的次數、時長（title 聚合，依次數排序）。
  ///
  /// 以 title 聚合：從雲端還原的記錄帶舊裝置的 trackId，同一首歌在新裝置
  /// 播放會另起一筆，聚合後才不會同曲分裂成兩列。
  List<TrackRanking> allTracks() => _aggregateByTitle(days);

  /// 依播放次數排序的前幾名（跨日加總；標題、次數、聆聽時長）。
  List<TrackRanking> topTracks([int limit = 5]) =>
      allTracks().take(limit).toList();

  /// 每日總量（依日期升冪），供時間軸圖表使用；
  /// 缺日（沒聽歌的天）不產生條目，由顯示層補零。
  List<DailyTotal> dailyTotals() {
    final byDay = <String, ({int playCount, int listenMs})>{};
    for (final d in days) {
      final prev = byDay[d.day] ?? (playCount: 0, listenMs: 0);
      byDay[d.day] = (
        playCount: prev.playCount + d.playCount,
        listenMs: prev.listenMs + d.listenMs,
      );
    }
    final keys = byDay.keys.toList()..sort();
    return [
      for (final day in keys)
        DailyTotal(
          day: day,
          playCount: byDay[day]!.playCount,
          listenTime: Duration(milliseconds: byDay[day]!.listenMs),
        ),
    ];
  }

  /// day key 為定長 `yyyy-MM-dd`，prefix 比對即可取日（完整 key）／月／年。
  StatisticsData _matching(String prefix) => StatisticsData(
        [for (final d in days) if (d.day.startsWith(prefix)) d],
      );

  static List<TrackRanking> _aggregateByTitle(
    Iterable<DailyTrackStatEntity> records,
  ) {
    final byTitle = <String, ({int playCount, int listenMs})>{};
    for (final r in records) {
      final prev = byTitle[r.title] ?? (playCount: 0, listenMs: 0);
      byTitle[r.title] = (
        playCount: prev.playCount + r.playCount,
        listenMs: prev.listenMs + r.listenMs,
      );
    }
    return [
      for (final e in byTitle.entries)
        TrackRanking(
          title: e.key,
          playCount: e.value.playCount,
          listenTime: Duration(milliseconds: e.value.listenMs),
        ),
    ]..sort((a, b) => b.playCount.compareTo(a.playCount));
  }
}

/// 排行榜單一列：同 title 聚合後的次數與聆聽時長。
class TrackRanking {
  const TrackRanking({
    required this.title,
    required this.playCount,
    required this.listenTime,
  });

  final String title;
  final int playCount;
  final Duration listenTime;
}

/// 單日聚合總量（時間軸圖表的一個資料點）。
class DailyTotal {
  const DailyTotal({
    required this.day,
    required this.playCount,
    required this.listenTime,
  });

  /// 本地日期 `yyyy-MM-dd`。
  final String day;
  final int playCount;
  final Duration listenTime;
}

class StatisticsController extends Notifier<StatisticsData> {
  /// 舊版 SharedPreferences 統計的 key，首次啟動遷移到 Isar 後移除。
  static const _kLegacyKey = 'statistics.data';

  Isar get _isar => ref.read(isarProvider);
  IsarCollection<DailyTrackStatEntity> get _days =>
      _isar.dailyTrackStatEntitys;
  IsarCollection<PeriodStatEntity> get _periods => _isar.periodStatEntitys;

  @override
  StatisticsData build() {
    _migrateFromPrefs();
    return _load();
  }

  StatisticsData _load() =>
      StatisticsData(_days.where().sortByDay().findAllSync());

  /// 一首曲目開始播放時呼叫。
  void recordPlay(Track track) => _record(track, playCount: 1);

  /// 累加該曲目當日的聆聽時長（播放期間定期取樣）。
  void addListenTime(Track track, Duration duration) {
    if (duration <= Duration.zero) return;
    _record(track, listenMs: duration.inMilliseconds);
  }

  /// 同一個交易內 upsert 三筆：每曲明細（今天, trackId）、
  /// day total（今天）、month total（本月）——明細與期間總量必成對，
  /// 不會出現只寫一半的狀態。
  void _record(Track track, {int playCount = 0, int listenMs = 0}) {
    final now = DateTime.now();
    final today = dayKey(now);
    late DailyTrackStatEntity entity;
    _isar.writeTxnSync(() {
      entity = (_days.getByDayTrackIdSync(today, track.id) ??
          (DailyTrackStatEntity()
            ..day = today
            ..trackId = track.id))
        ..title = track.title
        ..playCount += playCount
        ..listenMs += listenMs;
      _days.putSync(entity);
      _bumpPeriodSync(PeriodKind.day, today, playCount, listenMs);
      _bumpPeriodSync(PeriodKind.month, monthKey(now), playCount, listenMs);
    });
    _commit(entity);
  }

  /// 累加指定期間 total（須在 writeTxnSync 內呼叫）。
  void _bumpPeriodSync(
    PeriodKind kind,
    String period,
    int playCount,
    int listenMs,
  ) {
    final entity = _periods.getByKindPeriodSync(kind, period) ??
        (PeriodStatEntity()
          ..kind = kind
          ..period = period);
    _periods.putSync(entity
      ..playCount += playCount
      ..listenMs += listenMs);
  }

  /// 月粒度 totals（依 period 升冪），供同步上傳（v3 `monthlyTotals` 欄位）。
  List<PeriodStatEntity> monthlyTotals() => _periods
      .filter()
      .kindEqualTo(PeriodKind.month)
      .sortByPeriod()
      .findAllSync();

  /// 定向重算：只重算受影響的 day bucket 與其所屬 month bucket
  /// （明細索引範圍查詢聚合後 upsert 覆寫）。用於 prefs 舊版遷移等
  /// 「已知哪幾天的明細被批次改動」的場合。
  void recomputePeriods(Iterable<String> dayKeys) {
    final days = dayKeys.toSet();
    final months = {for (final d in days) d.substring(0, 7)};
    _isar.writeTxnSync(() {
      for (final day in days) {
        _putComputedSync(
          PeriodKind.day,
          day,
          _days.where().dayEqualToAnyTrackId(day).findAllSync(),
        );
      }
      for (final month in months) {
        _putComputedSync(
          PeriodKind.month,
          month,
          _days.filter().dayStartsWith('$month-').findAllSync(),
        );
      }
    });
  }

  /// 以明細聚合結果覆寫單一期間 total（須在 writeTxnSync 內呼叫）。
  void _putComputedSync(
    PeriodKind kind,
    String period,
    List<DailyTrackStatEntity> records,
  ) {
    var playCount = 0;
    var listenMs = 0;
    for (final r in records) {
      playCount += r.playCount;
      listenMs += r.listenMs;
    }
    final entity = _periods.getByKindPeriodSync(kind, period) ??
        (PeriodStatEntity()
          ..kind = kind
          ..period = period);
    _periods.putSync(entity
      ..playCount = playCount
      ..listenMs = listenMs);
  }

  /// 由明細在記憶體單趟聚合出 day 粒度 totals（還原時重建用；
  /// month 粒度以雲端 `monthlyTotals` 為準，不由明細導出）。
  static List<PeriodStatEntity> _aggregateDayTotals(
    Iterable<DailyTrackStatEntity> records,
  ) {
    final byDay = <String, ({int playCount, int listenMs})>{};
    for (final r in records) {
      final prev = byDay[r.day] ?? (playCount: 0, listenMs: 0);
      byDay[r.day] = (
        playCount: prev.playCount + r.playCount,
        listenMs: prev.listenMs + r.listenMs,
      );
    }
    return [
      for (final e in byDay.entries)
        PeriodStatEntity()
          ..kind = PeriodKind.day
          ..period = e.key
          ..playCount = e.value.playCount
          ..listenMs = e.value.listenMs,
    ];
  }

  /// 清空本機統計（明細與期間 totals 同交易清空）。
  /// 雲端備份的刪除由呼叫端透過 SyncService 處理。
  void reset() {
    _isar.writeTxnSync(() {
      _days.clearSync();
      _periods.clearSync();
    });
    state = const StatisticsData([]);
    ref.read(syncStateStoreProvider).markModified();
  }

  /// 還原雲端備份（整份覆寫本機）。
  ///
  /// [monthlyTotals] 為雲端文件的月粒度 totals——月粒度以雲端為準
  /// （將來明細被截斷後，月總量只有雲端是完整的）；
  /// day totals 不上傳，由明細單趟重建。
  ///
  /// 還原不算本機變更：不更新 lastModifiedAt，避免還原後馬上又觸發上傳。
  void restoreFromRemote(
    List<DailyTrackStatEntity> entities, {
    required List<PeriodStatEntity> monthlyTotals,
  }) {
    final dayTotals = _aggregateDayTotals(entities);
    _isar.writeTxnSync(() {
      _days.clearSync();
      _days.putAllSync(entities);
      _periods.clearSync();
      _periods.putAllSync([...dayTotals, ...monthlyTotals]);
    });
    state = _load();
  }

  /// 本地日期轉 `yyyy-MM-dd` key。
  static String dayKey(DateTime t) => '${monthKey(t)}-${_pad(t.day)}';

  /// 本地日期轉 `yyyy-MM` key。
  static String monthKey(DateTime t) => '${yearKey(t)}-${_pad(t.month)}';

  /// 本地日期轉 `yyyy` key。
  static String yearKey(DateTime t) => t.year.toString().padLeft(4, '0');

  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// 寫入後把單筆 upsert 增量套進 state，不全量重讀
  /// （addListenTime 每 5 秒取樣一次，資料量大時全量重讀划不來）。
  void _commit(DailyTrackStatEntity entity) {
    final days = [...state.days];
    final i = days.indexWhere(
      (d) => d.day == entity.day && d.trackId == entity.trackId,
    );
    if (i >= 0) {
      days[i] = entity;
    } else {
      days.add(entity); // 新記錄必為今天，接在升冪清單尾端即仍有序
    }
    state = StatisticsData(days);
    ref.read(syncStateStoreProvider).markModified();
  }

  /// 把舊版 prefs 統計（perTrackCount + trackTitles）匯入為「遷移當日」的
  /// 每日記錄後移除舊 key。
  ///
  /// 舊累計攤不進真實日期，整筆掛在遷移當日；
  /// 舊版的全域 totalListenMs 攤不進 per-track，直接捨棄（皆為已知取捨）。
  void _migrateFromPrefs() {
    final prefs = ref.read(preferencesServiceProvider);
    final raw = prefs.getString(_kLegacyKey);
    if (raw == null) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final counts = (json['perTrackCount'] as Map?) ?? const {};
      final titles = (json['trackTitles'] as Map?) ?? const {};
      final today = dayKey(DateTime.now());
      final entities = [
        for (final entry in counts.entries)
          DailyTrackStatEntity()
            ..day = today
            ..trackId = entry.key as String
            ..title = (titles[entry.key] as String?) ?? entry.key as String
            ..playCount = entry.value as int,
      ];
      if (entities.isNotEmpty) {
        _isar.writeTxnSync(() => _days.putAllSync(entities));
        // 只寫遷移當日 → 定向重算當日 + 當月兩筆 totals 即可。
        recomputePeriods([today]);
        ref.read(syncStateStoreProvider).markModified();
      }
    } catch (e) {
      debugPrint('統計遷移失敗，捨棄舊資料：$e');
    }
    prefs.remove(_kLegacyKey);
  }
}

final statisticsControllerProvider =
    NotifierProvider<StatisticsController, StatisticsData>(
  StatisticsController.new,
);
