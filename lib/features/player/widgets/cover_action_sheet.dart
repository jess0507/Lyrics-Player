import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../cover/cover_import_service.dart';

/// 封面動作:`set` 新增 / 更換,`remove` 移除。
enum _CoverAction { set, remove }

/// 開啟封面動作選單。[hasCover] 為 true 時才提供「移除封面」。挑圖 / 移除後
/// 以 SnackBar 回饋,例外映射 l10n 失敗文案;使用者取消選圖不提示。
Future<void> showCoverActionSheet(
  BuildContext context,
  WidgetRef ref, {
  required String trackId,
  required bool hasCover,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final action = await showModalBottomSheet<_CoverAction>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_outlined),
            title: Text(hasCover ? l10n.cover_change : l10n.cover_add),
            onTap: () => Navigator.of(context).pop(_CoverAction.set),
          ),
          if (hasCover)
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.cover_remove),
              onTap: () => Navigator.of(context).pop(_CoverAction.remove),
            ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  final service = ref.read(coverImportServiceProvider);
  try {
    switch (action) {
      case _CoverAction.set:
        final done = await service.pickAndSetForTrack(trackId);
        if (!done) return; // 使用者取消
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.cover_updated)),
        );
      case _CoverAction.remove:
        await service.removeForTrack(trackId);
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.cover_removed)),
        );
    }
  } on CoverImportException catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(_errorText(l10n, e.error))),
    );
  }
}

String _errorText(AppLocalizations l10n, CoverImportError error) =>
    switch (error) {
      CoverImportError.tooLarge => l10n.cover_too_large,
      CoverImportError.unreadable => l10n.cover_failed,
    };
