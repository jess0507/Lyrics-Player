import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seek_player/features/playlists/models/playlist_entity.dart';
import 'package:seek_player/features/playlists/services/playlist_repository.dart';

/// 所有播放清單,排序為:我的最愛永遠在最前,其餘依建立時間由舊到新。
final playlistsProvider = StreamProvider<List<PlaylistEntity>>((ref) {
  final repo = ref.watch(playlistRepositoryProvider);
  return repo.watchAll().map((list) {
    final sorted = [...list]
      ..sort((a, b) {
        if (a.isFavorites != b.isFavorites) return a.isFavorites ? -1 : 1;
        return a.createdAt.compareTo(b.createdAt);
      });
    return sorted;
  });
});
