import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 全域「背景歌詞任務執行中」狀態(自動產生 / 對時共用;背景一次只跑一件)。
///
/// 由 [LyricsBackgroundRunner] 維護:前景服務啟動時設 true、收到結束事件
/// (done / error / cancelled)設 false;app 重啟時另以 native `isRunning`
/// 校正(任務可能由上一個 app instance 發起)。
/// UI(歌詞動作選單)據此停用「自動產生 / 自動對時」項目。
class LyricsBackgroundRunning extends Notifier<bool> {
  @override
  bool build() => false;

  /// 僅供 LyricsBackgroundRunner 更新。
  void set(bool value) => state = value;
}

final lyricsBackgroundRunningProvider =
    NotifierProvider<LyricsBackgroundRunning, bool>(
      LyricsBackgroundRunning.new,
    );
