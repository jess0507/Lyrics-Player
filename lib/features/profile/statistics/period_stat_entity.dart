import 'package:isar/isar.dart';

part 'period_stat_entity.g.dart';

/// 期間粒度:day(週/月視圖用)/ month(年視圖與雲端備份用)。
enum PeriodKind { day, month }

/// 預先聚合的期間總量(一個期間一筆),由 [DailyTrackStatEntity] 明細
/// 於寫入時同交易維護;缺漏時可隨時由明細全量重建,明細仍是事實來源。
///
/// 圖表只讀這裡的少量資料點,不對全量明細做讀取時聚合。
@collection
class PeriodStatEntity {
  Id id = Isar.autoIncrement;

  /// 粒度:day / month。
  @Enumerated(EnumType.ordinal)
  @Index(unique: true, replace: true, composite: [CompositeIndex('period')])
  late PeriodKind kind;

  /// 期間 key:day `yyyy-MM-dd`、month `yyyy-MM`(字串排序即時間排序)。
  late String period;

  int playCount = 0;

  int listenMs = 0;
}
