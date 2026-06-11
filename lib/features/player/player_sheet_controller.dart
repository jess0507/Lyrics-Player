import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'player_page.dart';

/// 播放器 sheet 的開關狀態與展開邏輯（viewmodel）。
///
/// state 代表 sheet 是否已開啟，避免快速連點時重複堆疊 PlayerPage。
class PlayerSheetController extends Notifier<bool> {
  @override
  bool build() => false;

  /// 由下往上展開全螢幕播放器；若已開啟則忽略。
  Future<void> open(BuildContext context) async {
    if (state) return;
    state = true;
    try {
      await showModalBottomSheet<void>(
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
    } finally {
      state = false;
    }
  }
}

final playerSheetControllerProvider =
    NotifierProvider<PlayerSheetController, bool>(PlayerSheetController.new);
