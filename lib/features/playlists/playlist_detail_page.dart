import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/format.dart';
import '../player/playback_controller.dart';
import 'playlist_display_name.dart';
import 'playlist_repository.dart';
import 'playlist_tracks_provider.dart';
import 'playlists_provider.dart';

/// 單一播放清單內容:播放全部、逐首播放、移除、拖曳排序。
class PlaylistDetailPage extends ConsumerWidget {
  const PlaylistDetailPage({super.key, required this.playlistId});

  final int playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playlists = ref.watch(playlistsProvider).valueOrNull ?? const [];
    final playlist = playlists.where((p) => p.id == playlistId).firstOrNull;
    final tracks = ref.watch(playlistTracksProvider(playlistId));

    final title = playlist == null
        ? l10n.tab_playlists
        : playlistDisplayName(playlist, l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (tracks.isNotEmpty)
            IconButton(
              tooltip: l10n.playlist_play_all,
              icon: const Icon(Icons.play_arrow),
              onPressed: () => ref
                  .read(playbackControllerProvider)
                  .playTracksAt(tracks, 0),
            ),
        ],
      ),
      body: tracks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l10n.playlist_empty, textAlign: TextAlign.center),
              ),
            )
          : ReorderableListView.builder(
              itemCount: tracks.length,
              onReorderItem: (oldIndex, newIndex) {
                final ids = tracks.map((t) => t.id).toList();
                final moved = ids.removeAt(oldIndex);
                ids.insert(newIndex, moved);
                ref
                    .read(playlistRepositoryProvider)
                    .setTrackIds(playlistId, ids);
              },
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  key: ValueKey(track.id),
                  leading: const CircleAvatar(child: Icon(Icons.music_note)),
                  title: Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: track.artist == null
                      ? null
                      : Text(track.artist!, maxLines: 1),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (track.duration != null)
                        Text(formatDuration(track.duration!)),
                      IconButton(
                        tooltip: l10n.playlist_remove_track,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => ref
                            .read(playlistRepositoryProvider)
                            .removeTrack(playlistId, track.id),
                      ),
                    ],
                  ),
                  onTap: () => ref
                      .read(playbackControllerProvider)
                      .playTracksAt(tracks, index),
                );
              },
            ),
    );
  }
}
