# 登入系統:支援的登入方式

狀態:UI 與寄送已完成,Email Link reception / Firebase 設定待補
影響範圍:`lib/core/auth/`、`lib/features/profile/account/`
後端:Firebase Auth(Email 採 **Email Link / passwordless**)

## 政策:僅支援四種登入方式

App 登入**僅支援以下方式**,不支援其他任何登入方式(如 Apple、Facebook、手機號碼簡訊等一律不支援)。

| 方式 | 說明 | 後端 |
| --- | --- | --- |
| **Email(passwordless)** | 以 Firebase **Email Link** 登入(取代密碼):輸入 email → 寄送登入連結 → 點連結回 App 完成登入。 | Firebase Auth(Email Link) |
| **Google** | Google 帳號登入。 | Firebase Auth(Google provider) |
| **不登入** | 不建立任何帳號也能使用 App(音樂庫來自裝置 MediaStore,不需登入)。登入畫面僅作為「可選的同步入口」。 | 無(`currentUser == null`) |

> 「OTP」在本專案 = **Email Link(passwordless)**:寄到信箱的是登入連結而非數字驗證碼,因 Firebase 用戶端 SDK 無現成的數字 email OTP。
> **匿名登入(Firebase Anonymous)已移除**:不再呼叫 `signInAnonymously`,「不登入」= 未登入狀態(`currentUser == null`)。

## UI 行為(signed_out_view.dart)
- 顯示登入方式選項:**使用 Email 登入** / **使用 Google 登入**。
- 選「使用 Email 登入」後,於選項**上方**展開輸入表單(email 欄 + 「傳送登入連結」)。
- 選「Google」直接登入,不展開表單。

## 已完成
- `auth_service.dart`:移除密碼方法,新增 `sendSignInLink` / `isSignInLink` /
  `signInWithEmailLink`(使用 `ActionCodeSettings`,android `com.js.seek_player`、
  iOS `com.js.seekPlayer`)。
- `signed_out_view.dart`:重構為「選項 + 條件式表單」。
- l10n 新增 `account_method_email` / `account_send_link` / `account_link_sent`。
- **Deep link reception(程式面)**:新增 `email_link_controller.dart`
  (`EmailLinkController` + `emailLinkControllerProvider`),用 `app_links` 監聽
  冷啟 `getInitialLink` 與執行中 `uriLinkStream`;寄送時把 email 暫存到
  `SharedPreferences`(key `auth.pending_email_link`),回跳時以 `isSignInLink`
  判斷並呼叫 `signInWithEmailLink` 完成登入。`app.dart` 於啟動時 watch 此 provider。
  `signed_out_view` 改呼叫 `controller.sendLink`(才會暫存 email)。

## 待辦(後端 / 平台設定)
- **Firebase Console**:啟用 Email/Password → **Email link** 登入方式,並把連結網域
  加入 Authorized domains。
- **`ActionCodeSettings.url`**:`auth_service.dart` 中目前是 placeholder
  `https://seekplayer.example.com/signin`,需換成實際授權網域(Dynamic Links 已淘汰,
  改用 Hosting / App Links)。
- **平台 deep link 設定(reception 才會真正生效)**:Android `AndroidManifest.xml`
  需加對應網域的 `intent-filter`(App Links,含 `autoVerify`);iOS 需設定
  Associated Domains(`applinks:<網域>`)。**程式已串好,但未完成此設定前,點連結
  不會喚起 App,登入無法完成。**
- Google 登入需在 Firebase Console 設定 SHA-1 並產生 OAuth client。
- l10n 中 `account_continue_guest`、`account_anonymous`、`account_password`、
  `account_sign_up`、`account_forgot_password`、`account_reset_sent` 已不再使用
  (保留未刪);`account_guest` 仍作已登入畫面無名稱時的顯示 fallback。

## 相關檔案
- `lib/core/auth/auth_service.dart` — Firebase Auth 封裝
- `lib/core/auth/auth_state_provider.dart` — 登入狀態 provider
- `lib/features/profile/account/widgets/signed_out_view.dart` — 登入 UI
- `lib/features/profile/account/widgets/signed_in_view.dart` — 已登入 UI
