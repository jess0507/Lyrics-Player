# Play Store 自動上架設定

`release.yml` 會在 **master 上推送 `v*` tag**（例如 `v1.2.0`）時觸發，
建置已簽章的 AAB 並上傳到 Play Store 的 internal 軌道。

## 觸發方式

```bash
# 確認 master 已是最新並包含要發佈的 commit
git tag v1.2.0
git push origin v1.2.0
```

> workflow 會檢查 tag 指向的 commit 是否在 `origin/master` 上，否則中止。
> 版本號取自 `pubspec.yaml` 的 `version:`（`versionName+versionCode`），
> 發佈前請記得遞增 build number。

## 必要的 Repository Secrets

於 GitHub → Settings → Secrets and variables → Actions 新增：

| Secret | 說明 |
| --- | --- |
| `KEYSTORE_BASE64` | upload keystore（`.jks`）以 base64 編碼：`base64 -i upload-keystore.jks \| pbcopy` |
| `KEYSTORE_PASSWORD` | keystore 密碼（storePassword） |
| `KEY_ALIAS` | 金鑰別名 |
| `KEY_PASSWORD` | 金鑰密碼 |
| `PLAY_SERVICE_ACCOUNT_JSON` | Google Play Console 服務帳號 JSON（需有「發布應用程式」權限） |

### 產生 upload keystore

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

## ⚠️ 上架前待辦

- **applicationId 仍為 `com.example.seek_player`**（placeholder）。
  Play Store 不接受 `com.example.*`，須先在 `android/app/build.gradle.kts`
  與 `release.yml` 的 `packageName` 改為實際唯一的套件名，並同步更新 Firebase。
- 首次上架需先在 Play Console 手動建立應用並完成一次人工上傳，
  之後 `r0adkll/upload-google-play` 才能用 API 推送。
- 預設推到 `internal` 軌道；要正式發佈可把 `track` 改為 `production`。
