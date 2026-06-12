# 統計改存 Isar + 同步 Firestore（users/{uid}）

狀態：**已實作**（2026-06-12 決策記錄並完成實作，見文末「實作記錄」）。
影響範圍：`lib/features/profile/statistics/`、`lib/features/player/playback_controller.dart`、
`lib/shared/providers/settings_controller.dart`、`pubspec.yaml`、`firestore.rules`、`android/build.gradle.kts`
相關：`tasks/account-deletion-cloud-functions.md`（刪除帳號已涵蓋 `users/{uid}` 遞迴刪除）

## 背景 / 問題

- 統計（`statistics.data`）目前以 JSON 存在 SharedPreferences（`statistics_service.dart`），
  資料只在本機，清資料或換機即消失。
- Isar 先前只服務音樂庫，音樂庫改 MediaStore 掃描後整套移除；
  既有待辦是「保留 Isar 另作資料儲存層」（見 memory `impl-decisions`），本任務即重新引入的第一個用途。
- 帳號系統（Firebase Auth）已就緒，但雲端尚無任何使用者資料。

## 結論（設計決策）

1. **統計本體改存 Isar，且只存 per-track 記錄**：取代 prefs 的 `statistics.data`。
   每首歌一筆（trackId / title / playCount / listenMs），**不存總計**——
   總計與排行皆於讀取時由 per-track 加總導出，本機與雲端結構對稱。
2. **同步到 Firestore，節流一天**：本機記錄**上次同步時間**，距上次 **> 1 天**才上傳；
   且**自上次同步後無任何變更就不上傳**（省免費額度寫入量）。
   每次上傳同時把 **`updatedAt`（server timestamp）寫進 Firestore**。
3. **Firestore 結構：`users/{uid}/`** 儲存使用者資料：
   - 個人化設定（locale / themeMode / seedColor，對應 `SettingsController`）
   - 統計（每首歌播放次數、播放時間；**總計不另存雲端，由 tracks 加總導出**）
   - 注意：collection 名是 **`users`**（複數），須與 Cloud Functions `_delete_user_data` 一致。
4. **未登入者不同步**：統計照常寫 Isar，僅登入後才上傳（uid 來自 Auth）。
5. **上傳為主、登入時還原**：日常為單向上傳（備份）；換機或重裝後登入時，
   若本機沒有資料則從 Firestore 還原統計與設定（詳見同步策略「下載 / 還原」）。

## Firestore 文件結構與欄位定義

```
users/{uid}                     # 使用者根文件
  ├─ schemaVersion: 1
  ├─ settings:   { locale, themeMode, seedColor }
  ├─ tracks:     { <trackId>: { title, playCount, listenMs } }
  └─ updatedAt:  <server timestamp>
```

**本機（Isar）與雲端皆不存統計總計**（totalPlayCount / totalListenMs）——
皆可由 per-track 記錄加總導出，不存即不會有「總計與明細對不上」的一致性問題。
（已知邊角：prefs 遷移來的**舊資料只有全域時長**、攤不進 per-track，
遷移時直接捨棄，本機與雲端皆不再有此數字。可接受。）

### 欄位定義

| 欄位 | 型別 | 來源 | 說明 |
| --- | --- | --- | --- |
| `schemaVersion` | int | 常數 | 目前為 `1`。日後欄位結構變動時遞增，還原端據此判斷相容性。 |
| `settings.locale` | string \| null | `SettingsState.locale` | 編碼同 prefs：`languageCode` 或 `languageCode_countryCode`（如 `zh_TW`）；`null` = 跟隨系統。 |
| `settings.themeMode` | string | `SettingsState.themeMode` | `ThemeMode.name`：`system` / `light` / `dark`。 |
| `settings.seedColor` | string | `SettingsState.seedColor` | `AppColorSeed` 的 name。還原時未知值 fallback 預設色。 |
| `tracks.<trackId>` | map | `TrackStatEntity` | key 為 MediaStore ID（字串、裝置綁定，見下方注意）。 |
| `tracks.<trackId>.title` | string | `TrackStatEntity.title` | 顯示標題；跨機聚合的對齊依據。 |
| `tracks.<trackId>.playCount` | int | `TrackStatEntity.playCount` | 該曲累計播放次數。 |
| `tracks.<trackId>.listenMs` | int | `TrackStatEntity.listenMs` | 該曲累計聆聽時長，毫秒。 |
| `updatedAt` | timestamp | `FieldValue.serverTimestamp()` | 最後同步時間（server 時鐘），每次上傳必寫。 |

