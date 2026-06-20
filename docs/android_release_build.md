# Android 上架檔案建置

## 背景 / 問題

要上架 Google Play 需要的是 **Android App Bundle(`.aab`)**,而非 APK。
本文記錄如何用 `upload-keystore.jks` 簽章並產生上架用的 `.aab`。

## 結論

- 上架檔格式:`.aab`(App Bundle),由 Play 依裝置分發,體積比通用 APK 小。
- 簽章已透過 `android/key.properties` 接上 `upload-keystore.jks`,
  `flutter build appbundle --release` 會自動以 release 簽章建置,無需額外參數。
- 產物路徑:`build/app/outputs/bundle/release/app-release.aab`。

## 前置:確認簽章設定

`android/key.properties`(不進版控)需指向 keystore:

```properties
storePassword=<keystore 密碼>
keyPassword=<金鑰密碼>
keyAlias=upload
storeFile=/Users/jess/upload-keystore.jks
```

> keystore 的建立與 SHA 指紋取得見 [android_keystore_sha256.md](android_keystore_sha256.md)。

## 步驟

### 1. 建置上架 App Bundle

```bash
flutter build appbundle --release
```

完成後產出:

```
build/app/outputs/bundle/release/app-release.aab
```

版本號取自 `pubspec.yaml` 的 `version:`(例 `1.0.0+1`,
其中 `1.0.0` 為 versionName、`+1` 為 versionCode)。每次上架前需遞增 `+N`。

### 2. 驗證簽章(可選)

```bash
jarsigner -verify -verbose -certs \
  build/app/outputs/bundle/release/app-release.aab
```

於輸出找 `jar verified` 與憑證 `CN=...`,確認為 upload keystore 簽署。

### 3. 上傳

至 Play Console →「正式版 / 內部測試 → 建立新版本」上傳該 `.aab`。
若啟用 Play App Signing,Google 會以自家金鑰重簽,upload key 僅用於上傳驗證。

## 備註

- 若要產出可直接安裝測試的 APK,改用 `flutter build apk --release`
  (通用 APK 體積較大,約 240MB),或 `--split-per-abi` 拆分各 ABI。
- 體積主因為 `ffmpeg_kit_flutter_new` 內含各 ABI 原生庫;`.aab` 經 Play
  分發後使用者實際下載量會遠小於檔案本身。
