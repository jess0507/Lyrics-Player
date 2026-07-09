import 'package:isar_community/isar.dart';

part 'period_stat_entity.g.dart';

/// 預先聚合的「月」總量(一個月一筆),由 [DailyTrackStatEntity] 明細於
/// 寫入時同交易維護;缺漏時可隨時由明細全量重建,明細仍是事實來源。
///
/// 只存月粒度:day 粒度的數據已在 [DailyTrackStatEntity](每日 × 每曲),
/// 再存一份 day total 是冗餘,週/月視圖直接由明細範圍查詢聚合即可。
/// 月粒度則需獨立保存——它是未來明細截斷後的歷史總量退路,屆時無法再由明細導出。
@collection
class PeriodStatEntity {
  Id id = Isar.autoIncrement;

  /// 月 key `yyyy-MM`(字串排序即時間排序)。
  @Index(unique: true, replace: true)
  late String period;

  int playCount = 0;

  int listenMs = 0;
}
