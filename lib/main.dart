import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'app.dart';
import 'core/firebase_available_provider.dart';
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

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(prefs),
        firebaseAvailableProvider.overrideWithValue(firebaseAvailable),
      ],
      child: const SeekPlayerApp(),
    ),
  );
}
