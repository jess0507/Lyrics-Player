import 'package:flutter_test/flutter_test.dart';

import 'package:seek_player/features/profile/statistics/statistics_service.dart';
import 'package:seek_player/features/profile/statistics/track_stat_entity.dart';

TrackStatEntity _stat(String trackId, String title, int playCount,
    [int listenMs = 0]) {
  return TrackStatEntity()
    ..trackId = trackId
    ..title = title
    ..playCount = playCount
    ..listenMs = listenMs;
}

void main() {
  test('總計由 per-track 記錄加總導出', () {
    final data = StatisticsData([
      _stat('1', 'A', 3, 1000),
      _stat('2', 'B', 2, 500),
    ]);
    expect(data.totalPlayCount, 5);
    expect(data.totalListenMs, 1500);
    expect(data.totalListenTime, const Duration(milliseconds: 1500));
  });

  test('topTracks 以 title 聚合（吸收跨機 trackId 不一致）', () {
    final data = StatisticsData([
      _stat('1', 'Same Song', 3, 1000), // 舊裝置還原的記錄
      _stat('900', 'Same Song', 2, 500), // 新裝置另起的 entry
      _stat('2', 'Other', 4, 2000),
    ]);
    final top = data.topTracks();
    expect(top.length, 2);
    expect(top[0].title, 'Same Song');
    expect(top[0].playCount, 5);
    expect(top[0].listenTime, const Duration(milliseconds: 1500));
    expect(top[1].title, 'Other');
    expect(top[1].playCount, 4);
    expect(top[1].listenTime, const Duration(milliseconds: 2000));
  });

  test('topTracks 依次數排序並截斷至 limit', () {
    final data = StatisticsData([
      for (var i = 0; i < 10; i++) _stat('$i', 'T$i', i),
    ]);
    final top = data.topTracks(3);
    expect(top.map((e) => e.playCount), [9, 8, 7]);
  });

  test('空記錄為零統計', () {
    const data = StatisticsData([]);
    expect(data.totalPlayCount, 0);
    expect(data.totalListenMs, 0);
    expect(data.topTracks(), isEmpty);
  });
}
