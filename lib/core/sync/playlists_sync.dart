import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/playlists/models/playlist_entity.dart';
import '../../features/playlists/services/playlist_repository.dart';

/// 播放清單與主文件 `playlists` 欄位（sync v4）的編解碼與還原
/// （SyncService 調度）。
class PlaylistsSync {
  PlaylistsSync(this._ref);

  final Ref _ref;

  /// 主文件 `playlists` 欄位內容。
  List<Map<String, Object>> encode() =>
      _ref.read(playlistRepositoryProvider).getAllSync().toRemoteList();

  /// 還原雲端 `playlists` 欄位（整份覆寫本機，含我的最愛）；
  /// v4 前的舊文件缺此欄位，格式不符時不動本機清單。
  Future<void> restore(Object? raw) async {
    if (raw is! List) return;
    await _ref
        .read(playlistRepositoryProvider)
        .restoreFromRemote(raw.toPlaylists());
  }
}

final playlistsSyncProvider = Provider<PlaylistsSync>(
  (ref) => PlaylistsSync(ref),
);

/// 播放清單 -> 雲端 `playlists` 陣列的編碼（保留 Isar 內的自然順序）。
/// trackIds 為檔案內容指紋，換裝置後只要同一份音檔存在即可對回曲目。
extension _PlaylistsRemoteEncode on List<PlaylistEntity> {
  List<Map<String, Object>> toRemoteList() => [
    for (final p in this)
      {
        'name': p.name,
        'isFavorites': p.isFavorites,
        'createdAt': p.createdAt.millisecondsSinceEpoch,
        'trackIds': p.trackIds,
      },
  ];
}

/// 雲端 `playlists` 陣列 -> 播放清單實體的解碼，容錯：缺欄位給預設值、
/// 格式不符的條目跳過。
extension _RemotePlaylistsDecode on List<dynamic> {
  List<PlaylistEntity> toPlaylists() => [
    for (final value in this)
      if (value is Map)
        PlaylistEntity()
          ..name = (value['name'] as String?) ?? ''
          ..isFavorites = (value['isFavorites'] as bool?) ?? false
          ..createdAt = DateTime.fromMillisecondsSinceEpoch(
            (value['createdAt'] as num? ?? 0).toInt(),
          )
          ..trackIds = [
            for (final t in (value['trackIds'] as List? ?? const [])) '$t',
          ],
  ];
}
