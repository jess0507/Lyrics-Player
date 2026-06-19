import 'package:flutter/material.dart';

/// 播放頁的漸層背景:由主題的 [ColorScheme] 推導,
/// 上方為 [ColorScheme.surface]、向下漸濃染上主題色。
///
/// 兩個端點都疊合在 `surface` 之上,因此深 / 淺色主題皆能取得柔和且
/// 與主題色一致的漸層;頂部與承載播放頁的 sheet 背景(同為 `surface`)
/// 無縫銜接。子內容(透明的 Scaffold)直接疊在漸層之上。
class PlayerBackground extends StatelessWidget {
  const PlayerBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.surface,
            Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.08),
              scheme.surface,
            ),
            Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.28),
              scheme.surface,
            ),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: child,
    );
  }
}
