import 'package:isar/isar.dart';

import 'track.dart';

part 'track_entity.g.dart';

/// [Track] 的 Isar 持久化模型。
///
/// 領域模型 [Track] 以字串（檔案 URI）為識別碼，而 Isar 需要 int 主鍵，
/// 因此另存 [trackId] 並建唯一索引，put 時以相同 trackId 取代（避免重複匯入）。
@collection
class TrackEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String trackId;

  late String uri;
  late String title;
  String? artist;
  int? durationMs;

  Track toTrack() => Track(
        id: trackId,
        uri: uri,
        title: title,
        artist: artist,
        durationMs: durationMs,
      );

  static TrackEntity fromTrack(Track t) => TrackEntity()
    ..trackId = t.id
    ..uri = t.uri
    ..title = t.title
    ..artist = t.artist
    ..durationMs = t.durationMs;
}
