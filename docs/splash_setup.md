# Splash（啟動畫面）設定

## 背景 / 問題

更換新 App logo（綠色播放鍵）後，啟動畫面需要一併更新；
Android 12+ 的系統 splash 會以圓形遮罩裁切 logo，直接用原圖會被切到，
且 splash 背景色要跟隨系統深淺色主題。

## 結論

- Splash logo 用加過透明 padding 的 `app_logo_front.png`（scale 0.62，避開 Android 12+ 圓形遮罩裁切）。
- 背景色以「具名色 + 系統深淺色限定詞」處理：淺色主題 → 白 `#FFFFFF`、深色主題 → 黑 `#000000`，Android / iOS 各自由系統自動解析。

## 步驟

1. 產生加 padding 的 splash logo。
2. 部署 logo 到 Android / iOS。
3. 設定跟隨系統主題的背景色（Android / iOS）。

## 各步驟說明

### 1. 產生 splash logo
- **Logo 來源**：`assets/icon/app_logo.png`（launcher 來源，`dart run flutter_launcher_icons` 產各尺寸）。
- **Splash logo**：`app_logo_front.png` = 來源圖經 `tool/pad_splash_logo.py` 加透明 padding（scale 0.62，避 Android 12+ 圓形遮罩裁切）。

### 2. 部署 logo
- Android：`android/app/src/main/res/drawable-nodpi/app_logo_front.png`
- iOS：`ios/Runner/Assets.xcassets/LaunchLogo.imageset/app_logo_front.png`

### 3. 背景色（跟隨系統主題）
- 淺色主題 → 白 `#FFFFFF`；深色主題 → 黑 `#000000`。
- **Android**：`@color/splash_background` 於 `values/colors.xml` 設白，`values-night/colors.xml` 覆寫為黑；`launch_background.xml`（pre-v31）與 `values-v31/styles.xml`（windowSplashScreenBackground）皆引用同一 color，系統自動按 night 限定詞解析。
- **iOS**：`LaunchScreen.storyboard` 背景改引用具名色 `SplashBackground`（`Assets.xcassets/SplashBackground.colorset`，含 light=白 / dark=黑 appearances）。
