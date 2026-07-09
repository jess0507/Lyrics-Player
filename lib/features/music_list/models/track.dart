import 'dart:convert';

/// 一首本機音訊曲目。
class Track {
  const Track({
    required this.id,
    required this.uri,
    required this.title,
    this.artist,
    this.album,
    this.albumId,
    this.durationMs,
  });

  /// 穩定識別碼（目前使用檔案 URI）。
  final String id;

  /// 可供 just_audio 載入的 URI（如 `file:///storage/.../song.mp3`）。
  final String uri;
  final String title;
  final String? artist;
  final String? album;

  /// MediaStore 專輯 id;供 `OnAudioQuery.queryArtwork(ArtworkType.ALBUM)`
  /// 取內嵌封面用,封面圖本身不存進 Track。
  final int? albumId;

  final int? durationMs;

  Duration? get duration =>
      durationMs == null ? null : Duration(milliseconds: durationMs!);

  Track copyWith({int? durationMs}) => Track(
        id: id,
        uri: uri,
        title: title,
        artist: artist,
        album: album,
        albumId: albumId,
        durationMs: durationMs ?? this.durationMs,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uri': uri,
        'title': title,
        'artist': artist,
        'album': album,
        'albumId': albumId,
        'durationMs': durationMs,
      };

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        id: json['id'] as String,
        uri: json['uri'] as String,
        title: json['title'] as String,
        artist: json['artist'] as String?,
        album: json['album'] as String?,
        albumId: json['albumId'] as int?,
        durationMs: json['durationMs'] as int?,
      );

  static String encodeList(List<Track> tracks) =>
      jsonEncode(tracks.map((t) => t.toJson()).toList());

  static List<Track> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Track.fromJson(e as Map<String, dynamic>))
        .toList(growable: true);
  }
}
