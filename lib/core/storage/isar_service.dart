import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/music_list/track_entity.dart';

/// 開啟 Isar 資料庫（僅存放 audio / media file data，使用者設定改用 SharedPreferences）。
Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [TrackEntitySchema],
    directory: dir.path,
    name: 'seek_player',
  );
}

/// 於 main() 以 overrideWithValue 注入已開啟的實體。
final isarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError('isarProvider 必須被覆寫'),
);
