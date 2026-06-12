import 'package:isar/isar.dart';

part 'track_stat_entity.g.dart';

/// 單一曲目的聆聽統計（一首歌一筆，總計由讀取時加總導出、不另存）。
///
/// [trackId] 為 MediaStore ID（裝置綁定，換裝置會不同），因此 [title]
/// 一併保存，作為跨機聚合的對齊依據（顯示層以 title 聚合排行）。
@collection
class TrackStatEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String trackId;

  late String title;

  /// 累計播放次數。
  int playCount = 0;

  /// 累計聆聽時長（毫秒）。
  int listenMs = 0;
}
