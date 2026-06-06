import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences_service.dart';
import 'track.dart';

/// 本機音樂庫：透過 file_picker 匯入檔案，並持久化於 SharedPreferences。
///
/// 註：v1 以「使用者主動匯入」為主要來源；完整媒體庫自動掃描
/// （如 on_audio_query）可在此 repository 之上擴充。
class MusicLibrary extends Notifier<List<Track>> {
  static const _kKey = 'music.library';

  PreferencesService get _prefs => ref.read(preferencesServiceProvider);

  @override
  List<Track> build() => Track.decodeList(_prefs.getString(_kKey));

  /// 開啟系統檔案選擇器匯入音訊；回傳本次新增的數量。
  Future<int> importFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (result == null) return 0;

    final existing = {for (final t in state) t.id};
    final added = <Track>[];
    for (final file in result.files) {
      final path = file.path;
      if (path == null) continue;
      final uri = Uri.file(path).toString();
      if (existing.contains(uri)) continue;
      existing.add(uri);
      added.add(Track(id: uri, uri: uri, title: _titleFromName(file.name)));
    }
    if (added.isEmpty) return 0;

    state = [...state, ...added];
    _persist();
    return added.length;
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }

  /// 播放後若得知實際時長，回寫以利列表顯示與統計。
  void updateDuration(String id, Duration duration) {
    var changed = false;
    state = [
      for (final t in state)
        if (t.id == id && t.durationMs != duration.inMilliseconds)
          () {
            changed = true;
            return t.copyWith(durationMs: duration.inMilliseconds);
          }()
        else
          t,
    ];
    if (changed) _persist();
  }

  void _persist() => _prefs.setString(_kKey, Track.encodeList(state));

  static String _titleFromName(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return dot > 0 ? fileName.substring(0, dot) : fileName;
  }
}

final musicLibraryProvider =
    NotifierProvider<MusicLibrary, List<Track>>(MusicLibrary.new);

/// 音樂列表搜尋字串。
final musicSearchQueryProvider = StateProvider<String>((ref) => '');

/// 套用搜尋過濾後的曲目清單。
final filteredTracksProvider = Provider<List<Track>>((ref) {
  final tracks = ref.watch(musicLibraryProvider);
  final query = ref.watch(musicSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return tracks;
  return tracks.where((t) {
    return t.title.toLowerCase().contains(query) ||
        (t.artist?.toLowerCase().contains(query) ?? false);
  }).toList();
});
