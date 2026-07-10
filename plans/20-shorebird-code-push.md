# Shorebird Code Push(OTA 更新)

讓已上架的 app 不經 Play / App Store 審查,直接推送 **Dart 程式碼**更新
(修 bug、調 UI 邏輯)。原生變更(gradle、AndroidManifest、新增含 native
code 的 plugin、升 Flutter 版本)仍須走商店發新版。

## 設計重點

- **Release vs Patch 兩層**:
  - `shorebird release`:完整建置,上傳基準版(baseline)到 Shorebird,
    產物(AAB / IPA)照常上架商店。每個上架版本(versionName+versionCode)
    都必須用 `shorebird release` 建,否則之後無法對它下 patch。
  - `shorebird patch`:只推 Dart 差異,綁定某一個已存在的 release 版本;
    裝置上的 updater 在啟動時背景下載,**下一次重啟**才生效(two-launch)。
- **Flutter 版本綁定**:Shorebird 用自己的 Flutter fork;patch 必須用與
  release 當時完全相同的 Flutter revision 建置(CLI 會自動管理,但 CI 上
  要固定 Shorebird CLI 版本以免漂移)。
- **shorebird.yaml**:`shorebird init` 產生,含 `app_id`,會自動加進
  pubspec 的 assets,需 commit 進 repo。預設 `auto_update: true`
  (背景自動更新);若之後要做「有更新時提示使用者重啟」,再加
  `shorebird_code_push` 套件並設 `auto_update: false`,v1 先用預設。
- **簽章**:release 建置沿用現有 keystore 機制(CI 產 `key.properties`,
  本機無則回退 debug);`shorebird release android` 走同一份
  build.gradle.kts 設定,不需改動。
- **費用**:以 patch 安裝次數計費,有免費額度;上線前到
  console.shorebird.dev 確認目前方案是否夠用。

## 步驟

### 一次性設置
1. 到 console.shorebird.dev 註冊帳號。
2. 安裝 CLI:
   `curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash`
3. `shorebird login`、`shorebird doctor` 確認環境。
4. 在專案根目錄 `shorebird init` — 產生 `shorebird.yaml` 並註冊 app,
   commit `shorebird.yaml` 與 pubspec 變更。
5. `flutter analyze` + 跑一次 `shorebird release android` 驗證建置無誤
   (先不上傳商店,用 `shorebird preview` 在實機驗證)。
6. CI 整合:到 console.shorebird.dev 建 API key(舊的 `shorebird login:ci`
   已移除),以 `SHOREBIRD_TOKEN` 環境變數存入 CI secrets;
   release / patch 步驟改呼叫 shorebird CLI(取代 `flutter build appbundle`)。

### CI 整合(2026-07-10 已實作)

- `release.yml`:改為 **`v*` tag push 觸發**,`shorebird release android` 建
  AAB 並照舊上傳 Play internal track。
- `patch.yml`(新增):**master push 觸發**,對最新 tag 對應版本
  `shorebird patch android --release-version=<name>+<code>`;HEAD 恰為 tag
  或尚無 tag 時自動跳過。
- **版號規則改為錨定在最新 tag 的 commit**(非 HEAD),tag 之間版號不變,
  patch 才有固定 baseline:`versionName = tag 去 v 前綴`(v1.2.0 → 1.2.0,
  使用者看到的版本)、`versionCode = 到 tag 為止的總 commit 數`(僅供
  Play Console 遞增識別;shorebird patch 以 `name+code` 格式指定目標)。pubspec `version:` 維持
  placeholder,由 CI `--build-name/--build-number` 覆寫(取代原步驟 1 的
  「bump pubspec version」——上架新版一律改用打 tag)。
- 詳細操作見 `.github/workflows/RELEASE_SETUP.md`。

### 每次「上架商店」的新版(原生變更或大版本)
1. bump `pubspec.yaml` 的 `version:`(例 `1.0.1+2`)。
2. `shorebird release android` 產出 AAB(`build/app/outputs/bundle/release/`)。
3. 照常上傳 Play Console 送審。

### 每次「熱修」(純 Dart 變更)
1. 在對應的 release commit 分支上修 code(git tag 對應每個 release 方便回切)。
2. `shorebird patch android --release-version <上架中的版本,如 1.0.0+1>`。
3. 先推 staging 驗證:`shorebird patch android --track staging`,
   用 `shorebird preview --track staging` 在實機確認後再 promote 到 stable。
4. 使用者端:下次開 app 背景下載,再下次啟動生效。

### App 內更新提示(2026-07-10 已實作)

加入 `shorebird_code_push`(2.0.7)與 `restart_app`,做成「背景下載 →
SnackBar 提示 → 使用者點按鈕重啟生效」。`auto_update` 維持 `true`(雙層):
引擎每次啟動自動背景下載,**不依賴 app 內 Dart 邏輯**——即使 app 內流程
沒偵測到 / 使用者沒點按鈕,自行重開 app 也會套用更新;app 內流程只負責
提示體驗。因引擎可能已在下載,`update()` 回 `IN_PROGRESS` 即回傳,
controller 需輪詢本機 patch 編號(`readCurrentPatch` / `readNextPatch`)
確認下載完成才顯示提示,逾時(60s)安靜放棄、交給引擎後援。

- **不卡 UI 的依據**:`shorebird_code_push` 2.x 的 `checkForUpdate()` /
  `update()` 內部以 `Isolate.run` 在背景 isolate 執行 FFI(已讀套件原始碼
  確認),await 不佔 UI thread;唯一同步 FFI 是 `ShorebirdUpdater()` 建構子
  讀本機 patch 編號,因此連建構都延到第一幀之後
  (`addPostFrameCallback`)才做,啟動關鍵路徑完全不碰更新邏輯。
- **狀態層**(`lib/core/update/`,遵守一檔一 provider):
  - `shorebird_updater_provider.dart`:提供 `ShorebirdUpdater` 實例。
  - `patch_update_controller.dart`:`idle → checking → downloading →
    restartReady | upToDate | error` 狀態機;`checkForUpdate` 回傳
    `restartRequired`(patch 早已下載好)時直接進 `restartReady`。
    失敗只 debugPrint + Crashlytics non-fatal,不影響 App。
- **UI**:`update_ready_listener.dart` 掛在 `MaterialApp.router` 的
  `builder`,`restartReady` 時以 AlertDialog 詢問「新版本已就緒」
  (稍後 / 重新啟動)。builder 位於 Navigator 之上,showDialog 需用
  `rootNavigatorKey`(原 app_router 的 `_rootKey` 改為公開)的 context。
- **重啟**:patch 只在引擎冷啟動載入(flutter_phoenix 重建 widget tree
  無效)。Android 用 `Restart.restartApp()` 整個 process 重啟;iOS 無法
  程式化重啟(exit 違反審核指引),按鈕改提示手動重開。
- i18n:四個 key(`update_ready_message` / `update_later` /
  `update_restart_action` / `update_restart_manual_hint`)已補齊
  全部 17 個 arb。

## 待辦 / 風險

- [ ] iOS:Shorebird 支援 iOS patch(部分 patched code 走直譯、有效能
      折衷),等 Android 流程穩定後再啟用 `shorebird release ios`。
- [ ] 確認 ffmpeg_kit / on_audio_query 等含 native 的套件升級時,
      記得必須走 store release 而非 patch(CLI 會偵測並警告,勿用 `--force`)。
- [ ] 確認免費額度與 MAU 成長後的費用。