- 時間量一律**毫秒 int**（與本機 `totalListenMs` 一致），不用 Firestore duration 概念。
- 還原端讀取一律容錯：缺欄位給預設值、未知 enum 字串 fallback（同現有 `fromJson` 風格）。

- 寫入用 **`set()` 整份覆寫（不帶 merge）**：本文件所有欄位都由同步一次產出，
  覆寫才能保證雲端 = 單一裝置的完整快照（merge 會讓 `tracks` 變成多裝置聯集，
  重設也清不掉舊條目）。
  日後若此文件加入非同步產出的欄位，再改為「同步欄位整組覆寫」的寫法。
- `tracks` 先用 map 欄位（單文件 1MB 上限，數千首內安全）；若曲庫極大再改 subcollection
  `users/{uid}/tracks/{trackId}`（改了要同步調整 `_delete_user_data` 的註解認知——遞迴刪除已涵蓋）。
- **trackId 是 MediaStore ID，裝置綁定**：換裝置 ID 會不同，title 一併上傳即為此因；
  跨機合併（若做）需以 title/metadata 對齊，不能靠 ID。

## 同步策略

### 本機狀態

- `lastSyncAt`：上次成功上傳的時間，上傳成功才更新。
- `lastModifiedAt`：統計或設定每次寫入時更新（`recordPlay` / `addListenTime` / 設定變更）。
- 兩者存本機（Isar 或 prefs），與統計資料同生命週期。

### 觸發時機

- **App 啟動完成**：主要觸發點，跑一次同步判斷。
- **登入成功當下**：視為立即觸發一次（新登入使用者雲端還沒資料，不必等一天；
  此時若 `lastModifiedAt > lastSyncAt` 即上傳）。
- 不做前景計時器、不在每次播放後觸發——節流粒度是「天」，啟動時檢查已足夠。

### 上傳條件（全部成立才上傳）

1. 已登入（Auth 有 uid）。
2. `lastModifiedAt > lastSyncAt`——**沒有變更就不上傳**。
3. `now - lastSyncAt > 1 天`（登入成功當下的觸發不受此條限制）。

### 執行與失敗處理

- 上傳內容：settings + tracks 一次 `set()` **整份覆寫**單一文件
  `users/{uid}`，附 `updatedAt = FieldValue.serverTimestamp()`（不可信任本機時鐘）。
- 上傳成功 → 更新本機 `lastSyncAt`；失敗（離線、權限、逾時）→ 靜默略過、不重試佇列，
  `lastSyncAt` 不動，下次啟動自然再試。
- 同步全程不阻塞 UI、不顯示錯誤給使用者（背景備份性質）。

### 下載 / 還原（換機、重裝）

- **時機**：登入成功當下（上傳觸發之前）先讀一次 `users/{uid}`。
- **條件**（2026-06-12 改版）：登入時**一律以雲端為準整份還原**，不看本機狀態。
  未登入期間累計的本機資料視為「使用者不想保存」，登入當下直接被雲端覆寫——
  心智模型是「要保存就登入；登入時先拿回雲端資料」。仍**完全避免雙向合併**。
  同一次登入流程中：雲端有文件就還原，沒有才走上傳判斷，兩者互斥。
  （原始版本只在本機無資料且從未同步時才還原，已棄用。）
