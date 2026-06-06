import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../core/audio/audio_player_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format.dart';
import 'playback_controller.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 確保背景統計 / 監聽器已啟動。
    ref.watch(playbackControllerProvider);
    final audio = ref.watch(audioPlayerServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tab_player)),
      body: StreamBuilder<SequenceState?>(
        stream: audio.player.sequenceStateStream,
        builder: (context, snapshot) {
          final sequenceState = snapshot.data;
          final currentItem = sequenceState?.currentSource?.tag;
          final title = currentItem is MediaItem
              ? currentItem.title
              : l10n.player_nothing_playing;
          final artist =
              currentItem is MediaItem ? currentItem.artist ?? '' : '';
          final hasTrack = currentItem is MediaItem;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                _Artwork(active: hasTrack),
                const SizedBox(height: 32),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (artist.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    artist,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
                const SizedBox(height: 32),
                _SeekBar(audio: audio, enabled: hasTrack),
                const SizedBox(height: 16),
                _Controls(audio: audio, enabled: hasTrack),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: scheme.surfaceContainerHighest,
        ),
        child: Icon(
          Icons.music_note,
          size: 96,
          color: active ? scheme.primary : scheme.outline,
        ),
      ),
    );
  }
}

class _SeekBar extends StatelessWidget {
  const _SeekBar({required this.audio, required this.enabled});

  final AudioPlayerService audio;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: audio.positionDataStream,
      builder: (context, snapshot) {
        final data =
            snapshot.data ?? const PositionData(Duration.zero, Duration.zero, Duration.zero);
        final total = data.duration.inMilliseconds.toDouble();
        final value = data.position.inMilliseconds
            .clamp(0, total == 0 ? 0 : total.toInt())
            .toDouble();
        return Column(
          children: [
            Slider(
              min: 0,
              max: total <= 0 ? 1 : total,
              value: total <= 0 ? 0 : value,
              onChanged: enabled && total > 0
                  ? (v) => audio.seek(Duration(milliseconds: v.round()))
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(data.position)),
                  Text(formatDuration(data.duration)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.audio, required this.enabled});

  final AudioPlayerService audio;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<bool>(
              stream: audio.shuffleModeEnabledStream,
              builder: (context, snapshot) {
                final shuffle = snapshot.data ?? false;
                return IconButton(
                  isSelected: shuffle,
                  onPressed: enabled
                      ? () => audio.setShuffle(!shuffle)
                      : null,
                  icon: const Icon(Icons.shuffle),
                );
              },
            ),
            IconButton(
              iconSize: 40,
              onPressed: enabled ? audio.seekToPrevious : null,
              icon: const Icon(Icons.skip_previous),
            ),
            _PlayPauseButton(audio: audio, enabled: enabled),
            IconButton(
              iconSize: 40,
              onPressed: enabled ? audio.seekToNext : null,
              icon: const Icon(Icons.skip_next),
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

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.audio, required this.enabled});

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
          onPressed: !enabled
              ? null
              : (playing ? audio.pause : audio.play),
          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
        );
      },
    );
  }
}
