import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:seek_player/app.dart';
import 'package:seek_player/core/storage/preferences_service.dart';
import 'package:seek_player/features/music_list/music_library.dart';
import 'package:seek_player/features/music_list/track.dart';

/// 測試用音樂庫：不觸碰 Isar 原生資料庫，回傳空清單。
class _FakeMusicLibrary extends MusicLibrary {
  @override
  List<Track> build() => const [];
}

void main() {
  testWidgets('App boots to the music tab', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesService.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(prefs),
          musicLibraryProvider.overrideWith(_FakeMusicLibrary.new),
        ],
        child: const SeekPlayerApp(),
      ),
    );
    await tester.pump();

    // 預設語系 en：底部導覽應出現三個分頁標籤。
    expect(find.text('Music'), findsWidgets);
    expect(find.text('Player'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
