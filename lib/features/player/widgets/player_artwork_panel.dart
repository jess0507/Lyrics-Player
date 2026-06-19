import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'player_artwork.dart';

/// 播放頁中央視覺區:顯示專輯封面,右上角提供切換到歌詞滿版模式的入口。
/// 歌詞本身由 [PlayerPage] 在滿版模式下顯示,不再於此面板內呈現。
/// [onShowLyrics] 為 null 時(無曲目)隱藏切換按鈕。
class PlayerArtworkPanel extends StatelessWidget {
  const PlayerArtworkPanel({
    super.key,
    required this.active,
    this.onShowLyrics,
  });

  final bool active;
  final VoidCallback? onShowLyrics;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: scheme.surfaceContainerHighest),
            ),
            Positioned.fill(child: PlayerArtwork(active: active)),
            if (onShowLyrics != null)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  tooltip: l10n.lyrics_show,
                  icon: const Icon(Icons.lyrics_outlined),
                  onPressed: onShowLyrics,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
