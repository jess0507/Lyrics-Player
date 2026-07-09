import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:seek_player/core/storage/isar_service.dart';
import 'package:seek_player/features/cover/models/track_cover_entity.dart';

/// 自訂封面的 Isar CRUD。只存圖檔路徑,圖檔本體由 service 管理。
class TrackCoverRepository {
  TrackCoverRepository(this._isar);

  final Isar _isar;

  IsarCollection<TrackCoverEntity> get _col => _isar.trackCoverEntitys;

  /// 依 trackId 取封面(唯一索引);查無回 null。
  TrackCoverEntity? findByTrackId(String trackId) =>
      _col.getByTrackIdSync(trackId);

  /// 取所有尚未快取主色([TrackCoverEntity.colorValue] 為 null)的封面,
  /// 供載入音樂後背景補算。
  List<TrackCoverEntity> findMissingColor() =>
      _col.filter().colorValueIsNull().findAllSync();

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
