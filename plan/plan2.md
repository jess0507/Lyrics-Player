# Plan2

## 待辦
1. ✅ **增加播放器快進或快退按鈕**：點擊一下會快進、退後5秒，持續點著會快速進退。（`_SeekHoldButton`：點擊 ±5s，長按每 300ms 連續 seek；`AudioPlayerService.seekRelative`）
2. ✅ **增加播放器播放速度按鈕**：會有dialog顯示可選的播放速度，從0.5x~4x，間隔0.1，選擇後會改變播放速度。（速度 Slider，divisions=35，即時套用；`AudioPlayerService.setSpeed`）
3. ✅ **i18n 新增字串**：新 key（player_forward/rewind/speed/speed_reset）補進 `tool/app_strings.csv`（全 16 語系），新增 `tool/gen_l10n_from_local.dart`（讀本地 CSV、合併進既有 arb、以 local 翻譯為主，不覆蓋未列出的 key）。
4. ✅ **本地資料 (Isar)**：媒體檔案資料改存 Isar（`TrackEntity` + 同步 API），`isarProvider` 於 main() 注入。
5. ✅ **本地資料 (SharedPreferences)**：使用者設定（語系/主題）續存 prefs；音樂庫已自 prefs 遷至 Isar，prefs 不再存媒體資料。
6. ✅ **上架CICD**：`.github/workflows/release.yml`，推送 master 上的 `v*` tag 觸發，建置簽章 AAB 並上架 Play Store internal 軌道（設定見 `RELEASE_SETUP.md`）。
7. ⬜ **關於頁**：隱私權政策連結為占位，尚未接實際網址。 
8. ⬜ **實機驗證**：尚未在實體裝置 / 模擬器執行（僅通過 build / analyze / test）。 
9. ✅ **更換 App Logo / Splash**：新 logo（綠色播放鍵）。

> Splash（啟動畫面）詳細設定已移至 [`docs/splash_setup.md`](../docs/splash_setup.md)。