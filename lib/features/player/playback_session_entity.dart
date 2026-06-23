import 'package:isar/isar.dart';

part 'playback_session_entity.g.dart';

/// 單一曲目的播放進度（每首一列），供「切回某首時接續上次聽到的位置」與
/// App 重啟後還原最近一首。
///
/// 攤平存曲目欄位以便還原時不依賴音樂庫掃描。純本機資料，綁定 MediaStore
/// trackId（同統計 / 封面的已知限制），不同步 Firestore。
@collection
class PlaybackSessionEntity {
  Id id = Isar.autoIncrement;

  /// MediaStore trackId。唯一索引 replace：同一曲重複保存直接覆蓋進度。
  @Index(unique: true, replace: true)
  late String trackId;

  late String trackUri;
  late String trackTitle;
  String? trackArtist;
  int? trackDurationMs;

  /// 曲目內的播放位置（毫秒）。
  late int positionMs;

  /// 最近更新時間；App 重啟還原時取最新的一列。
  late DateTime updatedAt;
}
