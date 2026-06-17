import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../lyrics/track_lyrics_provider.dart';
import 'lyrics_auto_sync_action.dart';
import 'speed_button.dart';

/// 次控制列圖示的固定大小。
const _kIconSize = 20.0;

/// 次控制列圖示的顏色（深灰色，未選取時）。
const _kIconColor = Colors.grey;

/// 次控制列：自動對時、隨機、播放速度、循環。
class SecondaryControls extends ConsumerWidget {
  const SecondaryControls({
    super.key,
    required this.audio,
    required this.enabled,
    this.trackId,
    this.title,
  });

  final AudioPlayerService audio;
  final bool enabled;

  /// 目前曲目 id；無曲目時為 null，不顯示自動對時。
  final String? trackId;

  /// 目前曲名，傳給對齊服務。
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAutoSync(context, ref),
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
        SpeedButton(
          audio: audio,
          enabled: enabled,
          iconSize: _kIconSize,
          iconColor: _kIconColor,
        ),
      ],
    );
  }

  /// 自動對時是「補時間」：只在已有純文字、尚未同步時提供，否則不佔位。
  Widget _buildAutoSync(BuildContext context, WidgetRef ref) {
    final id = trackId;
    if (id == null) return const SizedBox.shrink();
    final lyrics = ref.watch(trackLyricsProvider(id)).valueOrNull;
    final canAutoSync = lyrics != null && lyrics.isNotEmpty && !lyrics.synced;
    if (!canAutoSync) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      iconSize: _kIconSize,
      color: _kIconColor,
      tooltip: l10n.lyrics_auto_sync,
      onPressed: enabled
          ? () => runLyricsAutoSync(
              context,
              ref,
              trackId: id,
              title: title ?? '',
            )
          : null,
      icon: const Icon(Icons.auto_fix_high),
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
