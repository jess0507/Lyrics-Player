# Android Keystore 與 SHA-256 指紋


### 一次列出所有 variant 的指紋
```
cd android && ./gradlew signingReport
```

## Debug（本機開發）
本機未設定 release 簽章時，build 會回退使用 debug keystore：
```
keytool -list -v -alias androiddebugkey \
  -keystore ~/.android/debug.keystore \
  -storepass android -keypass android
```

> debug keystore 每台機器不同，每位開發者需各自登記自己的 SHA。

## Release（正式簽章）

### 1. 產生 release keystore(只需一次,務必妥善保存)

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

### 2. 取得 SHA-256 指紋, 從 release / upload keystore

```bash
keytool -list -v -keystore upload-keystore.jks -alias upload
```

輸入 keystore 密碼後,於 `Certificate fingerprints` 區找 **SHA256** 那行,
格式如 `AB:CD:EF:...`(冒號分隔的 32 組十六進位)。