- **還原內容**：settings（locale / themeMode / seedColor）套用到 `SettingsController` 並落地 prefs；
  tracks 整份寫入 Isar 即完成（總計本來就是讀取時導出，無需重建）；
  還原後 `lastSyncAt = now`、`lastModifiedAt` 不動
  （還原不算本機變更，避免馬上又觸發上傳）。
- **trackId 跨機不一致的處理**：雲端 entries 原樣還原（保留舊裝置的 trackId + title）。
  新裝置上播放同一首歌會以新 trackId 另起 entry，造成同曲兩筆——
  解法是**顯示層以 title 聚合**：`topTracks()` 把相同 title 的次數加總後再排序。
  資料層不做 ID 改寫或 title 合併（保持上傳/還原為無損搬運）。
- 雲端沒有文件（首次使用）→ 跳過還原，直接走上傳判斷。

### 衝突與邊界

- **多裝置**：採 **last-write-wins**（2026-06-12 決策）——雲端永遠是「最後同步那台」的
  完整快照，**不合併、不加總**：A 機 100 次 + B 機 50 次，雲端只會是其中一台的數字。
  換機還原也只拿得到最後同步那台的歷史。此為已知限制；
  若日後要全帳號加總，再改增量上傳（`FieldValue.increment`）方案。
- **登出**：本機統計保留、停止上傳；`lastSyncAt` / `lastModifiedAt` 不清。
  再次登入（同帳號或換帳號）時依登入還原規則：該帳號雲端有文件就整份覆寫本機，
  沒有才把本機上傳到該 uid 下；其他帳號的雲端資料不動。
- **統計重設（reset）**：先跳**確認 dialog** 警告使用者（說明本機與雲端備份都會刪除），
  使用者再次選擇重設才執行：清空本機 + **立即刪除遠端統計**（不等下次同步班次）。
  - 遠端刪法：沿用整份覆寫語意——立刻 `set()` 上傳「tracks 清空、settings 維持現值」的快照，
    並更新 `lastSyncAt`。
  - 未登入：只清本機，dialog 文案不提雲端。
  - 已登入但離線／上傳失敗：本機照清、`lastModifiedAt` 已更新，
    雲端等下次同步以空狀態覆寫達成最終一致（dialog 不需擋）。
- **刪除帳號**：雲端由 Cloud Function 遞迴刪 `users/{uid}`（既有機制）；
  本機資料與登出同規則處理。

## 步驟

1. **重新引入 Isar**：`isar: ^3.1.0+1` + `isar_flutter_libs` + `isar_generator`，
   `isarProvider` 於 main() 注入。⚠️ 沿用既有陷阱解法：isar_flutter_libs 未宣告 AGP namespace，
   `android/build.gradle.kts` 的 subprojects namespace 補丁仍在（為 on_audio_query 保留），確認可共用。
2. **統計 schema 與遷移**：`TrackStatEntity`（@collection，trackId 唯一索引 replace），
   欄位 trackId / title / playCount / listenMs，**一首歌一筆、無總計 collection**。
   首次啟動把 prefs `statistics.data` 的 `perTrackCount` + `trackTitles` 匯入 Isar
   後移除舊 key（全域 `totalListenMs` 攤不進 per-track，捨棄）。
   `StatisticsController` 改讀寫 Isar（同步 API，Notifier 維持同步），
   `StatisticsData` 變成由 per-track 記錄導出的 view（總計欄位改為 getter 加總）；
   `recordPlay` / `addListenTime` 呼叫點（`playback_controller.dart`）介面不變，
   但 `addListenTime` 需多帶 trackId 以累計 per-track 時長。
3. **加 `cloud_firestore` 依賴 + SyncService**：依 CLAUDE.md 一檔一 provider，
   sync service 與其 provider 獨立成檔（`lib/core/sync/` 之類），不塞進 statistics_service。
4. **個人化設定上傳**：設定變更不即時上傳，跟統計同一班次（一天一次）一起 merge 寫入。
5. **登入時還原**：SyncService 實作下載 / 還原（見同步策略），掛在登入成功事件上；
   `topTracks()` 改以 title 聚合，吸收跨機 trackId 不一致。
