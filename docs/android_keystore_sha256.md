# Android Keystore 與 SHA-256 指紋

## 背景 / 問題

Firebase（Google 登入 OAuth client）、Android App Links（`assetlinks.json`）等設定
都需要登記簽章憑證的 SHA-1 / SHA-256 指紋。本文記錄 keystore 的建立方式與各 variant
指紋的取得方式。

## 結論

- 最快的方式：`cd android && ./gradlew signingReport` 一次列出所有 variant 的指紋。
- Debug 與 Release 的指紋**不同**：debug keystore 每台機器各一份（每位開發者要各自登記）；
  release 用統一的 `upload-keystore.jks`（本機以 `android/key.properties` 接上，CI 以 secrets 還原）。
- 若啟用 Play App Signing，Google 重簽後的憑證又是另一組 SHA，也要登記。

## 步驟

1. 產生 release keystore（只需一次）。
2. 設定本機簽章（`android/key.properties`）。
3. 取得 SHA 指紋（signingReport / keytool，分 debug 與 release）。

## 各步驟說明

### 1. 產生 release keystore（只需一次，務必妥善保存）

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- 會詢問 keystore 密碼、金鑰密碼（可相同）與姓名/組織等資訊。
- 產生的 `upload-keystore.jks` **不要進版控**（`android/.gitignore` 已忽略
  `key.properties`；keystore 也請放在 repo 外或一併忽略）。
- ⚠️ keystore 一旦遺失將無法更新已上架的 App，請備份並記下密碼/alias。

### 2. 本機簽章設定（`android/key.properties`）

`android/app/build.gradle.kts` 會讀取 `android/key.properties`（存在才用 release
簽章，否則回退 debug）。內容：

```properties
storePassword=<keystore 密碼>
keyPassword=<金鑰密碼>
keyAlias=upload
storeFile=/絕對路徑/upload-keystore.jks
```

> CI 端不放這個檔，而是由 `KEYSTORE_BASE64` / `KEYSTORE_PASSWORD` / `KEY_ALIAS` /
> `KEY_PASSWORD` 等 secrets 在建置時還原（見 RELEASE_SETUP.md）。

### 3. 取得 SHA 指紋

#### (a) 一次列出所有 variant

```bash
cd android && ./gradlew signingReport
```

#### (b) Debug（本機開發）

本機未設定 release 簽章時，build 會回退使用 debug keystore：

```bash
keytool -list -v -alias androiddebugkey \
  -keystore ~/.android/debug.keystore \
  -storepass android -keypass android
```

> debug keystore 每台機器不同，每位開發者需各自登記自己的 SHA。

#### (c) Release（從 upload keystore）

```bash
keytool -list -v -keystore upload-keystore.jks -alias upload
```

輸入 keystore 密碼後，於 `Certificate fingerprints` 區找 **SHA256** 那行，
格式如 `AB:CD:EF:...`（冒號分隔的 32 組十六進位）。

> 若啟用 Play App Signing，Play Console →「設定 → 應用程式完整性」會顯示
> Google 重簽後的「應用程式簽署金鑰憑證」SHA，App Links / Firebase 也需登記該組。
