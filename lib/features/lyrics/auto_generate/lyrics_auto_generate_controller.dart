import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crash_reporter.dart';
import 'lyrics_auto_generate_service.dart';

/// 自動產生整體狀態。
enum LyricsAutoGenerateStatus { idle, running, success, failure }

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
}

final lyricsAutoGenerateControllerProvider =
    NotifierProvider.family<
      LyricsAutoGenerateController,
      LyricsAutoGenerateState,
      String
    >(LyricsAutoGenerateController.new);
