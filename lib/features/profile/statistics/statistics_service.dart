import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/storage/isar_service.dart';
import '../../../core/storage/preferences_service.dart';
import '../../../core/sync/sync_state_store.dart';
import '../../music_list/track.dart';
import 'track_stat_entity.dart';

/// 聆聽統計：由 Isar 的 per-track 記錄導出的 view。
///
/// 不存任何總計欄位——總計與排行皆於讀取時由 [tracks] 加總導出，
/// 本機與雲端結構對稱，不會有「總計與明細對不上」的問題。
class StatisticsData {
  const StatisticsData(this.tracks);

  final List<TrackStatEntity> tracks;

  int get totalPlayCount =>
      tracks.fold(0, (sum, t) => sum + t.playCount);

  int get totalListenMs => tracks.fold(0, (sum, t) => sum + t.listenMs);

  Duration get totalListenTime => Duration(milliseconds: totalListenMs);

  /// 依播放次數排序的前幾名（標題、次數、聆聽時長）。
  ///
  /// 以 title 聚合：從雲端還原的記錄帶舊裝置的 trackId，同一首歌在新裝置
  /// 播放會另起一筆，聚合後排行才不會同曲分裂成兩列。
  List<TrackRanking> topTracks([int limit = 5]) {
    final byTitle = <String, ({int playCount, int listenMs})>{};
    for (final t in tracks) {
      final prev = byTitle[t.title] ?? (playCount: 0, listenMs: 0);
      byTitle[t.title] = (
        playCount: prev.playCount + t.playCount,
        listenMs: prev.listenMs + t.listenMs,
      );
    }
    final entries = [
      for (final e in byTitle.entries)
        TrackRanking(
          title: e.key,
          playCount: e.value.playCount,
          listenTime: Duration(milliseconds: e.value.listenMs),
        ),
    ]..sort((a, b) => b.playCount.compareTo(a.playCount));
    return entries.take(limit).toList();
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

class StatisticsController extends Notifier<StatisticsData> {
  /// 舊版 SharedPreferences 統計的 key，首次啟動遷移到 Isar 後移除。
  static const _kLegacyKey = 'statistics.data';

  Isar get _isar => ref.read(isarProvider);
  IsarCollection<TrackStatEntity> get _stats => _isar.trackStatEntitys;

  @override
  StatisticsData build() {
    _migrateFromPrefs();
    return _load();
  }

  StatisticsData _load() =>
      StatisticsData(_stats.where().findAllSync());

  /// 一首曲目開始播放時呼叫。
  void recordPlay(Track track) {
    _isar.writeTxnSync(() {
      final entity = _getOrCreate(track)..playCount += 1;
      entity.title = track.title;
      _stats.putSync(entity);
    });
    _afterWrite();
  }

  /// 累加該曲目的聆聽時長（播放期間定期取樣）。
  void addListenTime(Track track, Duration duration) {
    if (duration <= Duration.zero) return;
    _isar.writeTxnSync(() {
      final entity = _getOrCreate(track)
        ..listenMs += duration.inMilliseconds;
      _stats.putSync(entity);
    });
    _afterWrite();
  }

  /// 清空本機統計。雲端備份的刪除由呼叫端透過 SyncService 處理。
  void reset() {
    _isar.writeTxnSync(() => _stats.clearSync());
    _afterWrite();
  }

  /// 還原雲端備份（整份覆寫本機）。
  ///
  /// 還原不算本機變更：不更新 lastModifiedAt，避免還原後馬上又觸發上傳。
  void restoreFromRemote(List<TrackStatEntity> entities) {
    _isar.writeTxnSync(() {
      _stats.clearSync();
      _stats.putAllSync(entities);
    });
    state = _load();
  }

  TrackStatEntity _getOrCreate(Track track) =>
      _stats.getByTrackIdSync(track.id) ??
      (TrackStatEntity()
        ..trackId = track.id
        ..title = track.title);

  void _afterWrite() {
    state = _load();
    ref.read(syncStateStoreProvider).markModified();
  }

  /// 把舊版 prefs 統計（perTrackCount + trackTitles）匯入 Isar 後移除舊 key。
  ///
  /// 舊版的全域 totalListenMs 攤不進 per-track，直接捨棄（已知取捨）。
  void _migrateFromPrefs() {
    final prefs = ref.read(preferencesServiceProvider);
    final raw = prefs.getString(_kLegacyKey);
    if (raw == null) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final counts = (json['perTrackCount'] as Map?) ?? const {};
      final titles = (json['trackTitles'] as Map?) ?? const {};
      final entities = [
        for (final entry in counts.entries)
          TrackStatEntity()
            ..trackId = entry.key as String
            ..title = (titles[entry.key] as String?) ?? entry.key as String
            ..playCount = entry.value as int,
      ];
      if (entities.isNotEmpty) {
        _isar.writeTxnSync(() => _stats.putAllSync(entities));
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
