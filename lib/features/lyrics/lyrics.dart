/// 內部統一歌詞模型。四種來源格式(LRC / SRT / VTT / TXT)都收斂到這裡,
/// 顯示計畫(`lyrics-display.md`)亦 import 本檔。純資料類,不依賴 Isar。
class Lyrics {
  const Lyrics({required this.lines, required this.synced});

  /// 一首歌的所有歌詞行(同步歌詞已依時間升冪排序)。
  final List<LyricsLine> lines;

  /// 任一行帶時間戳即為同步歌詞(可隨播放高亮);全無時間戳則為靜態整篇。
  final bool synced;

  bool get isEmpty => lines.isEmpty;

  bool get isNotEmpty => lines.isNotEmpty;
}

/// 一行歌詞:文字加上可選的起始時間。
class LyricsLine {
  const LyricsLine({this.time, required this.text});

  /// 該行起始時間;null 表示此行不參與同步(unsynced / 純文字)。
  final Duration? time;

  final String text;
}
