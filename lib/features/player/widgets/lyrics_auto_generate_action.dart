import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seek_player/features/lyrics/auto_generate/lyrics_auto_generate_controller.dart';
import 'package:seek_player/features/lyrics/auto_generate/lyrics_auto_generate_service.dart';
import 'package:seek_player/features/player/widgets/lyrics_auto_sync_action.dart';
import 'package:seek_player/l10n/app_localizations.dart';
import 'package:seek_player/shared/widgets/app_snack_bar.dart';

/// 觸發自動產生歌詞:顯示不可關閉的進度對話框,完成後關閉並以 SnackBar 回報。
/// 成功時 service 已 invalidate `trackLyricsProvider`,歌詞視圖自動顯示產物。
/// 失敗不寫入(後端辨識不出歌詞時保持無歌詞狀態)。
Future<void> runLyricsAutoGenerate(
  BuildContext context,
  WidgetRef ref, {
  required String trackId,
  required String title,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  if (ref.read(lyricsAutoGenerateControllerProvider(trackId)).isRunning) {
    debugPrint('[LyricsAutoGen] 已在執行中,略過 trackId=$trackId');
    return;
  }
  final controller = ref.read(
    lyricsAutoGenerateControllerProvider(trackId).notifier,
  );

  debugPrint('[LyricsAutoGen] 開始 trackId=$trackId title="$title"');

  // 產生需時較久(壓縮 + 上傳 + Cloud Run ASR);進度框不可手動關閉。
  unawaitedShowDialog(
    context: context,
    builder: (_) => _AutoGenerateProgressDialog(trackId: trackId),
  );

  final ok = await controller.run(title: title);

  navigator.pop(); // 關閉進度框
  if (ok) {
    debugPrint('[LyricsAutoGen] 成功 trackId=$trackId');
    messenger.showAppSnackBar(l10n.lyrics_auto_generate_success);
  } else {
    final error = ref.read(lyricsAutoGenerateControllerProvider(trackId)).error;
    debugPrint('[LyricsAutoGen] 失敗 trackId=$trackId error=$error');
    messenger.showAppSnackBar(_autoGenerateErrorText(l10n, error));
  }
}

String _autoGenerateErrorText(
  AppLocalizations l10n,
  LyricsAutoGenerateError? error,
) => switch (error) {
  LyricsAutoGenerateError.notLoggedIn => l10n.lyrics_auto_generate_need_login,
  LyricsAutoGenerateError.rateLimited => l10n.lyrics_auto_generate_rate_limited,
  LyricsAutoGenerateError.noAudio => l10n.lyrics_auto_generate_no_audio,
  LyricsAutoGenerateError.network => l10n.lyrics_auto_generate_network,
  _ => l10n.lyrics_auto_generate_failed,
};

/// 進度對話框:顯示目前階段(處理音訊 / 上傳 / 產生歌詞)。
class _AutoGenerateProgressDialog extends ConsumerWidget {
  const _AutoGenerateProgressDialog({required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final step = ref.watch(lyricsAutoGenerateControllerProvider(trackId)).step;
    final label = switch (step) {
      LyricsAutoGenerateStep.compressing =>
        l10n.lyrics_auto_generate_compressing,
      LyricsAutoGenerateStep.uploading => l10n.lyrics_auto_generate_uploading,
      LyricsAutoGenerateStep.transcribing ||
      null => l10n.lyrics_auto_generate_transcribing,
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
