import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crash_reporter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/settings_controller.dart';
import '../background/lyrics_background_protocol.dart';
import '../background/lyrics_background_runner.dart';
import 'lyrics_auto_sync_service.dart';

/// 對時整體狀態。
enum LyricsAutoSyncStatus { idle, running, success, failure, cancelled }

/// 某曲對時的當前狀態:執行中帶 [step],失敗帶 [error]。
class LyricsAutoSyncState {
  const LyricsAutoSyncState({
    this.status = LyricsAutoSyncStatus.idle,
    this.step,
    this.error,
  });

  final LyricsAutoSyncStatus status;
  final LyricsAutoSyncStep? step;
  final LyricsAutoSyncError? error;

  bool get isRunning => status == LyricsAutoSyncStatus.running;
}

/// 以 trackId 為 key 的對時控制器:驅動 [LyricsAutoSyncService] 並把階段 /
/// 結果寫成 [LyricsAutoSyncState],供進度對話框與選單即時反映。
///
/// Android 交由 [LyricsBackgroundRunner](前景服務 + 背景 isolate)執行,
/// app 從最近工作列滑掉也繼續;其他平台維持在本 isolate 直接執行。
class LyricsAutoSyncController
    extends FamilyNotifier<LyricsAutoSyncState, String> {
  @override
  LyricsAutoSyncState build(String arg) => const LyricsAutoSyncState();

  /// 執行對時;成功回 true。已在執行中則忽略並回 false。
  /// [engine] 指定後端對齊引擎(aeneas / WhisperX)。
  Future<bool> run({
    required String title,
    required String language,
    required LyricsAlignEngine engine,
  }) async {
    if (state.isRunning) return false;
    state = const LyricsAutoSyncState(
      status: LyricsAutoSyncStatus.running,
      step: LyricsAutoSyncStep.compressing,
    );
    return Platform.isAndroid
        ? _runInBackground(title: title, language: language, engine: engine)
        : _runInline(title: title, language: language, engine: engine);
  }

  /// Android:走前景服務。通知文字在此以當前語系解析好隨請求帶出,
  /// 背景 isolate 不需存取 l10n。
  Future<bool> _runInBackground({
    required String title,
    required String language,
    required LyricsAlignEngine engine,
  }) async {
    final l10n = _lookupL10n();
    final result = await ref
        .read(lyricsBackgroundRunnerProvider)
        .run(
          LyricsBackgroundRequest(
            mode: LyricsBackgroundMode.align,
            trackId: arg,
            title: title,
            language: language,
            engineName: engine.wireName,
            stepLabels: {
              LyricsAutoSyncStep.compressing.name:
                  l10n.lyrics_auto_sync_compressing,
              LyricsAutoSyncStep.uploading.name: l10n.lyrics_auto_sync_uploading,
              LyricsAutoSyncStep.aligning.name: l10n.lyrics_auto_sync_aligning,
            },
            cancelLabel: l10n.common_cancel,
            doneLabel: l10n.lyrics_auto_sync_success,
            failedLabel: l10n.lyrics_auto_sync_failed,
          ),
          onStep: (stepName) {
            final step = LyricsAutoSyncStep.values.asNameMap()[stepName];
            if (step != null) {
              state = LyricsAutoSyncState(
                status: LyricsAutoSyncStatus.running,
                step: step,
              );
            }
          },
        );
    switch (result.status) {
      case LyricsBackgroundStatus.success:
        state = const LyricsAutoSyncState(status: LyricsAutoSyncStatus.success);
        return true;
      case LyricsBackgroundStatus.cancelled:
        state = const LyricsAutoSyncState(
          status: LyricsAutoSyncStatus.cancelled,
        );
        return false;
      case LyricsBackgroundStatus.busy:
        state = const LyricsAutoSyncState(
          status: LyricsAutoSyncStatus.failure,
          error: LyricsAutoSyncError.busy,
        );
        return false;
      case LyricsBackgroundStatus.error:
        state = LyricsAutoSyncState(
          status: LyricsAutoSyncStatus.failure,
          error:
              LyricsAutoSyncError.values.asNameMap()[result.errorName] ??
              LyricsAutoSyncError.unknown,
        );
        return false;
    }
  }

  /// 非 Android:於本 isolate 直接執行(原行為)。
  Future<bool> _runInline({
    required String title,
    required String language,
    required LyricsAlignEngine engine,
  }) async {
    try {
      await ref
          .read(lyricsAutoSyncServiceProvider)
          .autoSync(
            trackId: arg,
            title: title,
            language: language,
            engine: engine,
            onStep: (step) => state = LyricsAutoSyncState(
              status: LyricsAutoSyncStatus.running,
              step: step,
            ),
          );
      state = const LyricsAutoSyncState(status: LyricsAutoSyncStatus.success);
      return true;
    } on LyricsAutoSyncException catch (e) {
      state = LyricsAutoSyncState(
        status: LyricsAutoSyncStatus.failure,
        error: e.error,
      );
      return false;
    } catch (e, s) {
      reportError(e, s, reason: '歌詞對時：未預期錯誤');
      state = const LyricsAutoSyncState(
        status: LyricsAutoSyncStatus.failure,
        error: LyricsAutoSyncError.unknown,
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

final lyricsAutoSyncControllerProvider =
    NotifierProvider.family<
      LyricsAutoSyncController,
      LyricsAutoSyncState,
      String
    >(LyricsAutoSyncController.new);
