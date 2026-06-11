# 刪除帳號 / 刪除帳號資料(Cloud Functions)

狀態:程式碼完成(`flutter analyze` 0 issues、`flutter test` 過、`py_compile` 過);**尚未部署**,Firestore 與 Blaze 方案待開通。
影響範圍:`functions/`、`firebase.json`、`lib/core/auth/auth_service.dart`、`lib/features/profile/account/`、`lib/l10n/`、`.github/workflows/firebase-functions-deploy.yml`
後端:Firebase Cloud Functions(Python)+ Firebase Admin SDK

## 目的

App 商店(Google Play / App Store)要求提供「刪除帳號」與「刪除帳號資料」兩種入口。
原本 client 端 `currentUser.delete()` 會因 Firebase 要求**近期重新登入**而失敗,且無法連帶清雲端資料,
故改由 Cloud Function 以 Admin SDK 執行。

## 兩支 callable API(`functions/main.py`)

| Function | 行為 | 帳號 |
| --- | --- | --- |
| **`delete_account_data`** | 遞迴刪除 Firestore `users/{uid}` 文件及其所有 subcollection。 | 保留 |
| **`delete_account`** | 先刪上述雲端資料,再 `auth.delete_user(uid)`。 | 刪除 |

- 兩者皆以 callable context 的 `auth.uid` 為準 — 使用者**只能刪自己的**,未登入丟 `UNAUTHENTICATED`。
- region = **`asia-east1`**,必須與 client `FirebaseFunctions.instanceFor(region: ...)`(`auth_service.dart` 的 `_functionsRegion`)一致。
- 資料範圍目前僅 Firestore `users/{uid}`。日後新增 Cloud Storage / 其他 collection 時,集中加在 `_delete_user_data(uid)`。

## Client 串接

- `auth_service.dart`:`AuthService` 多收一個 `FirebaseFunctions`;`deleteAccount()` 改打 `delete_account` 後本地 `signOut()`;新增 `deleteAccountData()` 打 `delete_account_data`。
- `signed_in_view.dart`:新增「刪除帳號資料」按鈕 + 確認對話框;例外捕捉改 `FirebaseFunctionsException`。
- l10n 新增 `account_delete_data` / `account_delete_data_confirm` / `account_delete_data_done`(en / zh_TW / zh_CN,其餘語系 fallback 到 en)。**待辦**:補進 Google Sheet。
- 依賴:`cloud_functions: ^6.3.2`。

## 部署前置(尚未完成)

1. **Firestore**:Console 啟用 Firestore database(否則 `recursive_delete` 無對象)。
2. **Blaze 方案**:Cloud Functions 需付費方案。
3. **本機部署**:`firebase deploy --only functions`(Python runtime 由 CLI 在 Cloud Build 端打包,本機免建 venv)。

## CICD(`.github/workflows/firebase-functions-deploy.yml`)

- 觸發:push 到 `master` 且 `functions/**`、`firebase.json`、`.firebaserc` 或本 workflow 變更;另支援手動 `workflow_dispatch`。
- 以 `w9jds/firebase-action` 跑 `firebase deploy --only functions`,憑證用既有 secret **`FIREBASE_SERVICE_ACCOUNT_SEEK_PLAYER_F724E`**(與 hosting workflow 共用)。
- **權限注意**:hosting 用的 service account 不一定有 functions 部署權限。若 deploy 失敗,需在 GCP IAM 給該 service account 加上 **Cloud Functions Admin**、**Service Account User**、**Cloud Build Editor**(及首次部署所需的 Artifact Registry 權限)。
- functions 的部署與 App 上架(`release.yml`,推 `v*` tag 觸發)各自獨立,互不影響。

## 後續

- 重新引入資料儲存層後(見 `impl-decisions.md` Isar 待辦),把新增的雲端資料路徑補進 `_delete_user_data`。
- 視需要加 Firestore security rules / emulator 測試。
