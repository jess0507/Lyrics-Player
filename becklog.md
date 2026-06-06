# Seek Player — 版本二 (v2) 規劃

> 本文件收錄 **延後到 v2** 的功能。主規劃見 [`plan.md`](plan.md)。
> v1 為 **Android 專案**；本文件規劃 **iOS 支援** 與 **Apple 登入**。

---

## 0. iOS 支援

v1 僅針對 Android 開發與發布。由於 Flutter 為跨平台框架，v2 擴充 iOS 時**業務邏輯與 UI 大多可直接沿用**，主要工作集中在平台設定、權限、原生整合與上架。

### 0.1 工作項目
1. **建立 iOS runner**：在既有專案執行 `flutter create --platforms=ios .`，產生 `ios/` 目錄。
2. **Bundle Identifier 與簽署**：設定 App ID、開發 / 發布憑證、Provisioning Profile（需 Apple Developer Program）。
3. **最低版本**：於 `ios/Podfile` 設定 `platform :ios, '13.0'`（依套件需求調整）。

### 0.2 權限（`ios/Runner/Info.plist`）
| Key | 用途 |
|-----|------|
| `NSAppleMusicUsageDescription` | 存取媒體 / 音樂資料庫 |
| `UIBackgroundModes` → `audio` | 背景播放 |
| （檔案匯入）`UISupportsDocumentBrowser` / Document Picker | 透過 Files App 匯入音訊 |

> iOS 沒有 Android 的執行期儲存權限模型；本機音樂多透過 **Media Library** 或 **Document Picker（檔案 App）** 取得，權限 Dialog 文案需對應調整。

### 0.3 套件平台差異檢查
- `just_audio` / `audio_service`：支援 iOS，需設定背景模式與 `AVAudioSession`。
- `permission_handler`：iOS 需在 Podfile 開啟對應 macro 並補 Info.plist 描述。
- `file_picker`：iOS 走 Document Picker。
- `google_sign_in`：iOS 需設 `GoogleService-Info.plist`、URL Scheme（反向 client id）。

### 0.4 Firebase（iOS）
- `flutterfire configure` 時加入 iOS app，下載 `GoogleService-Info.plist` 放入 `ios/Runner/`。
- Google 登入：在 Info.plist 加入反向 client id 的 URL Scheme。

### 0.5 上架
- App Store Connect 建立 App、隱私權標籤（Privacy Nutrition Labels）。
- ⚠️ 若提供 Google 登入，**必須**一併提供 Apple 登入（見下節）。

---

## 1. Apple 登入 (Sign in with Apple)

v1 已建好 Firebase Auth 架構（匿名 / Email / Google），v2 在既有架構上加入 Apple 登入。

### 1.1 為何延後
- 需 **Apple Developer Program**（年費 99 美元）帳號才能設定 capability。
- 需在 Apple Developer Console 設定 Service ID、Key、網域驗證（供 Firebase 回呼）。
- iOS App 上架 App Store 時，若提供第三方登入（如 Google），Apple 規定**必須**一併提供 Sign in with Apple；因此 v2 上架前必須完成。

### 1.2 技術選型（追加）
| 套件 | 用途 |
|------|------|
| `sign_in_with_apple` | 取得 Apple credential |
| `crypto` | 產生 nonce（防重放攻擊） |

### 1.3 前置設定
1. **Apple Developer**：
   - 啟用 App ID 的 **Sign in with Apple** capability。
   - 建立 **Service ID**（供 Android / Web 回呼用）。
   - 建立 **Sign in with Apple Key (.p8)**，記下 Key ID 與 Team ID。
2. **Firebase Console**：
   - Authentication → Sign-in method → 啟用 **Apple**。
   - 填入 Service ID、Apple Team ID、Key ID、私鑰內容。
3. **Xcode**：Runner target → Signing & Capabilities → 新增 **Sign in with Apple**。

### 1.4 實作要點
- 流程：產生 nonce → `SignInWithApple.getAppleIDCredential` → 以 `OAuthProvider("apple.com")` 建 Firebase credential → `signInWithCredential`。
- 注意 Apple **僅首次登入回傳姓名與 Email**，需在首次取得時保存。
- 支援匿名帳號 `linkWithCredential` 升級為 Apple 帳號。
- Android 走 Web 回呼流程（透過 Service ID 與 redirect URI）。

### 1.5 多語言字串（追加到 Google Sheet / CSV）
| key | description | en | zh_TW |
|-----|-------------|----|----|
| `auth_sign_in_apple` | 以 Apple 登入按鈕 | Sign in with Apple | 以 Apple 登入 |

> 加入後重跑 `dart run tool/gen_l10n_from_sheet.dart` 與 `flutter gen-l10n`。

---

## 2. 其他 v2 候選（待討論）
- 雲端同步統計數據（Firestore）。
- 線上音樂 / 串流來源。
- 播放清單分享。
