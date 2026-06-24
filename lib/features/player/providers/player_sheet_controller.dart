import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seek_player/features/player/player_page.dart';

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
        // 滿版:不留 safe area 空隙、不加圓角,覆蓋整個螢幕(含狀態列區)。
        // 內容的上 / 下系統列留白改由 PlayerPage 自行處理。
        useSafeArea: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(),
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
