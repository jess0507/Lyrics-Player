import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restart_app/restart_app.dart';

import '../../l10n/app_localizations.dart';
import '../../router/app_router.dart';
import '../../shared/widgets/app_snack_bar.dart';
import 'patch_update_controller.dart';

/// 監聽 Shorebird patch 更新狀態,下載完成時以 Dialog 詢問是否重新啟動。
///
/// 掛在 MaterialApp 的 builder 內,同時負責啟動背景更新檢查。
/// builder 位於 Navigator 之上,showDialog 需改用 [rootNavigatorKey]
/// 的 context。
class UpdateReadyListener extends ConsumerWidget {
  const UpdateReadyListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PatchUpdateState>(patchUpdateControllerProvider, (
      previous,
      next,
    ) {
      if (next != PatchUpdateState.restartReady) return;
      final navigatorContext = rootNavigatorKey.currentContext;
      if (navigatorContext == null) return;
      showDialog<void>(
        context: navigatorContext,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            content: Text(l10n.update_ready_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.update_later),
              ),
              FilledButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    // 整個 process 重啟,引擎冷啟動後載入新 patch。
                    Restart.restartApp();
                  } else {
                    // iOS 無法程式化重啟(exit 違反審核指引),
                    // 請使用者手動重開。
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.of(context).pop();
                    messenger.showAppSnackBar(l10n.update_restart_manual_hint);
                  }
                },
                child: Text(l10n.update_restart_action),
              ),
            ],
          );
        },
      );
    });
    return child;
  }
}
