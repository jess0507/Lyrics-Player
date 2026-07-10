import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../../lyrics/auto_sync/lyrics_auto_sync_controller.dart';
import '../../lyrics/auto_sync/lyrics_auto_sync_service.dart';

/// 觸發自動對時:顯示不可關閉的進度對話框,完成後關閉並以 SnackBar 回報。
/// 成功時 service 已 invalidate [trackLyricsProvider],歌詞視圖自動切到同步。
/// 失敗保留原 unsynced 文字(後端不回半套時間)。
Future<void> runLyricsAutoSync(
  BuildContext context,
  WidgetRef ref, {
  required String trackId,
  required String title,
  required LyricsAlignEngine engine,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  final language = Localizations.localeOf(context).toLanguageTag();
  if (ref.read(lyricsAutoSyncControllerProvider(trackId)).isRunning) return;
  final controller = ref.read(
    lyricsAutoSyncControllerProvider(trackId).notifier,
  );

  // 對齊需時較久(壓縮 + 上傳 + Cloud Run);進度框不可手動關閉。
  unawaitedShowDialog(
    context: context,
    builder: (_) => _AutoSyncProgressDialog(trackId: trackId),
  );

  final ok = await controller.run(
    title: title,
    language: language,
    engine: engine,
  );

  navigator.pop(); // 關閉進度框
  if (ok) {
    messenger.showAppSnackBar(l10n.lyrics_auto_sync_success);
  } else {
    final error = ref.read(lyricsAutoSyncControllerProvider(trackId)).error;
    messenger.showAppSnackBar(_autoSyncErrorText(l10n, error));
  }
}

/// 不 await 的 showDialog(barrier 不可關閉),由呼叫端在流程結束後手動 pop。
void unawaitedShowDialog({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: builder,
  );
}

String _autoSyncErrorText(AppLocalizations l10n, LyricsAutoSyncError? error) =>
    switch (error) {
      LyricsAutoSyncError.notLoggedIn => l10n.lyrics_auto_sync_need_login,
      LyricsAutoSyncError.rateLimited => l10n.lyrics_auto_sync_rate_limited,
      LyricsAutoSyncError.noAudio => l10n.lyrics_auto_sync_no_audio,
      LyricsAutoSyncError.network => l10n.lyrics_auto_sync_network,
      _ => l10n.lyrics_auto_sync_failed,
    };

/// 進度對話框:顯示目前階段(處理音訊 / 上傳 / 對齊)。
class _AutoSyncProgressDialog extends ConsumerWidget {
  const _AutoSyncProgressDialog({required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final step = ref.watch(lyricsAutoSyncControllerProvider(trackId)).step;
    final label = switch (step) {
      LyricsAutoSyncStep.compressing => l10n.lyrics_auto_sync_compressing,
      LyricsAutoSyncStep.uploading => l10n.lyrics_auto_sync_uploading,
      LyricsAutoSyncStep.aligning || null => l10n.lyrics_auto_sync_aligning,
    };
    return AlertDialog(
      content: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: 20),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
