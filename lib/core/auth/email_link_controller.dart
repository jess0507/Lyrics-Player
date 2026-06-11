import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase_available_provider.dart';
import '../storage/preferences_service.dart';
import 'auth_service.dart';

/// 處理 Firebase Email Link(passwordless)的寄送與回跳完成登入。
///
/// - 寄送時暫存 email([sendLink]),供使用者點連結回到 App 時取用。
/// - 監聽進入 App 的連結(冷啟 [getInitialLink] 與執行中串流),
///   若為登入連結則以暫存 email 呼叫 [AuthService.signInWithEmailLink] 完成登入。
class EmailLinkController {
  EmailLinkController({
    required AuthService auth,
    required PreferencesService prefs,
  })  : _auth = auth,
        _prefs = prefs {
    _init();
  }

  static const _pendingEmailKey = 'auth.pending_email_link';

  final AuthService _auth;
  final PreferencesService _prefs;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// 寄送 Email Link,並暫存 email 供回跳時完成登入。
  Future<void> sendLink(String email) async {
    debugPrint('[EmailLink] sendLink: 準備寄送至 $email');
    await _prefs.setString(_pendingEmailKey, email);
    try {
      await _auth.sendSignInLink(email);
      debugPrint('[EmailLink] sendLink: 寄送成功 → $email');
    } catch (e, s) {
      debugPrint('[EmailLink] sendLink 失敗:$e\n$s');
      rethrow; // 交由 UI 顯示錯誤訊息
    }
  }

  Future<void> _init() async {
    try {
      final initial = await _appLinks.getInitialLink();
      debugPrint('[EmailLink] 初始連結:${initial ?? '(無)'}');
      if (initial != null) await _handleLink(initial);
    } catch (e, s) {
      debugPrint('[EmailLink] 初始連結處理失敗:$e\n$s');
    }
    _sub = _appLinks.uriLinkStream.listen(
      _handleLink,
      onError: (e, s) => debugPrint('[EmailLink] 連結串流錯誤:$e\n$s'),
    );
  }

  Future<void> _handleLink(Uri uri) async {
    final link = uri.toString();
    debugPrint('[EmailLink] 收到連結:$link');
    if (!_auth.isSignInLink(link)) {
      debugPrint('[EmailLink] 此連結非登入連結,略過');
      return;
    }
    final email = _prefs.getString(_pendingEmailKey);
    if (email == null) {
      debugPrint('[EmailLink] 收到登入連結但無暫存 email,無法完成登入');
      return;
    }
    debugPrint('[EmailLink] 以 $email 嘗試完成登入…');
    try {
      await _auth.signInWithEmailLink(email, link);
      await _prefs.remove(_pendingEmailKey);
      debugPrint('[EmailLink] 登入成功 → $email');
    } catch (e, s) {
      debugPrint('[EmailLink] 登入失敗:$e\n$s');
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}

/// Firebase 不可用時回傳 null(避免讀取 [authServiceProvider] 觸發
/// 未初始化的 FirebaseAuth)。於 App 啟動時被 watch 以建立並開始監聽。
final emailLinkControllerProvider = Provider<EmailLinkController?>((ref) {
  if (!ref.watch(firebaseAvailableProvider)) return null;
  final controller = EmailLinkController(
    auth: ref.watch(authServiceProvider),
    prefs: ref.watch(preferencesServiceProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});
