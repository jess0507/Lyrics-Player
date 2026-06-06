// 由 google-services.json 手動轉換而來（v1 僅支援 Android）。
// 若日後新增 iOS / 其他平台，請改用 `flutterfire configure` 重新產生此檔。
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web 尚未設定 Firebase，請執行 flutterfire configure。');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'v1 僅支援 Android，其他平台請見 becklog.md 並重新設定 Firebase。',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkoTV-Xch5bAQ43joZGqaCUq1DCPPdOT8',
    appId: '1:833102634982:android:e2cdb0dc42c9823a978027',
    messagingSenderId: '833102634982',
    projectId: 'seek-player-f724e',
    storageBucket: 'seek-player-f724e.firebasestorage.app',
  );
}
