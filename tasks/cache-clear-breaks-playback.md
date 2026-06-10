# 清除 App 快取／資料後無法播放已匯入的曲目

狀態：已修復（最終改採 MediaStore 方案，從根本消除此問題）
影響範圍：`lib/features/music_list/`、`lib/features/player/playback_controller.dart`、`lib/main.dart`、`lib/l10n/*.arb`、`pubspec.yaml`
平台：Android（iOS 視 on_audio_query 行為而定）

## 最終決策（2026-06-10）：改用 MediaStore（方案 C），不再複製檔案

問題根因是「曲目記錄的壽命」與「它指向的檔案壽命」不一致。最終選擇從來源解決：
**不自己保存檔案，直接以裝置 MediaStore 為音樂庫來源**，曲目以 MediaStore 的
content URI（`content://media/...`）播放。如此清除 App 快取／資料都不會讓曲目失效
（曲目本來就不存在 App 私有空間，重新掃描即得）。

實作：
- 移除 `file_picker` 與 Isar（`isar` / `isar_flutter_libs` / `isar_generator`、`track_entity*`、`isar_service.dart`、`main.dart` 的 isar 注入）。
- 加入 `on_audio_query`，`MusicLibrary` 改為 `AsyncNotifier<List<Track>>`，
  `build()` 已授權則掃描、否則回空清單；`refresh()` 重新掃描。
- `music_list_page.dart`：匯入鈕改為「重新掃描」，處理 AsyncValue 載入／空狀態，
  移除逐項刪除與失效標記（裝置音樂庫不由 App 管理增刪）。
- `playback_controller.dart`：讀取改用 `valueOrNull ?? []`；移除時長回寫（時長由掃描提供）。
- i18n：移除 `music_unavailable`，新增 `music_rescan`，更新 `music_empty` 文案。
- 權限：manifest 已有 `READ_MEDIA_AUDIO`/`READ_EXTERNAL_STORAGE`，沿用 `permission_handler` `Permission.audio`。
- 驗證：`flutter analyze` 0 issues、`flutter test` 通過。**待人工驗證**：實機 `flutter build apk` 與掃描／播放（含移除原生 Isar 依賴後的 Gradle 建置）。

### 行為說明：為什麼「刪掉檔案後還是可以播」是合理的

採用 MediaStore 後，這是 **預期且可接受** 的行為，原因有三：

1. **音樂庫是「掃描快照」，不是即時監看**
   `MusicLibrary` 在 `build()`／`refresh()` 時做一次 `querySongs`，把結果存進記憶體
   （`AsyncNotifier` state）。之後刪檔，App 不會自動察覺——清單仍顯示該曲、仍可點播，
   直到 **重新掃描（重新掃描鈕）或重開 App** 才會重新對帳、移除已不存在的曲目。
   我們沒有註冊檔案系統 / MediaStore 的變更監聽器（ContentObserver），這是刻意取捨：
   即時監看成本高，且 App 定位是「反映裝置音樂庫的快照」而非檔案管理器。

2. **MediaStore 索引有延遲**
   即使用檔案管理器刪了實體檔，Android 的 MediaStore 不一定立刻移除該筆記錄；
   在媒體掃描器更新前，`content://media/...` URI 可能仍可被解析、仍能取得資料。

3. **播放中已開啟 handle／已緩衝**
   若該曲正在播放，ExoPlayer 可能已開啟檔案描述子或已緩衝資料，
   會繼續播到需要讀取新資料為止，因此「刪了當下還在播」也屬正常。

換言之，正確的對帳時機是 **下一次重新掃描或重啟**，不是「刪檔當下」。

若日後要讓刪檔即時反映，可選作（非必要）：
- 在播放清單載入時對 content URI 做存在性檢查，過濾掉已失效項目；
- 註冊 MediaStore 的 ContentObserver，內容變更時自動 `refresh()`。

### 待辦（下次）
- **把 Isar 重新引入為「資料儲存層」**：使用者要求保留 Isar 但改存其他數據
  （候選：快取掃描到的歌曲以加速啟動／離線顯示、播放統計、收藏/播放清單、續播進度）。
  本次先讓 MediaStore 播放清單完成，Isar 用途下次再設計 schema 實作。

---

## （以下為先前已被上述決策取代的方案，保留作脈絡）

## 已完成（2026-06-10）

主修法（`music_library.dart`）：
- `importFiles` 改為把 file_picker 的快取副本複製到 `<appDocuments>/tracks/` 後存該路徑（`_tracksDir()`）。
- 去重改以標題判斷（同名曲目視為已匯入）。
- `remove` / `clear` 一併刪除複製檔（`_deleteCopiedFile`），避免孤兒檔。

防禦性處理：
- 新增 `missingTrackIdsProvider`：以 `File.existsSync()` 偵測檔案已遺失的曲目 id。
- `music_list_page.dart`：失效曲目顯示 `music_off` 圖示 + 紅色「請重新匯入」副標，點擊改彈 snackbar 提示而非靜默失敗。
- 新增 i18n key `music_unavailable`（en/zh/zh_TW/zh_CN，其餘語系 fallback 到 en）。
- `flutter analyze` 0 issues、`flutter gen-l10n` 正常。

