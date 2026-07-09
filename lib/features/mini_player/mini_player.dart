import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../core/audio/audio_player_service.dart';
import '../../l10n/app_localizations.dart';
import '../cover/providers/track_artwork_provider.dart';
import '../player/providers/playback_controller.dart';
import '../player/providers/player_sheet_controller.dart';

/// 顯示於底部導覽列上方的迷你播放器。
///
/// 有正在播放的曲目時才顯示，呈現曲名與上一首 / 播放暫停 / 下一首按鈕；
/// 點擊本體（按鈕以外區域）會以 modal sheet 往上展開全螢幕播放器。
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 確保背景統計 / 監聽器已啟動（與全螢幕播放器共用同一個 controller）。
    ref.watch(playbackControllerProvider);
    final audio = ref.watch(audioPlayerServiceProvider);
    final scheme = Theme.of(context).colorScheme;

    return StreamBuilder<SequenceState?>(
      stream: audio.player.sequenceStateStream,
      builder: (context, snapshot) {
        final currentItem = snapshot.data?.currentSource?.tag;
        if (currentItem is! MediaItem) return const SizedBox.shrink();

        final title = currentItem.title;
        final artist = currentItem.artist ?? '';
        final cover = ref
            .watch(trackArtworkProvider(currentItem.id))
            .valueOrNull;

        return Material(
          color: scheme.surfaceContainerHighest,
          // 整個 mini player 點擊都展開全螢幕播放器；
          // IconButton 會自行攔截點擊，只觸發各自的播放控制事件。
          child: InkWell(
            onTap: () =>
                ref.read(playerSheetControllerProvider.notifier).open(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MiniProgressBar(audio: audio),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      if (cover != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image(
                            image: cover,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        SizedBox.shrink(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (artist.isNotEmpty)
                              Text(
                                artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: scheme.outline),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.player_previous,
                        onPressed: audio.seekToPrevious,
                        icon: const Icon(Icons.skip_previous),
                      ),
                      _MiniPlayPauseButton(audio: audio),
                      IconButton(
                        tooltip: l10n.player_next,
                        onPressed: audio.seekToNext,
                        icon: const Icon(Icons.skip_next),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Mini player 頂端的細進度條，反映目前播放位置。
class _MiniProgressBar extends StatelessWidget {
  const _MiniProgressBar({required this.audio});

  final AudioPlayerService audio;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<PositionData>(
      stream: audio.positionDataStream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final duration = data?.duration ?? Duration.zero;
        final position = data?.position ?? Duration.zero;
        final value = duration.inMilliseconds > 0
            ? (position.inMilliseconds / duration.inMilliseconds).clamp(
                0.0,
                1.0,
              )
            : 0.0;
        return LinearProgressIndicator(
          value: value,
          minHeight: 2,
          backgroundColor: scheme.surfaceContainerHighest,
          color: scheme.primary,
        );
      },
    );
  }
}

class _MiniPlayPauseButton extends StatelessWidget {
  const _MiniPlayPauseButton({required this.audio});

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
          onPressed: playing ? audio.pause : audio.play,
          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
        );
      },
    );
  }
}
