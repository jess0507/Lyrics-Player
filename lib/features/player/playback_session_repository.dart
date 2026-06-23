import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/storage/isar_service.dart';
import '../music_list/track.dart';
import 'playback_session.dart';
import 'playback_session_entity.dart';

/// 逐曲播放進度的 Isar CRUD（每首一列，見 [PlaybackSessionEntity]）。
class PlaybackSessionRepository {
  PlaybackSessionRepository(this._isar);

  final Isar _isar;

  IsarCollection<PlaybackSessionEntity> get _col =>
      _isar.playbackSessionEntitys;

  /// 取某曲上次播放位置（毫秒）；查無回 null。
  int? positionFor(String trackId) => _col.getByTrackIdSync(trackId)?.positionMs;

  /// 最近一次播放的快照（供 App 重啟還原 mini player）；查無回 null。
  PlaybackSession? loadLast() {
    final e = _col.where().sortByUpdatedAtDesc().findFirstSync();
    return e == null ? null : _toSession(e);
  }

  /// 保存某曲的播放位置（依 trackId 唯一索引覆寫）。
  Future<void> save(Track track, int positionMs) {
    final entity = PlaybackSessionEntity()
      ..trackId = track.id
      ..trackUri = track.uri
      ..trackTitle = track.title
      ..trackArtist = track.artist
      ..trackDurationMs = track.durationMs
      ..positionMs = positionMs < 0 ? 0 : positionMs
      ..updatedAt = DateTime.now();
    return _isar.writeTxn(() => _col.put(entity));
  }

  /// 移除某曲進度（曲目載入失敗時呼叫）。
  Future<void> remove(String trackId) =>
      _isar.writeTxn(() => _col.deleteByTrackId(trackId));

  PlaybackSession _toSession(PlaybackSessionEntity e) => PlaybackSession(
        track: Track(
          id: e.trackId,
          uri: e.trackUri,
          title: e.trackTitle,
          artist: e.trackArtist,
          durationMs: e.trackDurationMs,
        ),
        positionMs: e.positionMs,
      );
}

final playbackSessionRepositoryProvider = Provider<PlaybackSessionRepository>(
  (ref) => PlaybackSessionRepository(ref.watch(isarProvider)),
);
