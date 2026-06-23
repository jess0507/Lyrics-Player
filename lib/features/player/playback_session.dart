import '../music_list/track.dart';

/// 上一次播放的快照：用於 App 重啟後接續播放。
///
/// 只保存當下那一首曲目與其播放位置（不保存整個佇列）；還原時不依賴
/// 音樂庫掃描，直接以此重建音訊來源並定位到上次聽到的地方。
class PlaybackSession {
  const PlaybackSession({
    required this.track,
    required this.positionMs,
  });

  /// 上次播放的曲目。
  final Track track;

  /// 曲目內的播放位置（毫秒）。
  final int positionMs;
}
