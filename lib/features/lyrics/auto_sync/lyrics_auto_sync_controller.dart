import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crash_reporter.dart';
import 'lyrics_auto_sync_service.dart';

/// 對時整體狀態。
enum LyricsAutoSyncStatus { idle, running, success, failure }

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
}

final lyricsAutoSyncControllerProvider =
    NotifierProvider.family<
      LyricsAutoSyncController,
      LyricsAutoSyncState,
      String
    >(LyricsAutoSyncController.new);
