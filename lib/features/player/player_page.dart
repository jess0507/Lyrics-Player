import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../core/audio/audio_player_service.dart';
import '../../l10n/app_localizations.dart';
import 'playback_controller.dart';
import 'widgets/player_artwork.dart';
import 'widgets/player_controls.dart';
import 'widgets/seek_bar.dart';

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
                PlayerArtwork(active: hasTrack),
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
                SeekBar(audio: audio, enabled: hasTrack),
                const SizedBox(height: 16),
                PlayerControls(audio: audio, enabled: hasTrack),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
