# Splash（啟動畫面）設定

- **Logo 來源**：`assets/icon/app_logo.png`（launcher 來源，`dart run flutter_launcher_icons` 產各尺寸）。
- **Splash logo**：`app_logo_front.png` = 來源圖經 `tool/pad_splash_logo.py` 加透明 padding（scale 0.62，避 Android 12+ 圓形遮罩裁切）；部署於
  - Android：`android/app/src/main/res/drawable-nodpi/app_logo_front.png`
  - iOS：`ios/Runner/Assets.xcassets/LaunchLogo.imageset/app_logo_front.png`
- **Splash 背景色（跟隨系統主題）**：
  - 淺色主題 → 白 `#FFFFFF`；深色主題 → 黑 `#000000`。
  - **Android**：`@color/splash_background` 於 `values/colors.xml` 設白，`values-night/colors.xml` 覆寫為黑；`launch_background.xml`（pre-v31）與 `values-v31/styles.xml`（windowSplashScreenBackground）皆引用同一 color，系統自動按 night 限定詞解析。
  - **iOS**：`LaunchScreen.storyboard` 背景改引用具名色 `SplashBackground`（`Assets.xcassets/SplashBackground.colorset`，含 light=白 / dark=黑 appearances）。
