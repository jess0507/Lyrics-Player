# 歌詞功能:顯示(字幕)(backlog 3)

狀態:**規劃中**(2026-06-12 起草,未實作)。
相關:`plans/lyrics-import.md`(匯入,backlog 2;本計畫消費它建立的
`Lyrics` 模型、`LyricsEntity`、`track_lyrics_provider`,並提供匯入入口)、
`plans/becklog.md`(歌詞功能群)。

## 修改 / 新增程式碼檔案

新增:

- `lib/features/player/widgets/lyrics_view.dart` — 歌詞視圖
  (synced:highlight + 自動捲動 + 點行 seek;unsynced:靜態捲動;
  空狀態:匯入入口按鈕)。

修改:

- `lib/features/player/widgets/player_artwork.dart` 或
  `lib/features/player/player_page.dart`(現於 `player_page.dart:80` 放
  `PlayerArtwork`)— artwork ↔ 歌詞視圖切換(點 artwork 或角落按鈕,擇一)。
- `lib/features/player/playback_controller.dart`(或既有 seek 路徑)—
  供「點行 seek」呼叫(若現有 controller 已暴露 seek 則只引用、不改)。
- `lib/l10n/app_en.arb` / `app_zh_TW.arb` / `app_zh_CN.arb` — 無歌詞空狀態 /
  刪除確認 key(其餘語系 fallback;**待辦:補進 Google Sheet**)。

依賴(由 `lyrics-import.md` 建立,本計畫只消費):

- `lib/features/lyrics/lyrics.dart`(`Lyrics` / `LyricsLine` 模型)。
- `lib/features/lyrics/track_lyrics_provider.dart`(依目前曲目查歌詞)。
- `lib/features/lyrics/lyrics_parser.dart`(讀取時 parse 原文)。
- `lib/features/lyrics/lyrics_import_service.dart`(空狀態 / 重新匯入動作)。

## 背景 / 目標

- 接續匯入(`lyrics-import.md`):曲目有歌詞時,在**完整播放頁**顯示;
  synced 歌詞做時間同步捲動,unsynced 顯示可捲動靜態整篇。
- 位置來源 `positionStream`,需與既有播放狀態整合,不另開播放邏輯。

## 結論(設計決策)

1. **顯示 UI 自製**(不用 [flutter_lyric](https://pub.dev/packages/flutter_lyric)):
   播放頁 artwork 區切換歌詞視圖(無歌詞時顯示匯入入口)。
   同步歌詞:目前行 highlight + 自動置中捲動 + **點行 seek**;
   位置來源 `positionStream`(節流到 ~200ms 再算目前行,行數用二分搜尋)。
   flutter_lyric 功能完整但樣式與互動綁定深,專案慣例是自組 widget。
2. **讀取時解析**:顯示前以 `lyrics_parser` 把 `LyricsEntity.content` 原文
   parse 成 `Lyrics` 模型(原文已入庫,見匯入計畫決策 2)。
3. **手動捲動暫停自動捲動**:使用者手動捲動時暫停自動置中數秒再恢復。

## 步驟

1. **歌詞視圖**:`features/player/widgets/lyrics_view.dart`
   - synced:highlight + 自動捲動(節流 ~200ms,二分搜尋目前行)+ 點行 seek;
   - unsynced:靜態捲動;
   - 空狀態:匯入入口按鈕(呼叫 `lyrics_import_service`);
   - 視圖選單:重新匯入、刪除歌詞。
2. **播放頁整合**:artwork ↔ 歌詞切換(點擊 artwork 或角落按鈕,擇一,實作時定)。
3. **l10n**:無歌詞空狀態 / 刪除確認 key,照慣例 en + zh_TW + zh_CN。
4. 驗證:`flutter analyze`、實機走一輪(synced 捲動與點行 seek、unsynced 靜態、
   無歌詞空狀態、刪除 / 重新匯入)。

## 邊界 / 風險

- **mini player 不顯示歌詞**,僅完整播放頁。
- **效能**:歌詞行數通常 < 200,ListView + 二分搜尋足夠,無需虛擬化以外的優化。
- **切換歌詞 / artwork 的入口**(點 artwork 或角落按鈕)二擇一,實作時定。
