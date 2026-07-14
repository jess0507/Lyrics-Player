import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crash_reporter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/settings_controller.dart';
import '../background/lyrics_background_protocol.dart';
import '../background/lyrics_background_runner.dart';
import 'lyrics_auto_generate_service.dart';

/// 自動產生整體狀態。
enum LyricsAutoGenerateStatus { idle, running, success, failure, cancelled }

/// 某曲自動產生的當前狀態:執行中帶 [step],失敗帶 [error]。
class LyricsAutoGenerateState {
  const LyricsAutoGenerateState({
    this.status = LyricsAutoGenerateStatus.idle,
    this.step,
    this.error,
  });

  final LyricsAutoGenerateStatus status;
  final LyricsAutoGenerateStep? step;
  final LyricsAutoGenerateError? error;

  bool get isRunning => status == LyricsAutoGenerateStatus.running;
}

/// 以 trackId 為 key 的自動產生控制器:驅動 [LyricsAutoGenerateService] 並把
/// 階段 / 結果寫成 [LyricsAutoGenerateState],供進度對話框與選單即時反映。
///
/// Android 交由 [LyricsBackgroundRunner](前景服務 + 背景 isolate)執行,
/// app 從最近工作列滑掉也繼續;其他平台維持在本 isolate 直接執行。
class LyricsAutoGenerateController
    extends FamilyNotifier<LyricsAutoGenerateState, String> {
  @override
  LyricsAutoGenerateState build(String arg) => const LyricsAutoGenerateState();

  /// 執行自動產生;成功回 true。已在執行中則忽略並回 false。
  Future<bool> run({required String title}) async {
    if (state.isRunning) return false;
    state = const LyricsAutoGenerateState(
      status: LyricsAutoGenerateStatus.running,
      step: LyricsAutoGenerateStep.compressing,
    );
    return Platform.isAndroid
        ? _runInBackground(title: title)
        : _runInline(title: title);
  }

  /// Android:走前景服務。通知文字在此以當前語系解析好隨請求帶出,
  /// 背景 isolate 不需存取 l10n。
  Future<bool> _runInBackground({required String title}) async {
    final l10n = _lookupL10n();
    final result = await ref
        .read(lyricsBackgroundRunnerProvider)
        .run(
          LyricsBackgroundRequest(
            mode: LyricsBackgroundMode.generate,
            trackId: arg,
            title: title,
            stepLabels: {
              LyricsAutoGenerateStep.compressing.name:
                  l10n.lyrics_auto_generate_compressing,
              LyricsAutoGenerateStep.uploading.name:
                  l10n.lyrics_auto_generate_uploading,
              LyricsAutoGenerateStep.transcribing.name:
                  l10n.lyrics_auto_generate_transcribing,
            },
            cancelLabel: l10n.common_cancel,
            doneLabel: l10n.lyrics_auto_generate_success,
            failedLabel: l10n.lyrics_auto_generate_failed,
          ),
          onStep: (stepName) {
            final step = LyricsAutoGenerateStep.values.asNameMap()[stepName];
            if (step != null) {
              state = LyricsAutoGenerateState(
                status: LyricsAutoGenerateStatus.running,
                step: step,
              );
            }
          },
        );
    switch (result.status) {
      case LyricsBackgroundStatus.success:
        state = const LyricsAutoGenerateState(
          status: LyricsAutoGenerateStatus.success,
        );
        return true;
      case LyricsBackgroundStatus.cancelled:
        state = const LyricsAutoGenerateState(
          status: LyricsAutoGenerateStatus.cancelled,
        );
        return false;
      case LyricsBackgroundStatus.busy:
        state = const LyricsAutoGenerateState(
          status: LyricsAutoGenerateStatus.failure,
          error: LyricsAutoGenerateError.busy,
        );
        return false;
      case LyricsBackgroundStatus.error:
        state = LyricsAutoGenerateState(
          status: LyricsAutoGenerateStatus.failure,
          error:
              LyricsAutoGenerateError.values.asNameMap()[result.errorName] ??
              LyricsAutoGenerateError.unknown,
        );
        return false;
    }
  }

  /// 非 Android:於本 isolate 直接執行(原行為)。
  Future<bool> _runInline({required String title}) async {
    try {
      await ref
          .read(lyricsAutoGenerateServiceProvider)
          .generate(
            trackId: arg,
            title: title,
            onStep: (step) => state = LyricsAutoGenerateState(
              status: LyricsAutoGenerateStatus.running,
              step: step,
            ),
          );
      state = const LyricsAutoGenerateState(
        status: LyricsAutoGenerateStatus.success,
      );
      return true;
    } on LyricsAutoGenerateException catch (e) {
      state = LyricsAutoGenerateState(
        status: LyricsAutoGenerateStatus.failure,
        error: e.error,
      );
      return false;
    } catch (e, s) {
      reportError(e, s, reason: '自動產生歌詞：未預期錯誤');
      state = const LyricsAutoGenerateState(
        status: LyricsAutoGenerateStatus.failure,
        error: LyricsAutoGenerateError.unknown,
      );
      return false;
    }
  }

  /// 依 app 設定(未設則系統語系)解析 l10n;不支援的語系回退英文。
  AppLocalizations _lookupL10n() {
    final locale =
        ref.read(settingsControllerProvider).locale ??
        PlatformDispatcher.instance.locale;
    try {
      return lookupAppLocalizations(locale);
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }
}

final lyricsAutoGenerateControllerProvider =
    NotifierProvider.family<
      LyricsAutoGenerateController,
      LyricsAutoGenerateState,
      String
    >(LyricsAutoGenerateController.new);
