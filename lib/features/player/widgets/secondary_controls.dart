import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import 'speed_button.dart';

/// 次控制列圖示的固定大小。
const _kIconSize = 20.0;

/// 次控制列圖示的顏色（深灰色，未選取時）。
const _kIconColor = Colors.black54;

/// 次控制列：隨機、播放速度、循環。
class SecondaryControls extends StatelessWidget {
  const SecondaryControls({
    super.key,
    required this.audio,
    required this.enabled,
  });

  final AudioPlayerService audio;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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

  void _cycleLoop(LoopMode current) {
    final next = switch (current) {
      LoopMode.off => LoopMode.all,
      LoopMode.all => LoopMode.one,
      LoopMode.one => LoopMode.off,
    };
    audio.setLoopMode(next);
  }
}
