import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lyrics.dart';
import 'lyrics_parser.dart';
import 'lyrics_repository.dart';

/// 依 trackId 查歌詞並解析為內部模型;查無回 null。顯示計畫
/// (`lyrics-display.md`)以目前曲目 id 消費本 provider;匯入後由
/// import service `invalidate` 對應 family 觸發重讀。
final trackLyricsProvider = FutureProvider.family<Lyrics?, String>(
  (ref, trackId) async {
    final entity = ref.watch(lyricsRepositoryProvider).findByTrackId(trackId);
    if (entity == null) return null;
    return parseLyrics(entity.content, entity.format);
  },
);
