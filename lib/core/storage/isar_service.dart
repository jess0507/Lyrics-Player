import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/cover/track_cover_entity.dart';
import '../../features/lyrics/lyrics_entity.dart';
import '../../features/playlists/playlist_entity.dart';
import '../../features/profile/statistics/daily_track_stat_entity.dart';
import '../../features/profile/statistics/period_stat_entity.dart';

/// 開啟 Isar 資料庫（資料儲存層：目前存放聆聽統計，使用者設定仍用
/// SharedPreferences）。
Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      DailyTrackStatEntitySchema,
      PeriodStatEntitySchema,
      LyricsEntitySchema,
      PlaylistEntitySchema,
      TrackCoverEntitySchema,
    ],
    directory: dir.path,
    name: 'seek_player',
  );
}

/// 於 main() 以 overrideWithValue 注入已開啟的實體。
final isarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError('isarProvider 必須被覆寫'),
);
