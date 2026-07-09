import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

/// 依 trackId(MediaStore 歌曲 id)取音檔內嵌封面(ID3 等 tag 內的圖)。
/// 查無內嵌圖、或 id 非 MediaStore 數字 id 皆回 null,由上層退回佔位圖。
/// 檔案內容不會變動,family 天然快取即可,無需失效機制。
final embeddedArtworkProvider = FutureProvider.family<Uint8List?, String>((
  ref,
  trackId,
) async {
  final id = int.tryParse(trackId);
  if (id == null) return null;
  return OnAudioQuery().queryArtwork(
    id,
    ArtworkType.AUDIO,
    format: ArtworkFormat.JPEG,
    size: 600,
  );
});
