import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'app.dart';
import 'core/storage/isar_service.dart';
import 'core/storage/preferences_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 背景播放 / 通知列控制。
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.seek_player.audio',
    androidNotificationChannelName: 'Seek Player',
    androidNotificationOngoing: true,
  );

  // Firebase 初始化失敗（未設定 / 無網路）時不應阻擋 App 啟動。
  var firebaseAvailable = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseAvailable = true;
  } catch (e) {
    debugPrint('Firebase 初始化失敗，帳戶功能停用：$e');
  }

  final prefs = await PreferencesService.create();
  // 本地資料庫：媒體檔案資料存於 Isar；使用者設定仍由 SharedPreferences 管理。
  final isar = await openIsar();

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(prefs),
        isarProvider.overrideWithValue(isar),
        firebaseAvailableProvider.overrideWithValue(firebaseAvailable),
      ],
      child: const SeekPlayerApp(),
    ),
  );
}
