import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase Authentication 封裝：Email Link（passwordless）/ Google。
class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Email Link 的回跳設定。
  ///
  /// TODO(後端設定)：
  /// - [url] 需替換為實際在 Firebase Console「Authorized domains」中授權的
  ///   Hosting 連結網域（Dynamic Links 已淘汰，改用 Hosting / App Links）。
  /// - 並在 Firebase Console 啟用 Email/Password → Email link 登入方式。
  static final _signInLinkSettings = ActionCodeSettings(
    url: 'https://seekplayer.example.com/signin', // TODO: 換成實際授權網域
    handleCodeInApp: true,
    androidPackageName: 'com.js.seek_player',
    androidInstallApp: true,
    iOSBundleId: 'com.js.seekPlayer',
  );

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// 寄送 Email Link（passwordless / 取代密碼）。
  ///
  /// 使用者點擊信中連結後回到 App，再由 [signInWithEmailLink] 完成登入。
  Future<void> sendSignInLink(String email) => _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: _signInLinkSettings,
      );

  /// 判斷一個連結是否為 Email Link 登入連結。
  bool isSignInLink(String link) => _auth.isSignInWithEmailLink(link);

  /// 以 Email Link 完成登入（[email] 為當初請求連結的信箱）。
  Future<void> signInWithEmailLink(String email, String link) =>
      _auth.signInWithEmailLink(email: email, emailLink: link);

  /// Google 登入。需在 Firebase Console 設定 SHA-1 並產生 OAuth client，否則會失敗。
  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return; // 使用者取消
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});
