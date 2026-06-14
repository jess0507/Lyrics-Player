import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../lyrics/lyrics_import_service.dart';
import '../../lyrics/lyrics_repository.dart';
import '../../lyrics/track_lyrics_provider.dart';
import '../lyrics_font_scale_controller.dart';
import 'lyrics_font_size_sheet.dart';
import 'lyrics_synced_view.dart';
import 'lyrics_unsynced_view.dart';

/// 完整播放頁的歌詞視圖:依 [trackId] 取歌詞並分派 loading / 空狀態 /
/// synced(同步捲動)/ unsynced(靜態整篇),並提供重新匯入、刪除歌詞選單。
/// mini player 不顯示歌詞,僅此處。
class LyricsView extends ConsumerWidget {
  const LyricsView({super.key, required this.trackId, required this.title});

  final String trackId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(trackLyricsProvider(trackId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      // 讀取失敗極少見,當作無歌詞處理,讓使用者可重新匯入。
      error: (_, _) => _EmptyLyrics(trackId: trackId, title: title),
      data: (lyrics) {
        if (lyrics == null || lyrics.isEmpty) {
          return _EmptyLyrics(trackId: trackId, title: title);
        }
        final scale = ref.watch(lyricsFontScaleProvider);
        final content = MediaQuery(
          // 僅縮放歌詞文字,不影響選單與版面間距。
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: lyrics.synced
              ? LyricsSyncedView(lyrics: lyrics)
              : LyricsUnsyncedView(lyrics: lyrics),
        );
        return Stack(
          children: [
            Positioned.fill(child: content),
            Align(
              alignment: Alignment.topLeft,
              child: _LyricsMenu(trackId: trackId, title: title),
            ),
          ],
        );
      },
    );
  }
}

/// 無歌詞空狀態:提示文字 + 匯入入口(呼叫匯入服務)。
class _EmptyLyrics extends ConsumerWidget {
  const _EmptyLyrics({required this.trackId, required this.title});

  final String trackId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lyrics_outlined, size: 48, color: scheme.outline),
          const SizedBox(height: 12),
          Text(
            l10n.lyrics_empty,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.outline),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () =>
                runLyricsImport(context, ref, trackId: trackId, title: title),
            icon: const Icon(Icons.file_open_outlined),
            label: Text(l10n.lyrics_import),
          ),
        ],
      ),
    );
  }
}

enum _LyricsAction { fontSize, reimport, delete }

/// 歌詞操作選單:字幕字體大小、重新匯入(覆蓋)、刪除歌詞(先確認)。
class _LyricsMenu extends ConsumerWidget {
  const _LyricsMenu({required this.trackId, required this.title});

  final String trackId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<_LyricsAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => switch (action) {
        _LyricsAction.fontSize => showLyricsFontSizeSheet(context),
        _LyricsAction.reimport => runLyricsImport(
          context,
          ref,
          trackId: trackId,
          title: title,
        ),
        _LyricsAction.delete => _confirmDelete(context, ref, l10n),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _LyricsAction.fontSize,
          child: Text(l10n.lyrics_font_size),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _LyricsAction.reimport,
          child: Text(l10n.lyrics_reimport),
        ),
        PopupMenuItem(
          value: _LyricsAction.delete,
          child: Text(l10n.lyrics_delete),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
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
  }
}

/// 觸發匯入並以 SnackBar 回報結果;取消選檔不提示。成功時匯入服務會
/// invalidate 對應的 [trackLyricsProvider],視圖自動重讀。空狀態與重新匯入共用。
Future<void> runLyricsImport(
  BuildContext context,
  WidgetRef ref, {
  required String trackId,
  required String title,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  try {
    final imported = await ref
        .read(lyricsImportServiceProvider)
        .importForTrack(trackId: trackId, title: title);
    if (!imported) return; // 使用者取消
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.lyrics_import_success)),
    );
  } on LyricsImportException catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(_importErrorText(l10n, e.error))),
    );
  }
}

String _importErrorText(AppLocalizations l10n, LyricsImportError error) =>
    switch (error) {
      LyricsImportError.tooLarge => l10n.lyrics_import_too_large,
      LyricsImportError.empty => l10n.lyrics_import_empty,
      LyricsImportError.unreadable => l10n.lyrics_import_failed,
    };
