import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import 'play_pause_button.dart';
import 'seek_hold_button.dart';
import 'speed_button.dart';

/// 快進 / 快退的單次步進量。
const _kSeekStep = Duration(seconds: 5);

/// 播放控制區：主控制列（切歌、快進退、播放）與次控制列（隨機、速度、循環）。
class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key, required this.audio, required this.enabled});

  final AudioPlayerService audio;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // 主控制列：上一首、快退、播放/暫停、快進、下一首。
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              iconSize: 36,
              onPressed: enabled ? audio.seekToPrevious : null,
              icon: const Icon(Icons.skip_previous),
            ),
            SeekHoldButton(
              audio: audio,
              enabled: enabled,
              delta: -_kSeekStep,
              icon: Icons.replay_5,
              tooltip: l10n.player_rewind,
            ),
            PlayPauseButton(audio: audio, enabled: enabled),
            SeekHoldButton(
              audio: audio,
              enabled: enabled,
              delta: _kSeekStep,
              icon: Icons.forward_5,
              tooltip: l10n.player_forward,
            ),
            IconButton(
              iconSize: 36,
              onPressed: enabled ? audio.seekToNext : null,
              icon: const Icon(Icons.skip_next),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 次控制列：隨機、播放速度、循環。
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<bool>(
              stream: audio.shuffleModeEnabledStream,
              builder: (context, snapshot) {
                final shuffle = snapshot.data ?? false;
                return IconButton(
                  isSelected: shuffle,
                  onPressed: enabled ? () => audio.setShuffle(!shuffle) : null,
                  icon: const Icon(Icons.shuffle),
                );
              },
            ),
            SpeedButton(audio: audio, enabled: enabled),
            StreamBuilder<LoopMode>(
              stream: audio.loopModeStream,
              builder: (context, snapshot) {
                final mode = snapshot.data ?? LoopMode.off;
                final icon = switch (mode) {
                  LoopMode.one => Icons.repeat_one,
                  _ => Icons.repeat,
                };
                return IconButton(
                  isSelected: mode != LoopMode.off,
                  onPressed: enabled ? () => _cycleLoop(mode) : null,
                  icon: Icon(icon),
                );
              },
            ),
          ],
        ),
      ],
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
