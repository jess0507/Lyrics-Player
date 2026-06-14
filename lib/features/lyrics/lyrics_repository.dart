import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/storage/isar_service.dart';
import 'lyrics_entity.dart';

/// 歌詞的 Isar CRUD。儲存原文,解析交給讀取端(parser)。
class LyricsRepository {
  LyricsRepository(this._isar);

  final Isar _isar;

  IsarCollection<LyricsEntity> get _col => _isar.lyricsEntitys;

  /// 依 trackId 取歌詞(唯一索引);查無回 null。
  LyricsEntity? findByTrackId(String trackId) =>
      _col.getByTrackIdSync(trackId);

  /// upsert(唯一索引 replace:同曲覆蓋)。
  Future<void> save(LyricsEntity entity) =>
      _isar.writeTxn(() => _col.put(entity));

  /// 移除某曲歌詞。
  Future<void> deleteByTrackId(String trackId) =>
      _isar.writeTxn(() => _col.deleteByTrackId(trackId));
}

final lyricsRepositoryProvider = Provider<LyricsRepository>(
  (ref) => LyricsRepository(ref.watch(isarProvider)),
);
