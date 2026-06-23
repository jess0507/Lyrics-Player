import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../lyrics/lyrics_repository.dart';
import '../../lyrics/track_lyrics_provider.dart';
import 'lyrics_auto_sync_action.dart';
import 'lyrics_font_size_sheet.dart';
import 'lyrics_view.dart';

/// 歌詞相關的選單動作,供「次控制列更多選單」與「歌詞滿版選單」共用。
/// 顯示與否由 [lyricsMenuActions] 依狀態決定,動作分派由 [runLyricsMenuAction] 處理。
enum LyricsMenuAction {
  /// 自動對時;已有純文字、尚未同步時顯示。
  autoSync,

  /// 字體大小;已有歌詞時顯示。
  fontSize,

  /// 重新匯入歌詞;已有歌詞時顯示。
  reimport,

  /// 刪除歌詞;已有歌詞時顯示。
  delete;

  IconData get icon => switch (this) {
    autoSync => Icons.auto_fix_high,
    fontSize => Icons.text_fields,
    reimport => Icons.file_open_outlined,
    delete => Icons.delete_outline,
  };

  String label(AppLocalizations l10n) => switch (this) {
    autoSync => l10n.lyrics_auto_sync,
    fontSize => l10n.lyrics_font_size,
    reimport => l10n.lyrics_reimport,
    delete => l10n.lyrics_delete,
  };
}

/// 依目前歌詞狀態挑出要顯示的歌詞動作與順序。
/// [canAutoSync] 為「已有純文字、尚未同步」;[hasLyrics] 為「已有歌詞」。
List<LyricsMenuAction> lyricsMenuActions({
  required bool canAutoSync,
  required bool hasLyrics,
}) {
  return [
    if (canAutoSync) LyricsMenuAction.autoSync,
    if (hasLyrics) ...[
      LyricsMenuAction.fontSize,
      LyricsMenuAction.reimport,
      LyricsMenuAction.delete,
    ],
  ];
}

/// 執行歌詞選單動作。[onDeleted] 於成功刪除歌詞後呼叫(例如退回封面)。
Future<void> runLyricsMenuAction(
  BuildContext context,
  WidgetRef ref,
  LyricsMenuAction action, {
  required String trackId,
  required String title,
  VoidCallback? onDeleted,
}) async {
  switch (action) {
    case LyricsMenuAction.autoSync:
      await runLyricsAutoSync(context, ref, trackId: trackId, title: title);
    case LyricsMenuAction.fontSize:
      showLyricsFontSizeSheet(context);
    case LyricsMenuAction.reimport:
      await runLyricsImport(context, ref, trackId: trackId, title: title);
    case LyricsMenuAction.delete:
      await _confirmDelete(context, ref, trackId, onDeleted);
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  String trackId,
  VoidCallback? onDeleted,
) async {
  final l10n = AppLocalizations.of(context)!;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(l10n.lyrics_delete_confirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.common_cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.common_delete),
        ),
      ],
    ),
  );
  if (ok != true) return;
  await ref.read(lyricsRepositoryProvider).deleteByTrackId(trackId);
  ref.invalidate(trackLyricsProvider(trackId));
  onDeleted?.call();
}
