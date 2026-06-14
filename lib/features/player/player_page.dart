import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:seek_player/features/player/widgets/secondary_controls.dart';

import '../../core/audio/audio_player_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/marquee_text.dart';
import 'playback_controller.dart';
import 'widgets/lyrics_mode_menu.dart';
import 'widgets/lyrics_view.dart';
import 'widgets/player_artwork_panel.dart';
import 'widgets/player_controls.dart';
import 'widgets/seek_bar.dart';

class PlayerPage extends ConsumerStatefulWidget {
  const PlayerPage({super.key});

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {
  /// 是否進入歌詞滿版模式;無曲目時自動回退為封面。
  bool _showLyrics = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // 確保背景統計 / 監聽器已啟動。
    ref.watch(playbackControllerProvider);
    final audio = ref.watch(audioPlayerServiceProvider);

    return StreamBuilder<SequenceState?>(
      stream: audio.player.sequenceStateStream,
      builder: (context, snapshot) {
        final currentItem = snapshot.data?.currentSource?.tag;
        final mediaItem = currentItem is MediaItem ? currentItem : null;
        final hasTrack = mediaItem != null;
        final showLyrics = _showLyrics && hasTrack;

        final title = mediaItem?.title ?? l10n.player_nothing_playing;
        final artist = mediaItem?.artist ?? '';

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
            // 標題顯示目前曲名 / 檔名與演出者，過長時跑馬燈滾動。
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MarqueeText(
                  title,
                  style:
                      Theme.of(context).appBarTheme.titleTextStyle ??
                      Theme.of(context).textTheme.titleLarge,
                ),
                if (artist.isNotEmpty)
                  MarqueeText(
                    artist,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
              ],
            ),
            // 歌詞模式下,操作選單(含次控制列功能與關閉歌詞)移到右上角。
            actions: [
              if (showLyrics)
                LyricsModeMenu(
                  audio: audio,
                  trackId: mediaItem.id,
                  title: mediaItem.title,
                  onHideLyrics: () => setState(() => _showLyrics = false),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: showLyrics
                ? _LyricsLayout(
                    audio: audio,
                    trackId: mediaItem.id,
                    title: mediaItem.title,
                  )
                : _PlayerLayout(
                    audio: audio,
                    hasTrack: hasTrack,
                    onShowLyrics: hasTrack
                        ? () => setState(() => _showLyrics = true)
                        : null,
                  ),
          ),
        );
      },
    );
  }
}

/// 一般播放版面:封面、次控制列、進度條、主控制列。
class _PlayerLayout extends StatelessWidget {
  const _PlayerLayout({
    required this.audio,
    required this.hasTrack,
    required this.onShowLyrics,
  });

  final AudioPlayerService audio;
  final bool hasTrack;
  final VoidCallback? onShowLyrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        PlayerArtworkPanel(active: hasTrack, onShowLyrics: onShowLyrics),
        const Spacer(),
        SecondaryControls(audio: audio, enabled: hasTrack),
        const SizedBox(height: 16),
        SeekBar(audio: audio, enabled: hasTrack),
        const SizedBox(height: 12),
        PlayerControls(audio: audio, enabled: hasTrack),
        const Spacer(),
      ],
    );
  }
}

/// 歌詞滿版版面:上方歌詞佔滿剩餘空間,底部僅保留進度條與主控制列。
class _LyricsLayout extends StatelessWidget {
  const _LyricsLayout({
    required this.audio,
    required this.trackId,
    required this.title,
  });

  final AudioPlayerService audio;
  final String trackId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LyricsView(trackId: trackId, title: title),
        ),
        const SizedBox(height: 16),
        SeekBar(audio: audio, enabled: true),
        const SizedBox(height: 4),
        PlayerControls(audio: audio, enabled: true),
        const SizedBox(height: 4),
      ],
    );
  }
}
