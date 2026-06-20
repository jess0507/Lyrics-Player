import 'package:isar/isar.dart';

part 'track_cover_entity.g.dart';

/// 一首曲目的「使用者自訂封面」。Isar 只存圖檔路徑,實際圖檔落在 app 文件夾
/// `covers/` 下(Isar 不塞大 binary,圖檔放檔案系統可直接 `Image.file` 顯示)。
/// 純本機資料,綁定 MediaStore [trackId],不同步 Firestore(換機遺失可接受)。
@collection
class TrackCoverEntity {
  Id id = Isar.autoIncrement;

  /// MediaStore trackId(裝置綁定,同統計 / 歌詞的已知限制)。唯一索引 replace:
  /// 同一曲重複設定直接覆蓋舊封面。
  @Index(unique: true, replace: true)
  late String trackId;

  /// 複製到 app 文件夾後的封面圖檔絕對路徑。
  late String imagePath;

  late DateTime addedAt;
}
