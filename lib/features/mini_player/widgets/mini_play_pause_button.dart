import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';

/// Mini player 的播放 / 暫停按鈕，載入中時顯示 spinner。
class MiniPlayPauseButton extends StatelessWidget {
  const MiniPlayPauseButton({super.key, required this.audio});

  final AudioPlayerService audio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<PlayerState>(
      stream: audio.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final processing = state?.processingState;
        final playing = state?.playing ?? false;

        if (processing == ProcessingState.loading ||
            processing == ProcessingState.buffering) {
          // 載入中的 spinner 不是按鈕，吞掉點擊避免穿透到外層 InkWell 觸發展開。
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: const SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }
        return IconButton(
          tooltip: playing ? l10n.player_pause : l10n.player_play,
          iconSize: 32,
          onPressed: playing ? audio.pause : audio.play,
          icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
        );
      },
    );
  }
}
