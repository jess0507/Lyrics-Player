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

## Splash（啟動畫面）設定

- **Logo 來源**：`assets/icon/app_logo.png`（launcher 來源，`dart run flutter_launcher_icons` 產各尺寸）。
- **Splash logo**：`app_logo_front.png` = 來源圖經 `tool/pad_splash_logo.py` 加透明 padding（scale 0.62，避 Android 12+ 圓形遮罩裁切）；部署於
  - Android：`android/app/src/main/res/drawable-nodpi/app_logo_front.png`
  - iOS：`ios/Runner/Assets.xcassets/LaunchLogo.imageset/app_logo_front.png`
- **Splash 背景色（跟隨系統主題）**：
  - 淺色主題 → 白 `#FFFFFF`；深色主題 → 黑 `#000000`。
  - **Android**：`@color/splash_background` 於 `values/colors.xml` 設白，`values-night/colors.xml` 覆寫為黑；`launch_background.xml`（pre-v31）與 `values-v31/styles.xml`（windowSplashScreenBackground）皆引用同一 color，系統自動按 night 限定詞解析。
  - **iOS**：`LaunchScreen.storyboard` 背景改引用具名色 `SplashBackground`（`Assets.xcassets/SplashBackground.colorset`，含 light=白 / dark=黑 appearances）。