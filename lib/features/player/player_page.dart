import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../core/audio/audio_player_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format.dart';
import 'playback_controller.dart';

/// 以 modal bottom sheet 由下往上展開全螢幕播放器。
Future<void> showPlayerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) =>
        const FractionallySizedBox(heightFactor: 1, child: PlayerPage()),
  );
}

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 確保背景統計 / 監聽器已啟動。
    ref.watch(playbackControllerProvider);
    final audio = ref.watch(audioPlayerServiceProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        // 左上往下的箭頭：點擊收回成 mini player。
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
        // 標題顯示目前曲名 / 檔名，過長時跑馬燈滾動。
        // title: StreamBuilder<SequenceState?>(
        //   stream: audio.player.sequenceStateStream,
        //   builder: (context, snapshot) {
        //     final currentItem = snapshot.data?.currentSource?.tag;
        //     final title = currentItem is MediaItem
        //         ? currentItem.title
        //         : l10n.player_nothing_playing;
        //     return MarqueeText(
        //       title,
        //       style: Theme.of(context).appBarTheme.titleTextStyle ??
        //           Theme.of(context).textTheme.titleLarge,
        //     );
        //   },
        // ),
      ),
      body: StreamBuilder<SequenceState?>(
        stream: audio.player.sequenceStateStream,
        builder: (context, snapshot) {
          final sequenceState = snapshot.data;
          final currentItem = sequenceState?.currentSource?.tag;
          final title = currentItem is MediaItem
              ? currentItem.title
              : l10n.player_nothing_playing;
          final artist = currentItem is MediaItem
              ? currentItem.artist ?? ''
              : '';
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
            snapshot.data ??
            const PositionData(Duration.zero, Duration.zero, Duration.zero);
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

/// 快進 / 快退的單次步進量。
const _kSeekStep = Duration(seconds: 5);

class _Controls extends StatelessWidget {
  const _Controls({required this.audio, required this.enabled});

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
            _SeekHoldButton(
              audio: audio,
              enabled: enabled,
              delta: -_kSeekStep,
              icon: Icons.replay_5,
              tooltip: l10n.player_rewind,
            ),
            _PlayPauseButton(audio: audio, enabled: enabled),
            _SeekHoldButton(
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
            _SpeedButton(audio: audio, enabled: enabled),
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

/// 快進 / 快退按鈕：點擊一下步進 [delta]，持續長按時每 300ms 連續步進。
class _SeekHoldButton extends StatefulWidget {
  const _SeekHoldButton({
    required this.audio,
    required this.enabled,
    required this.delta,
    required this.icon,
    required this.tooltip,
  });

  final AudioPlayerService audio;
  final bool enabled;
  final Duration delta;
  final IconData icon;
  final String tooltip;

  @override
  State<_SeekHoldButton> createState() => _SeekHoldButtonState();
}

class _SeekHoldButtonState extends State<_SeekHoldButton> {
  Timer? _timer;

  void _startRepeat() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) => widget.audio.seekRelative(widget.delta),
    );
  }

  void _stopRepeat() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.enabled ? _startRepeat : null,
      onLongPressUp: _stopRepeat,
      child: IconButton(
        iconSize: 40,
        tooltip: widget.tooltip,
        onPressed: widget.enabled
            ? () => widget.audio.seekRelative(widget.delta)
            : null,
        icon: Icon(widget.icon),
      ),
    );
  }
}

/// 播放速度按鈕：顯示目前倍速，點擊開啟速度選擇對話框。
class _SpeedButton extends StatelessWidget {
  const _SpeedButton({required this.audio, required this.enabled});

  final AudioPlayerService audio;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: audio.speedStream,
      builder: (context, snapshot) {
        final speed = snapshot.data ?? 1.0;
        return TextButton.icon(
          onPressed: enabled
              ? () => _showSpeedDialog(context, audio, speed)
              : null,
          icon: const Icon(Icons.speed),
          label: Text('${speed.toStringAsFixed(1)}x'),
        );
      },
    );
  }
}

/// 速度選擇對話框：0.5x ~ 4.0x，間隔 0.1，調整時即時套用。
Future<void> _showSpeedDialog(
  BuildContext context,
  AudioPlayerService audio,
  double current,
) async {
  var value = current.clamp(0.5, 4.0);
  await showDialog<void>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.player_speed),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${value.toStringAsFixed(1)}x',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Slider(
                  min: 0.5,
                  max: 4.0,
                  divisions: 35,
                  value: value,
                  label: '${value.toStringAsFixed(1)}x',
                  onChanged: (v) {
                    final snapped = double.parse(v.toStringAsFixed(1));
                    setState(() => value = snapped);
                    audio.setSpeed(snapped);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  audio.setSpeed(1.0);
                  Navigator.of(context).pop();
                },
                child: Text(l10n.player_speed_reset),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.common_ok),
              ),
            ],
          );
        },
      );
    },
  );
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
          onPressed: !enabled ? null : (playing ? audio.pause : audio.play),
          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
        );
      },
    );
  }
}
