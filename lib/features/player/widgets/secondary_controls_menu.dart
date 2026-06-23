import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../lyrics/track_lyrics_provider.dart';
import '../../music_list/music_library.dart';
import '../../music_list/track.dart';
import '../../playlists/widgets/add_to_playlist_sheet.dart';
import 'lyrics_menu_action.dart';
import 'speed_button.dart';

/// 次控制列「更多」選單中,播放器層級(非歌詞)的動作項目。
/// 歌詞相關動作另以共用的 [LyricsMenuAction] 表示。
enum _PlayerMenuAction {
  /// 加入播放清單;能在音樂庫對應到曲目時顯示。
  addToPlaylist,

  /// 播放速度;一律顯示。
  speed;

  IconData get icon => switch (this) {
    addToPlaylist => Icons.playlist_add,
    speed => Icons.speed,
  };

  String label(AppLocalizations l10n) => switch (this) {
    addToPlaylist => l10n.playlist_add_to,
    speed => l10n.player_speed,
  };
}

/// 次控制列「更多」選單:把較不常用的動作(加入播放清單、播放速度、歌詞操作)
/// 收進此底部表單,讓控制列只保留高頻操作。對應 [LyricsModeMenu] 的選單,但不含
/// 「顯示封面(關閉歌詞)」—— 該動作只屬於歌詞滿版模式。
///
/// 後續動作(各面板 / 對話框)以呼叫端的 [context]/[ref] 開啟,
/// 避免本表單關閉後沿用已失效的 context。
void showSecondaryControlsMenuSheet(
  BuildContext context,
  WidgetRef ref, {
  required AudioPlayerService audio,
  String? trackId,
  String? title,
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => _SecondaryControlsMenuSheet(
      parentContext: context,
      parentRef: ref,
      audio: audio,
      trackId: trackId,
      title: title ?? '',
    ),
  );
}

class _SecondaryControlsMenuSheet extends ConsumerWidget {
  const _SecondaryControlsMenuSheet({
    required this.parentContext,
    required this.parentRef,
    required this.audio,
    required this.title,
    this.trackId,
  });

  /// 呼叫端(控制列)的 context 與 ref,用來開啟後續面板,生命週期不隨本表單結束。
  final BuildContext parentContext;
  final WidgetRef parentRef;

  final AudioPlayerService audio;
  final String title;
  final String? trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 只有能在音樂庫對應到曲目時才提供「加入播放清單」。
    final id = trackId;
    final tracks = ref.watch(musicLibraryProvider).valueOrNull ?? const [];
    final trackIndex = id == null ? -1 : tracks.indexWhere((t) => t.id == id);
    final track = trackIndex < 0 ? null : tracks[trackIndex];

    final lyrics = id == null
        ? null
        : ref.watch(trackLyricsProvider(id)).valueOrNull;
    final hasLyrics = lyrics != null && lyrics.isNotEmpty;
    // 對時是「補時間」:只在已有純文字、尚未同步時提供。
    final canAutoSync = hasLyrics && !lyrics.synced;
    final lyricsActions = lyricsMenuActions(
      canAutoSync: canAutoSync,
      hasLyrics: hasLyrics,
    );

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (track != null)
            _playerTile(context, _PlayerMenuAction.addToPlaylist, l10n, track),
          _playerTile(context, _PlayerMenuAction.speed, l10n),
          if (id != null)
            for (final action in lyricsActions)
              ListTile(
                leading: Icon(action.icon),
                title: Text(action.label(l10n)),
                onTap: () {
                  Navigator.of(context).pop();
                  runLyricsMenuAction(
                    parentContext,
                    parentRef,
                    action,
                    trackId: id,
                    title: title,
                  );
                },
              ),
        ],
      ),
    );
  }

  Widget _playerTile(
    BuildContext sheetContext,
    _PlayerMenuAction action,
    AppLocalizations l10n, [
    Track? track,
  ]) {
    return ListTile(
      leading: Icon(action.icon),
      title: Text(action.label(l10n)),
      onTap: () => _selectPlayer(sheetContext, action, track),
    );
  }

  /// 先關閉選單,再以呼叫端 context/ref 執行對應動作。
  void _selectPlayer(
    BuildContext sheetContext,
    _PlayerMenuAction action,
    Track? track,
  ) {
    Navigator.of(sheetContext).pop();
    switch (action) {
      case _PlayerMenuAction.addToPlaylist:
        if (track != null) {
          showAddToPlaylistSheet(parentContext, parentRef, track);
        }
      case _PlayerMenuAction.speed:
        showSpeedSheet(parentContext, audio);
    }
  }
}
