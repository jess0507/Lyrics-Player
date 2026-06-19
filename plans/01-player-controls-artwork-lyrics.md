# 播放頁次控制列與封面 / 歌詞翻頁

整理播放頁(`lib/features/player/`)的中央視覺區與次控制列:封面與歌詞改為
左右滑動的 PageView,次控制列補上歌詞、加入播放清單、單曲輪播按鈕。

## 設計重點

- **封面 ↔ 歌詞用水平 PageView**:第一頁專輯封面、第二頁內嵌歌詞,左右滑動
  切換,維持原本正方形 `AspectRatio`。PageView 下方放兩條短線提示可翻頁,
  目前頁高亮。
- **歌詞頁重用 `LyricsView`**:有歌詞時內嵌顯示,右上角提供 `fullscreen` 按鈕
  進入滿版歌詞;無歌詞時 `LyricsView` 自身顯示匯入提示;無曲目顯示底色佔位。
- **`PageController` 提到 `_PlayerLayout`**(改為 StatefulWidget)共享,讓次
  控制列的歌詞按鈕也能切到歌詞頁。
- **次控制列按鈕「無資料不佔位」**:用 `Widget?` + collection `?element`,
  條件不成立時不放進 `Row`(避免 `spaceEvenly` 仍分配空位)。
- 遵守專案慣例:sub-widget 各自成檔、跨檔引用改 public。

## 做了哪些步驟

### 封面 / 歌詞面板
1. `lib/features/player/widgets/player_artwork_panel.dart` — 改成水平 PageView:
   `_ArtworkPage`(封面)、`_LyricsPage`(內嵌 `LyricsView` + 有歌詞時右上角
   滿版按鈕)、`_PageIndicator`(兩條短線、目前頁高亮)。接收父層的
   `PageController` 與 `trackId` / `title` / `onShowLyrics`。
2. `lib/features/player/player_page.dart` — `_PlayerLayout` 改為 StatefulWidget,
   持有 `PageController`、提供 `_showLyricsPage()`(animate 到第 2 頁),分別
   注入封面面板與次控制列;外層 padding 調為 16。

### 次控制列
3. `lib/features/player/widgets/secondary_controls.dart` — 新增:
   - **歌詞按鈕**(`lyrics_outlined`):點擊直接切到歌詞頁(透過注入的
     `onShowLyricsPage`),不觸發匯入;無歌詞時由歌詞頁自身顯示匯入提示。
   - **加入播放清單**(`playlist_add`):用 `trackId` 在音樂庫對應到 `Track`,
     開啟既有的 `showAddToPlaylistSheet`。
   - **循環**:單一按鈕循環 off → all → one,三種狀態以圖示 + 高亮呈現
     (off:灰、`repeat`;all:高亮、`repeat`;one:高亮、`repeat_one`)。
   - 自動對時與上述歌詞 / 播放清單按鈕在無資料時回傳 `null` 不佔位。

### 驗證
4. `flutter analyze lib/features/player/`(No issues found)。

## 待辦 / 後續

- 循環三種狀態目前無 tooltip 文案;若要加,需在各 `app_*.arb` 補
  `loop_off` / `loop_all` / `loop_one` 字串。
