import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seek_player/features/profile/statistics/providers/chart_selection_provider.dart';
import 'package:seek_player/features/profile/statistics/providers/chart_series_provider.dart';
import 'package:seek_player/features/profile/statistics/services/statistics_service.dart';

/// 「最常播放」排行,依圖表選取(範圍 + 觸碰節點)導出:
/// 未觸碰節點時為整個範圍視窗的排行,觸碰某期間則只算該期間。
///
/// 視窗與 [chartSeriesProvider] 一致(近 7/30 天、近 12 月),
/// 故排行與上方卡片/折線圖看的是同一段資料。
final selectedTopTracksProvider = Provider<List<TrackRanking>>((ref) {
  final selection = ref.watch(chartSelectionProvider);
  final stats = ref.watch(statisticsControllerProvider);
  final now = DateTime.now();

  final bool Function(String day) inScope;
  if (selection.touchedPeriod != null) {
    final period = selection.touchedPeriod!;
    // 年視圖節點為月(`yyyy-MM`),取該月所有日;其餘節點即單一日。
    inScope = selection.range == ChartRange.year
        ? (day) => day.startsWith('$period-')
        : (day) => day == period;
  } else {
    final keys = switch (selection.range) {
      ChartRange.week => _recentDayKeys(now, 7),
      ChartRange.month => _recentDayKeys(now, 30),
      ChartRange.year => _recentMonthKeys(now, 12),
    };
    inScope = selection.range == ChartRange.year
        ? (day) => keys.contains(day.substring(0, 7))
        : keys.contains;
  }

  final scoped = StatisticsData([
    for (final d in stats.days)
      if (inScope(d.day)) d,
  ]);
  return scoped.topTracks();
});

/// 近 [n] 天(含今天)的 day key 集合。
Set<String> _recentDayKeys(DateTime now, int n) => {
  for (var i = 0; i < n; i++)
    StatisticsController.dayKey(DateTime(now.year, now.month, now.day - i)),
};

/// 近 [n] 個月(含本月)的 month key 集合。
Set<String> _recentMonthKeys(DateTime now, int n) => {
  for (var i = 0; i < n; i++)
    StatisticsController.monthKey(DateTime(now.year, now.month - i)),
};
