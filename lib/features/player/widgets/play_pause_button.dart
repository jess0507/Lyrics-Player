import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';

/// 播放 / 暫停按鈕：載入或緩衝中時顯示轉圈進度。
class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, required this.audio, required this.enabled});

  final AudioPlayerService audio;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audio.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final processing = state?.processingState;
        final playing = state?.playing ?? false;

        if (processing == ProcessingState.loading ||
            processing == ProcessingState.buffering) {
          return const SizedBox(
            width: 64,
            height: 64,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return IconButton.filled(
          iconSize: 40,
          onPressed: !enabled ? null : (playing ? audio.pause : audio.play),
          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
        );
      },
    );
  }
}
