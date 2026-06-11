import 'package:flutter/material.dart';

/// 播放器中央的專輯封面佔位圖。
class PlayerArtwork extends StatelessWidget {
  const PlayerArtwork({super.key, required this.active});

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
