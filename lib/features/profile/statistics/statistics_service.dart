import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/preferences_service.dart';
import '../../music_list/track.dart';

/// 聆聽統計數據。
class StatisticsData {
  const StatisticsData({
    this.totalPlayCount = 0,
    this.totalListenMs = 0,
    this.perTrackCount = const {},
    this.trackTitles = const {},
  });

  final int totalPlayCount;
  final int totalListenMs;

  /// trackId -> 播放次數。
  final Map<String, int> perTrackCount;

  /// trackId -> 顯示標題（供「最常聽」清單使用）。
  final Map<String, String> trackTitles;

  Duration get totalListenTime => Duration(milliseconds: totalListenMs);

  /// 依播放次數排序的前幾名（標題, 次數）。
  List<MapEntry<String, int>> topTracks([int limit = 5]) {
    final entries = perTrackCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries
        .take(limit)
        .map((e) => MapEntry(trackTitles[e.key] ?? e.key, e.value))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'totalPlayCount': totalPlayCount,
        'totalListenMs': totalListenMs,
        'perTrackCount': perTrackCount,
        'trackTitles': trackTitles,
      };

  factory StatisticsData.fromJson(Map<String, dynamic> json) => StatisticsData(
        totalPlayCount: json['totalPlayCount'] as int? ?? 0,
        totalListenMs: json['totalListenMs'] as int? ?? 0,
        perTrackCount:
            (json['perTrackCount'] as Map?)?.map(
                  (k, v) => MapEntry(k as String, v as int),
                ) ??
                {},
        trackTitles:
            (json['trackTitles'] as Map?)?.map(
                  (k, v) => MapEntry(k as String, v as String),
                ) ??
                {},
      );
}

class StatisticsController extends Notifier<StatisticsData> {
  static const _kKey = 'statistics.data';

  PreferencesService get _prefs => ref.read(preferencesServiceProvider);

  @override
  StatisticsData build() {
    final raw = _prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return const StatisticsData();
    return StatisticsData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// 一首曲目開始播放時呼叫。
  void recordPlay(Track track) {
    final counts = Map<String, int>.from(state.perTrackCount);
    counts[track.id] = (counts[track.id] ?? 0) + 1;
    final titles = Map<String, String>.from(state.trackTitles)
      ..[track.id] = track.title;
    state = StatisticsData(
      totalPlayCount: state.totalPlayCount + 1,
      totalListenMs: state.totalListenMs,
      perTrackCount: counts,
      trackTitles: titles,
    );
    _persist();
  }

  /// 累加聆聽時長（例如曲目播放完成時）。
  void addListenTime(Duration duration) {
    if (duration <= Duration.zero) return;
    state = StatisticsData(
      totalPlayCount: state.totalPlayCount,
      totalListenMs: state.totalListenMs + duration.inMilliseconds,
      perTrackCount: state.perTrackCount,
      trackTitles: state.trackTitles,
    );
    _persist();
  }

  void reset() {
    state = const StatisticsData();
    _prefs.remove(_kKey);
  }

  void _persist() => _prefs.setString(_kKey, jsonEncode(state.toJson()));
}

final statisticsControllerProvider =
    NotifierProvider<StatisticsController, StatisticsData>(
  StatisticsController.new,
);
