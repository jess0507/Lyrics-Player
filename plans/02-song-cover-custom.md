# 自訂歌曲封面(新增 / 更換 / 移除)

讓使用者為單一曲目挑選一張自訂封面圖,顯示於播放頁與 mini player;可隨時
更換或移除,移除後回到原本的佔位圖。純本機資料,綁定 MediaStore `trackId`,
與歌詞 / 統計同一套「以 trackId 為鍵」的設計。

狀態:**已實作**(2026-06-20)。
影響範圍:新增 `lib/features/cover/`、改 `lib/features/player/widgets/`、
`lib/features/mini_player/`、`lib/core/storage/isar_service.dart`、`lib/l10n/`。

## 現況

- 封面完全是佔位圖:播放頁 `PlayerArtwork`(`Icons.music_note`)、mini player
  也是 `Icons.music_note`。`track-metadata.md`(讀 MediaStore embedded artwork)
  尚未實作,曲庫檔案多半也無 APIC,因此「使用者自選封面」是目前唯一能讓
  封面有內容的路徑,且與 embedded artwork 不衝突(自訂優先)。
- 已有可直接仿照的資料層樣板:歌詞 `LyricsEntity` / `LyricsRepository` /
  `trackLyricsProvider` / `LyricsImportService`——以 `trackId` 唯一索引 replace
  做 upsert,匯入後 `invalidate` 對應 family。本任務一比一沿用此結構。

## 設計決策

1. **一檔一圖,圖檔落地、路徑入庫**:Isar 只存 `trackId → imagePath`
   (`TrackCoverEntity`),實際圖檔複製到 app 文件夾 `covers/` 下。Isar 不適合
   塞大 binary,且圖檔放檔案系統可直接 `Image.file` 顯示、複用系統解碼快取。
2. **唯一索引 replace = 天然 upsert**:同曲再次設定封面即覆蓋;「更換」與
   「新增」共用同一條路徑,差別只在動作前先刪掉舊圖檔(避免孤兒檔)。
3. **檔名用時間戳不用 trackId**:`trackId` 是 file URI,非檔名安全字元;且
   實際查找一律經 entity 的 `imagePath`,檔名只需全域唯一 → 用
   `<millisecondsSinceEpoch>.<ext>`。
4. **顯示端容錯**:`trackCoverProvider` 回 `File?`——entity 不存在、或圖檔
   已被外部清掉(`existsSync() == false`)都回 `null`,UI 自動退回佔位圖。
5. **優先序**:自訂封面 > (未來)embedded artwork > 佔位圖。本任務只做自訂
   這層,embedded 仍是 `track-metadata.md` 的後續工作,介接點留在 artwork page。
6. **與雲端同步無關**:封面屬本機個人化資料,換機遺失可接受,不進 Firestore
   (同歌詞的取捨)。

## 步驟(已完成)

### 資料層 `lib/features/cover/`(嚴格一檔一 provider)
1. `track_cover_entity.dart`(+ 產生的 `.g.dart`)——Isar collection:
   `trackId`(unique replace 索引)、`imagePath`、`addedAt`。
2. `track_cover_repository.dart`——`findByTrackId` / `save`(upsert)/
   `deleteByTrackId`,以及 `trackCoverRepositoryProvider`。
3. `track_cover_provider.dart`——`trackCoverProvider`(FutureProvider.family):
   依 trackId 取 entity,回存在的 `File?`。
4. `cover_import_service.dart`——`CoverImportService` + `coverImportServiceProvider`:
   - `pickAndSetForTrack`:`FilePicker.pickFiles(type: image)` → 大小上限
     檢查 → 複製到 `covers/<ts>.<ext>` → 刪舊圖檔 → upsert entity →
     `invalidate(trackCoverProvider)`;使用者取消回 `false`,失敗拋
     `CoverImportException`(`tooLarge` / `unreadable`)。
   - `removeForTrack`:刪圖檔 + `deleteByTrackId` + invalidate。

### 註冊
5. `isar_service.dart` 的 `openIsar` schema 清單加入 `TrackCoverEntitySchema`。

### UI
6. `player_artwork_panel.dart` 的 `_ArtworkPage` 改 `ConsumerWidget`,
   watch `trackCoverProvider(trackId)`:有圖 → `Image.file` 滿版(`cover`),
   無圖 → 既有 `PlayerArtwork` 佔位。有曲目時右下角放編輯鈕(`edit`/`photo`),
   點擊開 `showCoverActionSheet`。
7. `widgets/cover_action_sheet.dart`——bottom sheet:`新增/更換封面`,已有封面時
   多一項 `移除封面`;呼叫 service,結果以 SnackBar 回饋,例外映射 l10n 文案。
8. `mini_player.dart`——currentItem 有 trackId 時 watch `trackCoverProvider`,
   有圖顯示 40×40 圓角縮圖,無圖維持 `Icons.music_note`。

### in10n / 驗證
9. 新增 l10n 鍵(`cover_edit` / `cover_add` / `cover_change` / `cover_remove` /
   `cover_updated` / `cover_removed` / `cover_failed` / `cover_too_large`):
   先補 `app_en`(template)與 `app_zh_TW` / `app_zh_CN` / `app_zh`;其餘語系暫
   走 template fallback,列入待辦。
10. `flutter gen-l10n`、`flutter analyze`、`dart run build_runner`(產 isar code)。

## 邊界 / 風險

- 選到非圖片或超大檔 → 大小上限擋下並提示;解碼交給 `Image.file` 自身,
  壞檔顯示 broken 圖示屬可接受降級(可後續加 errorBuilder 退回佔位)。
- 圖檔被外部清除 → provider `existsSync` 檢查回 null,自動退回佔位圖。
- `trackId` 綁裝置(MediaStore id),重掃 / 換機後可能對不上 → 與歌詞同屬
  已知限制,孤兒圖檔僅佔少量空間,暫不做 GC(後續可加掃描清理)。

## 待辦 / 後續

- 其餘 13 個語系的 `cover_*` 翻譯(隨下次 localization pass 補齊)。
- 與 `track-metadata.md` 的 embedded artwork 介接:無自訂封面時改讀
  MediaStore artwork,再退回佔位圖。
- 孤兒封面檔的清理(刪曲 / 重掃後)。
