import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import 'track.dart';

/// 本機音樂庫：直接掃描裝置 MediaStore（不複製檔案、不另存資料庫）。
///
/// 曲目以 MediaStore 的 content URI 播放，因此無需把檔案複製到 App 私有目錄；
/// 缺點是來源檔被刪除／移走後，重新掃描即不再出現（屬預期）。
class MusicLibrary extends AsyncNotifier<List<Track>> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Future<List<Track>> build() async {
    // build 不主動彈權限對話框；已授權才掃描，否則回空清單，
    // 待使用者於列表頁透過 refresh() 觸發授權流程。
    if (await Permission.audio.isGranted) {
      return _scan();
    }
    return const [];
  }

  /// 查詢裝置上所有音樂並映射為 [Track]。
  Future<List<Track>> _scan() async {
    final songs = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    return [
      for (final s in songs)
        if (s.isMusic ?? true)
          Track(
            id: s.id.toString(),
            uri: s.uri ?? Uri.file(s.data).toString(),
            title: s.title,
            artist: (s.artist == null || s.artist == '<unknown>')
                ? null
                : s.artist,
            durationMs: s.duration,
          ),
    ];
  }

  /// 重新掃描裝置音樂庫（權限應由呼叫端先確保）。
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_scan);
  }
}

final musicLibraryProvider =
    AsyncNotifierProvider<MusicLibrary, List<Track>>(MusicLibrary.new);