6. **重設確認 dialog**：統計頁 reset 改為先跳警告 dialog（本機 + 雲端都會刪），
   確認後清本機並立即上傳歸零快照（見「衝突與邊界」）。
   新增 l10n key（警告標題／內文分登入與未登入兩版／確認鈕），
   照慣例 en + zh_TW + zh_CN，其餘語系 fallback；**待辦：補進 Google Sheet**。
7. **Firestore security rules**：開本人限定規則（`request.auth.uid == uid` 才可讀寫 `users/{uid}/**`），
   `firestore.rules` 收進 repo + `firebase.json`，跟 CICD 一起部署
   （account-deletion task §後續 已預告此事，於本任務落實）。
8. 驗證：`flutter analyze`、`flutter test`、實機 Gradle build
   （Isar 重新引入後原生依賴需實機驗，先前移除時就欠這項）。

## 實作記錄（2026-06-12）

依上述設計實作完成，檔案落點與決策細節：

- **新檔**：`lib/core/storage/isar_service.dart`（openIsar + isarProvider，沿用舊版寫法）、
  `lib/features/profile/statistics/track_stat_entity.dart`（+ 產生的 `.g.dart`）、
  `lib/core/sync/sync_state_store.dart`（lastSyncAt / lastModifiedAt，存 prefs
  key `sync.lastSyncAt` / `sync.lastModifiedAt`）、
  `lib/core/sync/sync_service.dart`、`firestore.rules`、`test/statistics_data_test.dart`。
- **觸發實作**：SyncService 由 `app.dart` watch 一次啟動，監聽 authStateChanges——
  **首個事件視為「App 啟動」**（上傳判斷、節流一天），其後 null → user 的轉變
  才視為「登入成功當下」（先還原判斷、上傳不節流）。
- **介面變更**：`StatisticsController.addListenTime(Track, Duration)` 多帶曲目；
  `AudioPlayerService` 新增 `currentIndex` getter 供 5 秒取樣定位目前曲目。
  `StatisticsData` 改為 `List<TrackStatEntity>` 的 view，總計皆 getter 加總，
  `topTracks()` 以 title 聚合。
- **還原不算變更的落實**：`SettingsController.restoreFromRemote` /
  `StatisticsController.restoreFromRemote` 寫入但不 markModified；
  一般 setter（setLocale 等）與 recordPlay / addListenTime / reset 都會 markModified。
- **prefs 遷移**：於 `StatisticsController.build()` 執行（讀 `statistics.data`、
  匯入後移除 key、視為本機變更）；SyncService 上傳判斷前先 read 統計 provider，
  確保遷移先於條件判斷。
- **l10n**：新增 `statistics_reset_title` / `statistics_reset_message`（未登入版）/
  `statistics_reset_message_cloud`（登入版）/ `statistics_reset_confirm`，
  en + zh_TW + zh_CN；取消鈕沿用既有 `common_cancel`。**待辦：補進 Google Sheet。**
- **CICD**：沿用 `.github/workflows/firebase-functions-deploy.yml`，
  deploy 改 `--only functions,firestore:rules`，paths 加入 `firestore.rules`；
  `firebase.json` 增 `firestore.rules` 設定。
- **analysis_options**：排除 `**/*.g.dart`——Isar 3 產生碼使用自身標為
  experimental 的 API，新版 analyzer 會報 12 個 `experimental_member_use`。
- **驗證結果**：`flutter analyze` 無 issue、`flutter test` 5 項全過
  （含新增的 StatisticsData 加總 / title 聚合單元測試）、
  `flutter build apk --debug` 成功（cloud_firestore 6.5.0、isar_flutter_libs
  namespace 補丁如預期可共用），debug APK 安裝至 Android 模擬器啟動正常
  （Isar 開啟成功、未登入時同步靜默不動作、無例外）。
  尚未驗：登入帳號後的實際上傳 / 還原（需在實機登入測試帳號操作一輪）。
