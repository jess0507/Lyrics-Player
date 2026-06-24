import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/storage/isar_service.dart';
import 'playlist_entity.dart';

/// 播放清單的 Isar CRUD。曲目以有序 trackId 清單保存,解析交給讀取端。
class PlaylistRepository {
  PlaylistRepository(this._isar);

  final Isar _isar;

  IsarCollection<PlaylistEntity> get _col => _isar.playlistEntitys;

  /// 監聽所有播放清單(含初始值);排序交給衍生 provider。
  Stream<List<PlaylistEntity>> watchAll() =>
      _col.where().watch(fireImmediately: true);

  /// 確保預設「我的最愛」清單存在;[fallbackName] 僅作 DB 內存名,
  /// UI 會以在地化字串覆寫顯示。已存在則 no-op。
  Future<void> ensureDefaultFavorites(String fallbackName) async {
    final existing =
        _col.filter().isFavoritesEqualTo(true).findFirstSync();
    if (existing != null) return;
    await _isar.writeTxn(
      () => _col.put(
        PlaylistEntity()
          ..name = fallbackName
          ..isFavorites = true
          ..createdAt = DateTime.now(),
      ),
    );
  }

  /// 新增清單,回傳新 id。
  Future<int> create(String name) => _isar.writeTxn(
        () => _col.put(
          PlaylistEntity()
            ..name = name
            ..createdAt = DateTime.now(),
        ),
      );

  /// 改名(我的最愛由 UI 擋下,不會走到這裡)。
  Future<void> rename(int id, String name) => _isar.writeTxn(() async {
        final pl = await _col.get(id);
        if (pl == null) return;
        pl.name = name;
        await _col.put(pl);
      });

  Future<void> delete(int id) => _isar.writeTxn(() => _col.delete(id));

  /// 加入一首(已存在則不重覆附加)。
  Future<void> addTrack(int id, String trackId) => _isar.writeTxn(() async {
        final pl = await _col.get(id);
        if (pl == null || pl.trackIds.contains(trackId)) return;
        pl.trackIds = [...pl.trackIds, trackId];
        await _col.put(pl);
      });

  Future<void> removeTrack(int id, String trackId) =>
      _isar.writeTxn(() async {
        final pl = await _col.get(id);
        if (pl == null) return;
        pl.trackIds = pl.trackIds.where((t) => t != trackId).toList();
        await _col.put(pl);
      });

  /// 整批覆寫順序(拖曳排序用)。
  Future<void> setTrackIds(int id, List<String> trackIds) =>
      _isar.writeTxn(() async {
        final pl = await _col.get(id);
        if (pl == null) return;
        pl.trackIds = trackIds;
        await _col.put(pl);
      });
}

final playlistRepositoryProvider = Provider<PlaylistRepository>(
  (ref) => PlaylistRepository(ref.watch(isarProvider)),
);
