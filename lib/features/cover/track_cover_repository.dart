import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/storage/isar_service.dart';
import 'track_cover_entity.dart';

/// 自訂封面的 Isar CRUD。只存圖檔路徑,圖檔本體由 service 管理。
class TrackCoverRepository {
  TrackCoverRepository(this._isar);

  final Isar _isar;

  IsarCollection<TrackCoverEntity> get _col => _isar.trackCoverEntitys;

  /// 依 trackId 取封面(唯一索引);查無回 null。
  TrackCoverEntity? findByTrackId(String trackId) =>
      _col.getByTrackIdSync(trackId);

  /// upsert(唯一索引 replace:同曲覆蓋)。
  Future<void> save(TrackCoverEntity entity) =>
      _isar.writeTxn(() => _col.put(entity));

  /// 移除某曲封面紀錄。
  Future<void> deleteByTrackId(String trackId) =>
      _isar.writeTxn(() => _col.deleteByTrackId(trackId));
}

final trackCoverRepositoryProvider = Provider<TrackCoverRepository>(
  (ref) => TrackCoverRepository(ref.watch(isarProvider)),
);
