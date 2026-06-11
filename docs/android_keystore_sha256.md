# Android Keystore 與 SHA-256 指紋

用途:App Links(Email Link 登入回跳)需要把 App 簽章的 **SHA-256 指紋** 寫進
`public/.well-known/assetlinks.json`;簽章本身則由 keystore 產生。本文記錄如何
產生 keystore 與取得 SHA-256。

> 相關設定見 [tasks/auth-supported-methods.md](../tasks/auth-supported-methods.md)、
> 簽章/上架見 [.github/workflows/RELEASE_SETUP.md](../.github/workflows/RELEASE_SETUP.md)。

---

## 1. 產生 release keystore(只需一次,務必妥善保存)

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- 會詢問 keystore 密碼、金鑰密碼(可相同)與姓名/組織等資訊。
- 產生的 `upload-keystore.jks` **不要進版控**(`android/.gitignore` 已忽略
  `key.properties`;keystore 也請放在 repo 外或一併忽略)。
- ⚠️ keystore 一旦遺失將無法更新已上架的 App,請備份並記下密碼/alias。

### 本機簽章設定(`android/key.properties`)

`android/app/build.gradle.kts` 會讀取 `android/key.properties`(存在才用 release
簽章,否則回退 debug)。內容:

```properties
storePassword=<keystore 密碼>
keyPassword=<金鑰密碼>
keyAlias=upload
storeFile=/絕對路徑/upload-keystore.jks
```

> CI 端不放這個檔,而是由 `KEYSTORE_BASE64` / `KEYSTORE_PASSWORD` / `KEY_ALIAS` /
> `KEY_PASSWORD` 等 secrets 在建置時還原(見 RELEASE_SETUP.md)。

---

## 2. 取得 SHA-256 指紋

### (a) 從 release / upload keystore

```bash
keytool -list -v -keystore upload-keystore.jks -alias upload
```

輸入 keystore 密碼後,於 `Certificate fingerprints` 區找 **SHA256** 那行,
格式如 `AB:CD:EF:...`(冒號分隔的 32 組十六進位)。把它貼到
`public/.well-known/assetlinks.json` 的 `sha256_cert_fingerprints`。

### (b) debug keystore(本機開發測試用)

debug 版簽章不同於 release,若要在 debug build 測 App Links,需另外把 debug 的
SHA-256 也加進 `assetlinks.json`(可放多組指紋):

```bash
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android
```

### (c) ⚠️ 若使用 Play App Signing(正式版關鍵)

啟用 Play App Signing 後,Google 會用**自己的金鑰重新簽章**,實際安裝到使用者
裝置的 App 指紋 ≠ 你的 upload keystore 指紋。此時 `assetlinks.json` 必須使用
**Google 重簽後的 SHA-256**,否則正式版 App Links 驗證會失敗。

取得位置:**Play Console → 你的 App → Test and release → App integrity →
App signing**,複製「App signing key certificate」的 SHA-256。
建議把 upload 與 Play 兩組指紋都放進 `assetlinks.json` 以涵蓋各情境。

---

## 3. 填入 assetlinks.json

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.js.seek_player",
      "sha256_cert_fingerprints": [
        "<release/upload 的 SHA-256>",
        "<Play App Signing 的 SHA-256(若有啟用)>"
      ]
    }
  }
]
```

改到 `public/` 後 push master 會觸發 Firebase Hosting 部署。部署後驗證:

```bash
curl https://seek-player-f724e.web.app/.well-known/assetlinks.json
```

並可在裝置上重新驗證 App Links:

```bash
adb shell pm verify-app-links --re-verify com.js.seek_player
adb shell am start -a android.intent.action.VIEW \
  -d "https://seek-player-f724e.web.app/signin"
```
