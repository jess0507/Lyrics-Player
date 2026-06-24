import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import 'secondary_controls_menu.dart';

/// 次控制列圖示的固定大小。
const _kIconSize = 20.0;

/// 次控制列圖示的顏色（深灰色，未選取時）。
const _kIconColor = Colors.grey;

/// 次控制列：歌詞、隨機、循環,其餘動作(加入播放清單、播放速度、自動對時、
/// 字體大小、重新匯入、刪除歌詞)收進「更多」選單。
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
    final lyrics = _buildLyrics(context, ref);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ?lyrics,
          StreamBuilder<bool>(
            stream: audio.shuffleModeEnabledStream,
            builder: (context, snapshot) {
              final shuffle = snapshot.data ?? false;
              return IconButton(
                iconSize: _kIconSize,
                // 選取時用 primary 上色,與未選取的灰色明確區分。
                color: shuffle
                    ? Theme.of(context).colorScheme.primary
                    : _kIconColor,
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
              // 三種狀態以「顏色 + 圖示」區分:關閉(灰、repeat)、
              // 全部循環(primary、repeat)、單曲循環(primary、repeat_one)。
              final selected = mode != LoopMode.off;
              final icon = mode == LoopMode.one
                  ? Icons.repeat_one
                  : Icons.repeat;
              return IconButton(
                iconSize: _kIconSize,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : _kIconColor,
                isSelected: selected,
                onPressed: enabled ? () => _cycleLoop(mode) : null,
                icon: Icon(icon),
              );
            },
          ),
          IconButton(
            iconSize: _kIconSize,
            color: _kIconColor,
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            onPressed: enabled
                ? () => showSecondaryControlsMenuSheet(
                    context,
                    ref,
                    audio: audio,
                    trackId: trackId,
                    title: title,
                  )
                : null,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  /// 歌詞按鈕:有曲目時提供。點擊直接切到歌詞頁(無歌詞時由歌詞頁自身
  /// 顯示匯入提示,此處不觸發匯入)。
  Widget? _buildLyrics(BuildContext context, WidgetRef ref) {
    final id = trackId;
    if (id == null) return null;
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      iconSize: _kIconSize,
      color: _kIconColor,
      tooltip: l10n.lyrics_show,
      onPressed: enabled ? () => onShowLyricsPage?.call() : null,
      icon: const Icon(Icons.lyrics_outlined),
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
