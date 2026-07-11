import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seek_player/core/audio/audio_player_service.dart';
import 'package:seek_player/features/music_list/providers/music_library.dart';
import 'package:seek_player/features/playlists/providers/playlists_provider.dart';
import 'package:seek_player/features/playlists/services/playlist_repository.dart';
import 'package:seek_player/l10n/app_localizations.dart';
import 'package:seek_player/shared/widgets/track_leading.dart';

/// 由下往上展開全螢幕「新增至這個播放清單」頁(開法同 PlayerPage)。
Future<void> showPlaylistAddTracksSheet(BuildContext context, int playlistId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    // 滿版:不留 safe area 空隙、不加圓角,覆蓋整個螢幕(含狀態列區)。
    // 內容的上 / 下系統列留白由頁面自行處理。
    useSafeArea: false,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(),
    builder: (_) => FractionallySizedBox(
      heightFactor: 1,
      child: PlaylistAddTracksPage(playlistId: playlistId),
    ),
  );
}

/// 列出整個音樂庫供挑選加入 [playlistId]:
/// 點擊 trailing 的「+」把該曲目加入清單,已在清單內則顯示打勾。
class PlaylistAddTracksPage extends ConsumerWidget {
  const PlaylistAddTracksPage({super.key, required this.playlistId});

  final int playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tracks = ref.watch(musicLibraryProvider).valueOrNull ?? const [];
    final playlists = ref.watch(playlistsProvider).valueOrNull ?? const [];
    final playlist = playlists.where((p) => p.id == playlistId).firstOrNull;
    final addedIds = playlist?.trackIds.toSet() ?? const <String>{};
    final audio = ref.watch(audioPlayerServiceProvider);
    final scheme = Theme.of(context).colorScheme;

    // 滿版 sheet(useSafeArea: false)會被 Flutter 以 removeTop 清掉頂部
    // inset,須從底層 View 讀回硬體 padding,讓 AppBar 落在狀態列下方。
    final media = MediaQuery.of(context);
    final devicePadding = MediaQueryData.fromView(View.of(context)).padding;
    final restoredMedia = media.copyWith(
      padding: media.padding.copyWith(top: devicePadding.top),
    );

    return MediaQuery(
      data: restoredMedia,
      child: Scaffold(
        appBar: AppBar(
          // 左上往下的箭頭:點擊收回本頁。
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.playlist_add_tracks,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: tracks.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(l10n.music_empty, textAlign: TextAlign.center),
                ),
              )
            : SafeArea(
                top: false,
                child: ListView.separated(
                  itemCount: tracks.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    final added = addedIds.contains(track.id);
                    void add() {
                      ref
                          .read(playlistRepositoryProvider)
                          .addTrack(playlistId, track.id);
                    }

                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 16.0),
                      leading: TrackLeading(
                        trackId: track.id,
                        isCurrent: false,
                        audio: audio,
                        color: scheme.primary,
                      ),
                      title: Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: track.artist == null
                          ? null
                          : Text(track.artist!, maxLines: 1),
                      trailing: added
                          ? IconButton(
                              icon: Icon(Icons.check, color: scheme.primary),
                              onPressed: null,
                            )
                          : IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: add,
                            ),
                      onTap: added ? null : add,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
