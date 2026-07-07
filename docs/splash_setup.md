# Splash（啟動畫面）設定

## 背景 / 問題

更換新 App logo（綠色播放鍵）後，啟動畫面需要一併更新；
Android 12+ 的系統 splash 會以圓形遮罩裁切 logo，直接用原圖會被切到，
且 splash 背景色要跟隨系統深淺色主題。

## 結論

- Splash logo 改由 `flutter_native_splash` 產生（來源 `assets/icon/app_logo.png`；Android 12+ 用留白較多的 `app_logo_android12.png` 避開圓形遮罩裁切）。
- 背景色以「具名色 + 系統深淺色限定詞」處理：淺色主題 → 白 `#FFFFFF`、深色主題 → 黑 `#000000`，Android / iOS 各自由系統自動解析。

## 步驟

1. 產生加 padding 的 splash logo。
2. 部署 logo 到 Android / iOS。
3. 設定跟隨系統主題的背景色（Android / iOS）。

## 各步驟說明

### 1. 產生 splash logo
- **Logo 來源**：`assets/icon/app_logo.png`（launcher 來源，`dart run flutter_launcher_icons` 產各尺寸）。
- **Splash logo**：由 `flutter_native_splash` 依 `pubspec.yaml` 設定產生（`dart run flutter_native_splash:create`）；一般用 `app_logo.png`，Android 12+ 用留白較多的 `app_logo_android12.png`。

### 2. 部署 logo
- Android：`flutter_native_splash` 產出 `drawable-*/splash.png` 與 `drawable-*/android12splash.png`（pre-v31 由 `launch_background.xml` 引用、v31+ 由 `windowSplashScreenAnimatedIcon` 引用）。
- iOS：`flutter_native_splash` 產出 `ios/Runner/Assets.xcassets/LaunchImage.imageset/`（`LaunchScreen.storyboard` 引用）。
- 早期手動部署的 `app_logo_front.png`（Android `drawable-nodpi/`、iOS `LaunchLogo.imageset/`）已無引用，內容已換為目前的 `app_logo.png`。

### 3. 背景色（跟隨系統主題）
- 淺色主題 → 白 `#FFFFFF`；深色主題 → 黑 `#000000`。
- **Android**：`@color/splash_background` 於 `values/colors.xml` 設白，`values-night/colors.xml` 覆寫為黑；`launch_background.xml`（pre-v31）與 `values-v31/styles.xml`（windowSplashScreenBackground）皆引用同一 color，系統自動按 night 限定詞解析。
- **iOS**：`LaunchScreen.storyboard` 背景改引用具名色 `SplashBackground`（`Assets.xcassets/SplashBackground.colorset`，含 light=白 / dark=黑 appearances）。
