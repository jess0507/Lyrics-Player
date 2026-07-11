import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// 回報已捕捉的非致命錯誤到 Crashlytics。
///
/// Firebase 未初始化(未設定 / 啟動時初始化失敗)時安靜略過;
/// debug build 由 main.dart 關閉收集,呼叫為 no-op。
void reportError(Object error, StackTrace stack, {String? reason}) {
  if (Firebase.apps.isEmpty) return;
  unawaited(
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
      fatal: false,
    ),
  );
}
