import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/isar_service.dart';
import 'period_stat_entity.dart';
import 'statistics_service.dart';

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
  const ChartPoint({required this.period, required this.listenTime});

  /// 期間 key:day `yyyy-MM-dd` 或 month `yyyy-MM`。
  final String period;

  final Duration listenTime;
}

/// 依視圖範圍提供折線圖 series:只對 `(kind, period)` 索引做點查,
/// 全程不碰每曲明細、不做聚合運算;缺期間(沒聽歌的天/月)補零。
///
/// watch [statisticsControllerProvider] 作為失效時機——addListenTime
/// 每 5 秒 commit 一次會觸發重查,但只撈 7~30 筆已聚合資料點,成本可忽略。
final chartSeriesProvider =
    Provider.family<List<ChartPoint>, ChartRange>((ref, range) {
  ref.watch(statisticsControllerProvider);
  final isar = ref.watch(isarProvider);
  final now = DateTime.now();
  final (kind, keys) = switch (range) {
    ChartRange.week => (PeriodKind.day, _dayKeys(now, 7)),
    ChartRange.month => (PeriodKind.day, _dayKeys(now, 30)),
    ChartRange.year => (PeriodKind.month, _monthKeys(now, 12)),
  };
  final totals = isar.periodStatEntitys.getAllByKindPeriodSync(
    List.filled(keys.length, kind),
    keys,
  );
  return [
    for (var i = 0; i < keys.length; i++)
      ChartPoint(
        period: keys[i],
        listenTime: Duration(milliseconds: totals[i]?.listenMs ?? 0),
      ),
  ];
});

/// 最近 [n] 天(含今天)的 day key,依時間升冪。
List<String> _dayKeys(DateTime now, int n) => [
      for (var i = n - 1; i >= 0; i--)
        StatisticsController.dayKey(
          DateTime(now.year, now.month, now.day - i),
        ),
    ];

/// 最近 [n] 個月(含本月)的 month key,依時間升冪。
List<String> _monthKeys(DateTime now, int n) => [
      for (var i = n - 1; i >= 0; i--)
        StatisticsController.monthKey(DateTime(now.year, now.month - i)),
    ];
