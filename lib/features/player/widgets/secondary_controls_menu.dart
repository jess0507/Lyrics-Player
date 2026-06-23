import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../lyrics/lyrics_repository.dart';
import '../../lyrics/track_lyrics_provider.dart';
import '../../music_list/music_library.dart';
import '../../music_list/track.dart';
import '../../playlists/widgets/add_to_playlist_sheet.dart';
import 'lyrics_auto_sync_action.dart';
import 'lyrics_font_size_sheet.dart';
import 'lyrics_view.dart';
import 'speed_button.dart';

/// 次控制列「更多」選單的動作項目。
/// 對應 [LyricsModeMenu] 的選單,但不含「顯示封面(關閉歌詞)」(hideLyrics):
/// 該動作只屬於歌詞滿版模式。
enum _MenuAction {
  /// 加入播放清單;能在音樂庫對應到曲目時顯示。
  addToPlaylist,

  /// 播放速度;一律顯示。
  speed,

  /// 自動對時;已有純文字、尚未同步時顯示。
  autoSync,

  /// 字體大小;已有歌詞時顯示。
  fontSize,

  /// 重新匯入歌詞;已有歌詞時顯示。
  reimport,

  /// 刪除歌詞;已有歌詞時顯示。
  delete;

  IconData get icon => switch (this) {
    addToPlaylist => Icons.playlist_add,
    speed => Icons.speed,
    autoSync => Icons.auto_fix_high,
    fontSize => Icons.text_fields,
    reimport => Icons.file_open_outlined,
    delete => Icons.delete_outline,
  };

  String label(AppLocalizations l10n) => switch (this) {
    addToPlaylist => l10n.playlist_add_to,
    speed => l10n.player_speed,
    autoSync => l10n.lyrics_auto_sync,
    fontSize => l10n.lyrics_font_size,
    reimport => l10n.lyrics_reimport,
    delete => l10n.lyrics_delete,
  };
}

/// 依目前狀態挑出要顯示的選單動作與順序。
List<_MenuAction> _menuActions({
  required bool hasTrack,
  required bool canAutoSync,
  required bool hasLyrics,
}) {
  return [
    if (hasTrack) _MenuAction.addToPlaylist,
    _MenuAction.speed,
    if (canAutoSync) _MenuAction.autoSync,
    if (hasLyrics) ...[
      _MenuAction.fontSize,
      _MenuAction.reimport,
      _MenuAction.delete,
    ],
  ];
}

/// 次控制列「更多」選單:把較不常用的動作(加入播放清單、播放速度、歌詞操作)
/// 收進此底部表單,讓控制列只保留高頻操作。
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

    final actions = _menuActions(
      hasTrack: track != null,
      canAutoSync: canAutoSync,
      hasLyrics: hasLyrics,
    );

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final action in actions)
            _tile(context, action, l10n, track),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext sheetContext,
    _MenuAction action,
    AppLocalizations l10n,
    Track? track,
  ) {
    return ListTile(
      leading: Icon(action.icon),
      title: Text(action.label(l10n)),
      onTap: () => _select(sheetContext, action, track),
    );
  }

  /// 先關閉選單,再以呼叫端 context/ref 執行對應動作。
  void _select(BuildContext sheetContext, _MenuAction action, Track? track) {
    Navigator.of(sheetContext).pop();
    final id = trackId;
    switch (action) {
      case _MenuAction.addToPlaylist:
        if (track != null) {
          showAddToPlaylistSheet(parentContext, parentRef, track);
        }
      case _MenuAction.speed:
        showSpeedSheet(parentContext, audio);
      case _MenuAction.autoSync:
        if (id != null) {
          runLyricsAutoSync(
            parentContext,
            parentRef,
            trackId: id,
            title: title,
          );
        }
      case _MenuAction.fontSize:
        showLyricsFontSizeSheet(parentContext);
      case _MenuAction.reimport:
        if (id != null) {
          runLyricsImport(parentContext, parentRef, trackId: id, title: title);
        }
      case _MenuAction.delete:
        if (id != null) _confirmDelete(id);
    }
  }

  Future<void> _confirmDelete(String id) async {
    final l10n = AppLocalizations.of(parentContext)!;
    final ok = await showDialog<bool>(
      context: parentContext,
      builder: (context) => AlertDialog(
        content: Text(l10n.lyrics_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await parentRef.read(lyricsRepositoryProvider).deleteByTrackId(id);
    parentRef.invalidate(trackLyricsProvider(id));
  }
}
