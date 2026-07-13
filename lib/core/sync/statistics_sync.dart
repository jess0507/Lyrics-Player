import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/statistics/models/daily_track_stat_entity.dart';
import '../../features/profile/statistics/models/period_stat_entity.dart';
import '../../features/profile/statistics/services/statistics_service.dart';

/// 統計與主文件 `days` / `monthlyTotals` 欄位的編解碼與還原
/// （SyncService 調度）。
class StatisticsSync {
  StatisticsSync(this._ref);

  final Ref _ref;

  /// 讀一次統計 provider，確保 prefs -> Isar 遷移已執行
  /// （遷移視為本機變更，會更新 lastModifiedAt）。上傳判斷前呼叫。
  void ensureMigrated() => _ref.read(statisticsControllerProvider);

  /// 主文件統計欄位（`days` + `monthlyTotals`）。兩者在同一個同步區塊內
  /// 讀取（中間無 await），與本機為同一快照；整份 set() 覆寫，
  /// 雲端明細與 totals 一致性不破。
  Map<String, Object> encodeFields() {
    final days = _ref.read(statisticsControllerProvider).days;
    final monthlyTotals = _ref
        .read(statisticsControllerProvider.notifier)
        .monthlyTotals();
    return {
      'days': days.toRemoteMap(),
      'monthlyTotals': monthlyTotals.toRemoteMap(),
    };
  }

  /// 還原雲端統計。[monthlyTotals] 為 null（v2 舊文件沒有此欄位）時
  /// 交由 controller 決定如何補（維持既有行為）。
  void restore(Object? days, Object? monthlyTotals) {
    _ref
        .read(statisticsControllerProvider.notifier)
        .restoreFromRemote(
          days.toDailyTrackStats(),
          monthlyTotals: monthlyTotals is Map
              ? monthlyTotals.toMonthlyTotals()
              : null,
        );
  }
}

final statisticsSyncProvider = Provider<StatisticsSync>(
  (ref) => StatisticsSync(ref),
);

/// 每日記錄 -> 雲端 `days` map 的編碼。
extension _DailyStatsRemoteEncode on List<DailyTrackStatEntity> {
  /// 攤平每日記錄為巢狀 map：`{ <day>: { <trackId>: { title, ... } } }`。
  Map<String, Map<String, Object>> toRemoteMap() {
    final result = <String, Map<String, Object>>{};
    for (final d in this) {
      (result[d.day] ??= {})[d.trackId] = {
        'title': d.title,
        'playCount': d.playCount,
        'listenMs': d.listenMs,
      };
    }
    return result;
  }
}

/// 月粒度 totals -> 雲端 `monthlyTotals` map 的編碼。
extension _MonthlyTotalsRemoteEncode on List<PeriodStatEntity> {
  /// 攤平月粒度 totals 為 map：`{ <yyyy-MM>: { playCount, listenMs } }`。
  Map<String, Map<String, Object>> toRemoteMap() => {
    for (final t in this)
      t.period: {'playCount': t.playCount, 'listenMs': t.listenMs},
  };
}

/// 雲端原始值（`Object?`）-> 統計實體的解碼，容錯：缺欄位給預設值、
/// 格式不符的條目跳過。
extension _RemoteStatsDecode on Object? {
  /// 解析雲端 days 巢狀 map。
  List<DailyTrackStatEntity> toDailyTrackStats() {
    final raw = this;
    if (raw is! Map) return const [];
    final entities = <DailyTrackStatEntity>[];
    raw.forEach((day, tracks) {
      if (tracks is! Map) return;
      tracks.forEach((trackId, value) {
        if (value is! Map) return;
        entities.add(
          DailyTrackStatEntity()
            ..day = '$day'
            ..trackId = '$trackId'
            ..title = (value['title'] as String?) ?? '$trackId'
            ..playCount = (value['playCount'] as num? ?? 0).toInt()
            ..listenMs = (value['listenMs'] as num? ?? 0).toInt(),
        );
      });
    });
    return entities;
  }

  /// 解析雲端 monthlyTotals map。
  List<PeriodStatEntity> toMonthlyTotals() {
    final raw = this;
    if (raw is! Map) return const [];
    final entities = <PeriodStatEntity>[];
    raw.forEach((month, value) {
      if (value is! Map) return;
      entities.add(
        PeriodStatEntity()
          ..period = '$month'
          ..playCount = (value['playCount'] as num? ?? 0).toInt()
          ..listenMs = (value['listenMs'] as num? ?? 0).toInt(),
      );
    });
    return entities;
  }
}
