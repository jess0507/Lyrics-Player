import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'lyrics_view.dart';
import 'player_artwork.dart';

/// 播放頁中央視覺區:在專輯封面與歌詞視圖間切換(右上角按鈕,擇一入口)。
/// 無曲目或無法顯示歌詞時僅顯示封面佔位。
class PlayerArtworkPanel extends StatefulWidget {
  const PlayerArtworkPanel({
    super.key,
    required this.active,
    this.trackId,
    this.title,
  });

  final bool active;
  final String? trackId;
  final String? title;

  @override
  State<PlayerArtworkPanel> createState() => _PlayerArtworkPanelState();
}

class _PlayerArtworkPanelState extends State<PlayerArtworkPanel> {
  bool _showLyrics = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final canShowLyrics = widget.active && widget.trackId != null;
    final showLyrics = _showLyrics && canShowLyrics;

    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 共用底色,讓歌詞文字在切換時都有可讀背景。
            Positioned.fill(
              child: ColoredBox(color: scheme.surfaceContainerHighest),
            ),
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: showLyrics
                    ? LyricsView(
                        key: const ValueKey('lyrics'),
                        trackId: widget.trackId!,
                        title: widget.title ?? '',
                      )
                    : PlayerArtwork(
                        key: const ValueKey('artwork'),
                        active: widget.active,
                      ),
              ),
            ),
            if (canShowLyrics)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  tooltip: showLyrics ? l10n.lyrics_hide : l10n.lyrics_show,
                  icon: Icon(
                    showLyrics ? Icons.image_outlined : Icons.lyrics_outlined,
                  ),
                  onPressed: () => setState(() => _showLyrics = !_showLyrics),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
