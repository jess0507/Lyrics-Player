import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:seek_player/core/storage/isar_service.dart';
import 'package:seek_player/features/profile/statistics/models/daily_track_stat_entity.dart';
import 'package:seek_player/features/profile/statistics/models/period_stat_entity.dart';
import 'package:seek_player/features/profile/statistics/services/statistics_service.dart';

/// 統計圖表的視圖範圍(rolling window)。
enum ChartRange {
  /// 最近 7 天,一點 = 一天總量。
  week,

  /// 最近 30 天,一點 = 一天總量。
  month,

  /// 最近 12 個月,一點 = 一月總量。
  year,
}

/// 圖表單一資料點(已補零、依時間升冪)。
class ChartPoint {
  const ChartPoint({
    required this.period,
    required this.listenTime,
    required this.playCount,
  });

  /// 期間 key:day `yyyy-MM-dd` 或 month `yyyy-MM`。
  final String period;

  final Duration listenTime;

  final int playCount;
}

/// 依視圖範圍提供折線圖 series;缺期間(沒聽歌的天/月)補零。
///
/// - 週/月視圖:day 粒度。day 數據就是 [DailyTrackStatEntity] 明細,
///   對視窗範圍(7/30 天)做索引範圍查詢後在記憶體按日加總,不另存 day totals。
/// - 年視圖:month 粒度,直接點查預先聚合的 [PeriodStatEntity]。
///
/// watch [statisticsControllerProvider] 作為失效時機——addListenTime
/// 每 5 秒 commit 一次會觸發重查,但只撈最近 7~30 天明細 / 12 筆月總量,
/// 成本可忽略。
final chartSeriesProvider = Provider.family<List<ChartPoint>, ChartRange>((
  ref,
  range,
) {
  ref.watch(statisticsControllerProvider);
  final isar = ref.watch(isarProvider);
  final now = DateTime.now();
  return switch (range) {
    ChartRange.week => _dayPoints(isar, _dayKeys(now, 7)),
    ChartRange.month => _dayPoints(isar, _dayKeys(now, 30)),
    ChartRange.year => _monthPoints(isar, _monthKeys(now, 12)),
  };
});

/// day 視窗:對明細做 `day` 索引範圍查詢後按日加總,缺日補零。
List<ChartPoint> _dayPoints(Isar isar, List<String> keys) {
  final records = isar.dailyTrackStatEntitys
      .filter()
      .dayBetween(keys.first, keys.last)
      .findAllSync();
  final byDay = <String, ({int playCount, int listenMs})>{};
  for (final r in records) {
    final prev = byDay[r.day] ?? (playCount: 0, listenMs: 0);
    byDay[r.day] = (
      playCount: prev.playCount + r.playCount,
      listenMs: prev.listenMs + r.listenMs,
    );
  }
  return [
    for (final key in keys)
      ChartPoint(
        period: key,
        listenTime: Duration(milliseconds: byDay[key]?.listenMs ?? 0),
        playCount: byDay[key]?.playCount ?? 0,
      ),
  ];
}

/// month 視窗:點查預先聚合的月總量,缺月補零。
List<ChartPoint> _monthPoints(Isar isar, List<String> keys) {
  final totals = isar.periodStatEntitys.getAllByPeriodSync(keys);
  return [
    for (var i = 0; i < keys.length; i++)
      ChartPoint(
        period: keys[i],
        listenTime: Duration(milliseconds: totals[i]?.listenMs ?? 0),
        playCount: totals[i]?.playCount ?? 0,
      ),
  ];
}

/// 最近 [n] 天(含今天)的 day key,依時間升冪。
List<String> _dayKeys(DateTime now, int n) => [
  for (var i = n - 1; i >= 0; i--)
    StatisticsController.dayKey(DateTime(now.year, now.month, now.day - i)),
];

/// 最近 [n] 個月(含本月)的 month key,依時間升冪。
List<String> _monthKeys(DateTime now, int n) => [
  for (var i = n - 1; i >= 0; i--)
    StatisticsController.monthKey(DateTime(now.year, now.month - i)),
];