## 仍待辦／已知限制

- **舊資料救不回**：此修法前匯入、URI 仍指向 cache 路徑的曲目，檔案已被系統刪除，
  會被標記為失效，需使用者重新匯入。
- **「清除資料」仍會清空**：連同 App documents 一起刪屬使用者明確重置，預期行為。
- **播放清單中途失效**：`playLibraryAt` 以整個音樂庫建 `ConcatenatingAudioSource`，
  若清單中間某首檔案失效，just_audio 仍可能於播到該首時報錯。列表層已擋住直接點播失效曲目，
  但「全庫連播」情境的中途錯誤尚未特別處理（可於 `setPlaylist` 過濾失效曲目）。

## 症狀

- 使用者透過檔案選擇器匯入曲目後可正常播放。
- 在系統設定中「清除 App 快取／資料」後，原本清單裡的曲目仍顯示，但點擊播放**載入失敗、播不出來**。
- 重新匯入同一檔案後又能播放。

## 根因

匯入流程把 `file_picker` 回傳的路徑當作穩定路徑存入 Isar：

```dart
// lib/features/music_list/music_library.dart:34-39
final path = file.path;
if (path == null) continue;
final uri = Uri.file(path).toString();
...
added.add(Track(id: uri, uri: uri, title: _titleFromName(file.name)));
```

但在 Android 上 **`FilePicker.platform.pickFiles()` 不會回傳原始檔案路徑**。
它會先把選到的檔案**複製一份到 App 的 cache 目錄**
（例如 `/data/data/com.js.seek_player/cache/file_picker/<檔名>`），
再回傳這個「快取副本」的路徑。

於是流程變成：

1. 匯入時存進 Isar 的 `uri` 指向 cache 目錄裡的暫存副本。
2. 使用者清除 App 快取／資料 → 該暫存副本被系統刪除。
3. Isar 仍保有這些 `file://` URI（媒體資料庫不會被清快取影響）。
4. just_audio `AudioSource.uri(...)` 載入時找不到檔案 → 播放失敗。

也就是說：**清單資料是持久的，但它指向的檔案是非持久的**，兩者壽命不一致。

> 註：file_picker 的 cache 路徑本就是暫存性質，官方亦建議若要長期保存應自行複製到 App 私有目錄。

## 解法

### 主要修法：匯入時複製到 App 持久目錄（建議）

匯入當下，把 file_picker 的快取副本**複製到 App 私有持久目錄**
（`path_provider` 的 `getApplicationDocumentsDirectory()`，已是現有相依），
並改存這個持久路徑。此目錄不會被「清除快取」清掉。

要點：

- 目標目錄如 `<appDocuments>/tracks/`，檔名建議用穩定雜湊（避免同名覆蓋／衝突）。
- `Track.id` / `uri` 改用複製後的持久路徑。
- 移除曲目時一併刪除複製檔，避免孤兒檔佔空間。
- 既有相依足夠：`path_provider: ^2.1.4`、`file_picker: ^8.1.6`，無需新增套件。

範例（示意）：

```dart
final docs = await getApplicationDocumentsDirectory();
final dir = Directory('${docs.path}/tracks')..createSync(recursive: true);
final dest = File('${dir.path}/${stableName(file)}');
if (!dest.existsSync()) {
  await File(path).copy(dest.path); // path = file_picker 回傳的快取路徑
}
final uri = Uri.file(dest.path).toString();
```

注意：此做法只能擋「清除快取」與「清除快取＋部分情況」。使用者若選「清除資料」
（連同 App documents 一起清），仍會遺失——這屬於使用者明確重置 App，可接受。

### 防禦性處理（建議一併加上）

即使做了複製，也應避免「資料庫指向不存在檔案」時靜默失敗：

- App 啟動或載入清單時，對每筆 `File(uri).existsSync()` 做檢查，
  將失效項目標記（灰階／不可播放）或剔除，並提示使用者重新匯入。
- `AudioPlayerService.setPlaylist` 載入失敗時要捕捉錯誤並給使用者可理解的提示，
  而非整個播放清單卡住。

### 替代方案（較複雜，暫不採用）

改用 Android Storage Access Framework（SAF）content URI，並呼叫
`takePersistableUriPermission` 取得長期存取權，直接讀原始檔不複製。
優點是不佔額外空間；缺點是要處理 scoped storage、content URI 與 just_audio
的相容性，且 iOS 行為不同，工程成本較高。v1 先採「複製到持久目錄」即可。

## 驗證方式

1. 匯入數首曲目並確認可播放。
2. 系統設定 → App → 清除快取。
3. 回到 App，原清單曲目仍可正常播放（不再載入失敗）。
4. 「清除資料」後清單清空屬預期行為。
