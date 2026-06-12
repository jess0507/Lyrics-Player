import 'package:isar/isar.dart';

part 'daily_track_stat_entity.g.dart';

/// 每日 × 每首歌的聆聽記錄（一天一首歌一筆），統計的唯一儲存來源。
///
/// 不存任何總和——累計總量、排行、每日總量皆由讀取時聚合導出。
/// 日期取裝置本地時區。
@collection
class DailyTrackStatEntity {
  Id id = Isar.autoIncrement;

  /// 本地日期，格式 `yyyy-MM-dd`（字串排序即時間排序）。
  @Index(unique: true, replace: true, composite: [CompositeIndex('trackId')])
  late String day;

  /// MediaStore ID（裝置綁定，換裝置會不同），因此 [title] 一併保存，
  /// 作為跨機聚合的對齊依據（顯示層以 title 聚合）。
  late String trackId;

  late String title;

  /// 當日該曲播放次數。
  int playCount = 0;

  /// 當日該曲聆聽時長（毫秒）。
  int listenMs = 0;
}
