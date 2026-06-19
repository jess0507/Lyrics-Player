import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../lyrics/track_lyrics_provider.dart';
import '../../music_list/music_library.dart';
import '../../playlists/widgets/add_to_playlist_sheet.dart';
import 'lyrics_auto_sync_action.dart';
import 'lyrics_view.dart';
import 'speed_button.dart';

/// 次控制列圖示的固定大小。
const _kIconSize = 20.0;

/// 次控制列圖示的顏色（深灰色，未選取時）。
const _kIconColor = Colors.grey;

/// 次控制列：自動對時、歌詞、加入播放清單、播放速度、隨機、循環。
class SecondaryControls extends ConsumerWidget {
  const SecondaryControls({
    super.key,
    required this.audio,
    required this.enabled,
    this.trackId,
    this.title,
    this.onShowLyricsPage,
  });

  final AudioPlayerService audio;
  final bool enabled;

  /// 目前曲目 id；無曲目時為 null，不顯示自動對時。
  final String? trackId;

  /// 目前曲名，傳給對齊服務。
  final String? title;

  /// 切換封面面板到歌詞那一頁;由父層持有 PageController 後注入。
  final VoidCallback? onShowLyricsPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoSync = _buildAutoSync(context, ref);
    final lyrics = _buildLyrics(context, ref);
    final addToPlaylist = _buildAddToPlaylist(context, ref);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ?autoSync,
        ?lyrics,
        ?addToPlaylist,
        SpeedButton(
          audio: audio,
          enabled: enabled,
          iconSize: _kIconSize,
          iconColor: _kIconColor,
        ),
        StreamBuilder<bool>(
          stream: audio.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffle = snapshot.data ?? false;
            return IconButton(
              iconSize: _kIconSize,
              color: _kIconColor,
              isSelected: shuffle,
              onPressed: enabled ? () => audio.setShuffle(!shuffle) : null,
              icon: const Icon(Icons.shuffle),
            );
          },
        ),
        StreamBuilder<LoopMode>(
          stream: audio.loopModeStream,
          builder: (context, snapshot) {
            final mode = snapshot.data ?? LoopMode.off;
            final icon = switch (mode) {
              LoopMode.one => Icons.repeat_one,
              _ => Icons.repeat,
            };
            return IconButton(
              iconSize: _kIconSize,
              color: _kIconColor,
              isSelected: mode != LoopMode.off,
              onPressed: enabled ? () => _cycleLoop(mode) : null,
              icon: Icon(icon),
            );
          },
        ),
      ],
    );
  }

  /// 自動對時是「補時間」：只在已有純文字、尚未同步時提供，否則不佔位。
  Widget? _buildAutoSync(BuildContext context, WidgetRef ref) {
    final id = trackId;
    if (id == null) return null;
    final lyrics = ref.watch(trackLyricsProvider(id)).valueOrNull;
    final canAutoSync = lyrics != null && lyrics.isNotEmpty && !lyrics.synced;
    if (!canAutoSync) return null;
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      iconSize: _kIconSize,
      color: _kIconColor,
      tooltip: l10n.lyrics_auto_sync,
      onPressed: enabled
          ? () =>
                runLyricsAutoSync(context, ref, trackId: id, title: title ?? '')
          : null,
      icon: const Icon(Icons.auto_fix_high),
    );
  }

  /// 歌詞按鈕:有曲目時提供。點擊時若已有歌詞直接切到歌詞頁,否則先匯入
  /// 再切過去(匯入成功會 invalidate provider,歌詞頁自動顯示)。
  Widget? _buildLyrics(BuildContext context, WidgetRef ref) {
    final id = trackId;
    if (id == null) return null;
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      iconSize: _kIconSize,
      color: _kIconColor,
      tooltip: l10n.lyrics_show,
      onPressed: enabled ? () => _openLyrics(context, ref, id) : null,
      icon: const Icon(Icons.lyrics_outlined),
    );
  }

  Future<void> _openLyrics(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final lyrics = ref.read(trackLyricsProvider(id)).valueOrNull;
    final hasLyrics = lyrics != null && lyrics.isNotEmpty;
    if (!hasLyrics) {
      await runLyricsImport(context, ref, trackId: id, title: title ?? '');
    }
    onShowLyricsPage?.call();
  }

  /// 加入播放清單:有曲目且能在音樂庫對應到該曲時提供,否則回傳 null 不佔位。
  Widget? _buildAddToPlaylist(BuildContext context, WidgetRef ref) {
    final id = trackId;
    if (id == null) return null;
    final tracks = ref.watch(musicLibraryProvider).valueOrNull ?? const [];
    final index = tracks.indexWhere((t) => t.id == id);
    if (index < 0) return null;
    final track = tracks[index];
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      iconSize: _kIconSize,
      color: _kIconColor,
      tooltip: l10n.playlist_add_to,
      onPressed: enabled
          ? () => showAddToPlaylistSheet(context, ref, track)
          : null,
      icon: const Icon(Icons.playlist_add),
    );
  }

  void _cycleLoop(LoopMode current) {
    final next = switch (current) {
      LoopMode.off => LoopMode.all,
      LoopMode.all => LoopMode.one,
      LoopMode.one => LoopMode.off,
    };
    audio.setLoopMode(next);
  }
}
