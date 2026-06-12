# Plan2 — v1 後續迭代

## 背景

v1 完成後（見 [`plan.md`](plan.md)「待辦」一節）累積的一批改善項目：
播放器操作強化、本地資料層、上架 CICD、App Logo / Splash 更新、播放器 UI 改版等。

## 結論

**全部 14 項已完成。** 其中第 7、8 項完成時仍留有後續（隱私權政策為占位連結、實機驗證未做），
後續處理見 tasks/ 下各議題文件。Splash 細節已抽出至 [`docs/splash_setup.md`](../docs/splash_setup.md)。

## 步驟

1. ✅ 播放器快進 / 快退按鈕
2. ✅ 播放速度按鈕
3. ✅ i18n 新增字串補齊 16 語系
4. ✅ 本地資料：媒體檔案改存 Isar
5. ✅ 本地資料：使用者設定續存 SharedPreferences
6. ✅ 上架 CICD
7. ✅ 關於頁（隱私權政策連結為占位）
8. ✅ 實機驗證（當時僅 build / analyze / test）
9. ✅ 更換 App Logo / Splash
10. ✅ Splash（啟動畫面）設定
11. ✅ 播放器 UI：全螢幕展開
12. ✅ 播放器 UI：移除播放器分頁
13. ✅ 播放器 UI：AppBar 收回箭頭
14. ✅ 播放器 UI：MiniPlayer

## 各步驟說明

### 1. 播放器快進 / 快退按鈕
點擊一下會快進、退後 5 秒，持續點著會快速進退。
實作：`_SeekHoldButton`（點擊 ±5s，長按每 300ms 連續 seek）；`AudioPlayerService.seekRelative`。

### 2. 播放速度按鈕
dialog 顯示可選的播放速度，從 0.5x~4x、間隔 0.1，選擇後即改變播放速度。
實作：速度 Slider，divisions=35，即時套用；`AudioPlayerService.setSpeed`。

### 3. i18n 新增字串
新 key（player_forward/rewind/speed/speed_reset）補進 `tool/app_strings.csv`（全 16 語系），
新增 `tool/gen_l10n_from_local.dart`（讀本地 CSV、合併進既有 arb、以 local 翻譯為主，不覆蓋未列出的 key）。

### 4. 本地資料（Isar）
媒體檔案資料改存 Isar（`TrackEntity` + 同步 API），`isarProvider` 於 main() 注入。
（註：後因快取清除問題改採 MediaStore、移除 Isar，見
[`tasks/cache-clear-breaks-playback.md`](../tasks/cache-clear-breaks-playback.md)。）

### 5. 本地資料（SharedPreferences）
使用者設定（語系/主題）續存 prefs；音樂庫已自 prefs 遷至 Isar，prefs 不再存媒體資料。

### 6. 上架 CICD
`.github/workflows/release.yml`，推送 master 上的 `v*` tag 觸發，
建置簽章 AAB 並上架 Play Store internal 軌道（設定見 `RELEASE_SETUP.md`）。

### 7. 關於頁
隱私權政策連結為占位，尚未接實際網址。

### 8. 實機驗證
完成當時尚未在實體裝置 / 模擬器執行（僅通過 build / analyze / test）。

### 9. 更換 App Logo / Splash
新 logo（綠色播放鍵）。

### 10. Splash（啟動畫面）
詳細設定已移至 [`docs/splash_setup.md`](../docs/splash_setup.md)。

### 11. 播放器 UI：全螢幕展開
改成往上展開的全螢幕播放器（`showPlayerSheet` → `showModalBottomSheet`，
`isScrollControlled` + `FractionallySizedBox(heightFactor:1)`，`useRootNavigator` 覆蓋底部導覽）。

### 12. 播放器 UI：移除播放器分頁
底部導覽移除播放器分頁（剩音樂 / 個人），點擊歌曲改呼叫 `showPlayerSheet` 展開，不再 `context.go('/player')`。

### 13. 播放器 UI：AppBar 收回箭頭
全螢幕播放器 AppBar 左上改為往下箭頭（`Icons.keyboard_arrow_down`），點擊 `Navigator.pop` 收回 mini player。

### 14. 播放器 UI：MiniPlayer
新增 `MiniPlayer`（`lib/features/player/mini_player.dart`），疊在底部導覽上方，
有曲目時顯示曲名 / 演出者與上一首、播放暫停、下一首；點本體展開全螢幕播放器。
