# Seek Player — 簡易播放器 App 規劃（v1）

## 背景

一個 **Android** 簡易音樂播放器，**僅播放本機音樂檔案**，支援 16 種語言。多語言字串由 Google Sheet 維護，透過腳本下載為 `.csv` 後自動產生 `.arb` 檔案，再由 `flutter_localizations` / `gen-l10n` 生成型別安全的 Dart 程式碼。帳戶採 Firebase Authentication（匿名 / Email / Google）。

> 📌 **版本範圍**：本文件為 **版本一 (v1)，僅 Android**。Apple 登入與 iOS 支援規劃於 [`becklog.md`](becklog.md)，v1 不實作。

### 核心目標
- 多語言（i18n）：以 Google Sheet 作為翻譯來源，腳本化產生 `.arb`，支援 16 語系（含 RTL）。
- 三大主頁面：音樂列表、播放器、我的。
- 本機音訊檔案播放（無線上串流）。
- 檔案 / 音訊權限請求流程（以 Dialog 呈現）。
- 「我的」頁面提供：帳戶、統計數據、設定、關於。
- 帳戶：Firebase Auth，選用登入（匿名）+ Email / Google（Apple 登入見 `becklog.md`）。

### 支援語系（16）
| Locale | 語言 | RTL |
|--------|------|-----|
| `en` | English | |
| `zh_CN` | 简体中文 | |
| `zh_TW` | 繁體中文 | |
| `es` | Español | |
| `fr` | Français | |
| `de` | Deutsch | |
| `ja` | 日本語 | |
| `ko` | 한국어 | |
| `pt` | Português | |
| `it` | Italiano | |
| `ru` | Русский | |
| `tr` | Türkçe | |
| `hi` | हिन्दी | |
| `id` | Indonesia | |
| `vi` | Tiếng Việt | |
| `ar` | العربية | ✅ |

> ⚠️ 阿拉伯文 (`ar`) 為 RTL，需確保版面以 `Directionality` / `EdgeInsetsDirectional` 處理；Flutter 在地化會依 locale 自動切換文字方向。

### 技術選型

| 類別 | 套件 / 工具 | 用途 |
|------|------------|------|
| 多語言 | `flutter_localizations`, `intl`, gen-l10n | 在地化基礎建設（16 語系） |
| 音訊播放 | `just_audio`, `audio_service` | 本機檔案播放、背景播放、通知列控制 |
| 權限 | `permission_handler` | 儲存 / 音訊 / 通知權限 |
| 帳戶 | `firebase_core`, `firebase_auth`, `google_sign_in` | 匿名 / Email / Google 登入 |
| 狀態管理 | `riverpod`（或 `provider`） | 全域狀態與依賴注入 |
| 路由 | `go_router` | 宣告式導航、底部導覽列 |
| 本地儲存 | `shared_preferences`, `sqflite` | 設定、統計、播放清單 |
| 檔案存取 | `file_picker`, `path_provider` | 掃描 / 匯入本機音樂檔案 |
| 腳本 | Dart script（`http`, `csv`） | 下載 CSV 並產生 ARB |

### 已確認的前提
- ✅ 支援語系：16 語系（en, zh_CN, zh_TW, es, fr, de, ja, ko, pt, it, ru, tr, hi, id, vi, ar）。
- ✅ 音樂來源：僅本機音訊檔案。
- ✅ 翻譯來源 Google Sheet 連結（已提供，已接入腳本，16 語系 .arb 已產生）。
- ✅ Firebase 專案已建立：`seek-player-f724e`，package `com.example.seek_player`（`android/app/google-services.json` 已就位，`lib/firebase_options.dart` 由其手動轉出，僅 Android）。

## 結論：實作狀態（v1，2026-06-06）

**v1 全部里程碑（M1–M7）已完成。** 驗證：`flutter analyze` 0 issues、`flutter test` 通過、`flutter build apk --debug` 成功。

| 里程碑 | 狀態 | 主要檔案 |
|--------|------|----------|
| M1 骨架 | ✅ | `main.dart`、`app.dart`、`router/app_router.dart`、`shared/widgets/scaffold_with_nav.dart` |
| M2 多語言 | ✅ | `lib/l10n/`（16 .arb + 生成 Dart）、`tool/gen_l10n_from_sheet.dart` |
| M3 權限 | ✅ | `core/permissions/`、AndroidManifest 權限與背景播放 service/receiver |
| M4 音樂列表 | ✅ | `features/music_list/`（匯入/搜尋/滑動刪除/點擊播放） |
| M5 播放器 | ✅ | `features/player/`、`core/audio/audio_player_service.dart`（seek/隨機/循環/背景） |
| M6 我的 | ✅ | `features/profile/`（帳戶/統計/設定/關於） |
| M7 收尾 | ✅ | 深淺色主題、RTL（`EdgeInsetsDirectional`）、測試、analyze |

### 與原規劃的務實取捨
- **本地儲存**：設定 / 音樂庫 / 統計皆用 `shared_preferences`（JSON），**未用 `sqflite`**。repository 有抽象層，日後可替換。
- **音樂來源**：以 `file_picker` 由使用者主動匯入，**未做 `on_audio_query` 全媒體庫自動掃描**（相容性風險）；`MusicLibrary` notifier 之上可擴充。
- **背景播放**：採 `just_audio_background`（較少樣板），非完整 `audio_service`。
- **登入**：`google_sign_in` 6.x（v6 API）。
- **`firebase_options.dart`** 為手動由 `google-services.json` 轉出（非 `flutterfire configure`）。

### 待辦（缺少 / 需後續處理）
1. ✅ **Google 登入需設 SHA-1**：`google-services.json` 目前 0 個 oauth_client，Google 登入會失敗；需在 Firebase Console 加入 Android SHA-1 並重新下載設定檔。Email / 匿名登入已可用。
2. ⬜ **增加播放器快進或快退按鈕**：點擊一下會快進、退後5秒，持續點著會快速進退。
3. ⬜ **i18n 新增字串尚未進 Sheet**：本次新增的 UI key 僅 `en`/`zh_TW`/`zh_CN` 有翻譯，其餘 13 語系 gen-l10n fallback 到 `en`。需將新 key 補進 Google Sheet 後重跑 `dart run tool/gen_l10n_from_sheet.dart && flutter gen-l10n`。
4. ⬜ **本地資料**: 使用 Drift
5. ⬜ **關於頁**：隱私權政策連結為占位，尚未接實際網址。
6. ⬜ **實機驗證**：尚未在實體裝置 / 模擬器執行（僅通過 build / analyze / test）。
7. ⬜ Google 登入需設 SHA-1, Release App 也要設定

> 上述 2–6 之後續處理見 [`plan2.md`](plan2.md)。

## 步驟（開發里程碑）

| 階段 | 內容 | 產出 |
|------|------|------|
| M1 專案骨架 | 建立 Flutter 專案、套件、目錄結構、`go_router` 三頁底部導覽 | 可在三頁間切換 |
| M2 多語言 | Google Sheet、CSV 腳本、`gen-l10n`、16 語系、RTL 驗證 | 字串全在地化 |
| M3 權限 | 權限服務 + rationale / settings Dialog | 掃描前完整權限流程 |
| M4 音樂列表 | 掃描 / 匯入 / 列表 / 搜尋 / 排序 | 可瀏覽本機曲目 |
| M5 播放器 | just_audio 整合、seek bar、背景播放、通知列 | 完整播放體驗 |
| M6 我的 | 帳戶（Firebase Auth）/ 統計 / 設定 / 關於 | 個人化與設定 |
| M7 收尾 | 主題、深淺色、RTL、測試、打磨 | 可發布版本 |

> M6 帳戶需先完成 Firebase 專案建立與 `flutterfire configure`，建議在 M1 一併處理 `firebase_core` 初始化。

## 各步驟說明

### M1 專案骨架

頁面架構：

```
App (go_router + 底部導覽列 BottomNavigationBar)
├── 音樂列表  MusicListPage
├── 播放器    PlayerPage
└── 我的      ProfilePage
        ├── 帳戶      AccountPage
        ├── 統計數據  StatisticsPage
        ├── 設定      SettingsPage
        └── 關於      AboutPage
```

專案目錄結構：

```
seek_player/
├── plan.md
├── l10n.yaml
├── pubspec.yaml
├── tool/
│   ├── gen_l10n_from_sheet.dart   # 下載 CSV → 產生 ARB
│   └── l10n_config.yaml           # Sheet 連結與語系設定
├── lib/
│   ├── main.dart
│   ├── app.dart                   # MaterialApp.router + 在地化接線
│   ├── firebase_options.dart      # flutterfire configure 產生
│   ├── l10n/
│   │   ├── app_en.arb             # template
│   │   ├── app_zh_CN.arb
│   │   ├── app_zh_TW.arb
│   │   └── ...                    # 共 16 個 .arb
│   ├── router/
│   │   └── app_router.dart        # go_router 設定
│   ├── core/
│   │   ├── permissions/           # 權限服務與 Dialog
│   │   ├── audio/                 # just_audio / audio_service 封裝
│   │   ├── auth/                  # Firebase Auth 服務（匿名/Email/Google）
│   │   └── storage/               # prefs / sqflite
│   ├── features/
│   │   ├── music_list/
│   │   ├── player/
│   │   └── profile/
│   │       ├── profile_page.dart
│   │       ├── account/
│   │       ├── statistics/
│   │       ├── settings/
│   │       └── about/
│   └── shared/
│       ├── widgets/
│       └── theme/
└── test/
```

### M2 多語言（i18n）流程

#### Google Sheet 結構
翻譯來源（已建立）：
https://docs.google.com/spreadsheets/d/1gqtCfGthdTm9boTE2_ez0aCVxBxq1QnGaNucq82bEOs/edit

欄位設計（第一欄 `key`，之後 16 欄各為一個語系）：

| key | en | zh_CN | zh_TW | es | ... | ar |
|-----|----|----|----|----|----|----|
| `app_title` | Seek Player | 时间位移播放器 | 時間位移播放器 | Reproductor Seek | ... | مشغل سيك |
| `tab_music_list` | Music | 音乐 | 音樂 | Música | ... | الموسيقى |
| `tab_player` | Player | 播放器 | 播放器 | Reproductor | ... | المشغل |
| `tab_profile` | Profile | 我的 | 我的 | Perfil | ... | حسابي |

- 第一欄為 `key`（snake_case，如 `app_title`）。
- 之後 16 欄各代表一個語系（欄名即 locale code，底線格式如 `zh_TW`）。
- locale code 需與 `supportedLocales` 一致；空白儲存格腳本會 fallback 到 template（`en`）。

#### CSV 下載
Sheet 已設為「知道連結的人可檢視」，直接用 export 端點下載 CSV：
```
https://docs.google.com/spreadsheets/d/1gqtCfGthdTm9boTE2_ez0aCVxBxq1QnGaNucq82bEOs/export?format=csv&gid=0
```
此連結已寫入 `tool/l10n_config.yaml`。

#### 腳本：`tool/gen_l10n_from_sheet.dart`（已實作）
零依賴 Dart script（使用 `dart:io` / `dart:convert`，無需 pub 套件）。職責：
1. 讀 `tool/l10n_config.yaml` 取得 `csv_url` 等設定。
2. 以 `HttpClient` 下載 CSV（自動處理 Google 的 302 redirect）。
3. RFC 4180 CSV 解析（支援引號、逸出、欄內換行）。
4. 依語系欄位拆分，為每個 locale 產生 `lib/l10n/app_<locale>.arb`。
5. 空白儲存格 fallback 到 template（`en`）欄。

執行方式（已驗證可產生 16 個 .arb）：
```bash
dart run tool/gen_l10n_from_sheet.dart
flutter gen-l10n
```

產生的 ARB 範例 `lib/l10n/app_zh_TW.arb`：
```json
{
  "@@locale": "zh_TW",
  "app_title": "時間位移播放器",
  "tab_music_list": "音樂",
  "tab_player": "播放器"
}
```
> 目前 Sheet 無 `description` 欄，故 `.arb` 不含 `@key` metadata（本專案字串無 placeholder，gen-l10n 不需要）。若日後要加說明，於 Sheet 新增 `description` 欄並調整腳本即可。

#### `l10n.yaml` 設定
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

#### `MaterialApp` 接線
```dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```
存取：`AppLocalizations.of(context)!.appTitle`

### M3 權限 Dialog 流程

#### 需要的權限
| 平台 | 權限 | 觸發時機 |
|------|------|----------|
| Android 13+ | `READ_MEDIA_AUDIO` | 讀取本機音樂 |
| Android ≤12 | `READ_EXTERNAL_STORAGE` | 讀取本機音樂 |
| Android 13+ | `POST_NOTIFICATIONS` | 通知列播放控制 |
| Android | `FOREGROUND_SERVICE` / `FOREGROUND_SERVICE_MEDIA_PLAYBACK` | 背景播放 |

#### Dialog UX
1. 使用者首次點「匯入」/ 首次進入需讀檔的流程。
2. 先彈出**自訂說明 Dialog**（pre-permission rationale）：說明為何需要權限、會用來做什麼。
   - 按鈕：「允許」→ 呼叫系統權限請求；「暫不」→ 關閉。
3. 系統權限對話框結果處理：
   - 已授權 → 繼續流程。
   - 拒絕 → 顯示提示 Snackbar / Dialog。
   - 永久拒絕（`permanentlyDenied`）→ Dialog 引導前往「應用程式設定」(`openAppSettings()`)。

```dart
Future<bool> ensureAudioPermission(BuildContext context) async {
  final status = await Permission.audio.status;
  if (status.isGranted) return true;

  final agreed = await showPermissionRationaleDialog(context); // 自訂說明 Dialog
  if (!agreed) return false;

  final result = await Permission.audio.request();
  if (result.isPermanentlyDenied) {
    await showOpenSettingsDialog(context); // 引導去設定
    return false;
  }
  return result.isGranted;
}
```

### M4 音樂列表 MusicListPage
- 顯示掃描到的**本機音訊檔案**清單（封面、歌名、演出者、時長）。
- 首次進入需權限掃描媒體庫；亦可右上角「匯入」按鈕透過 `file_picker` 選檔加入。
- 前置**檔案 / 音訊權限 Dialog**（見 M3）。
- 點擊曲目 → 開始播放並導向播放器。
- 支援搜尋、排序、依資料夾分類。

### M5 播放器 PlayerPage
- 大封面、歌名 / 演出者。
- 進度條（seek bar，呼應 app 名 "seek"）、目前時間 / 總時長。
- 控制：上一首 / 播放-暫停 / 下一首、隨機、循環。
- 音量、播放速度（選配）。
- 背景播放與系統通知列控制（`audio_service`）。

### M6 我的 ProfilePage
ListView 形式，四個入口：

| 項目 | 內容 |
|------|------|
| 帳戶 AccountPage | Firebase Auth：登入 / 登出、頭像、使用者資訊（Email / Google） |
| 統計數據 StatisticsPage | 總播放時長、播放次數、最常聽曲目、聆聽趨勢圖 |
| 設定 SettingsPage | 語言切換（16 語系）、主題（深 / 淺色）、音質、清除快取 |
| 關於 AboutPage | App 版本、開發者、授權、隱私權政策、開源套件 |

帳戶 AccountPage（Firebase Authentication）：
- **登入為選用**：未登入時可匿名使用（`signInAnonymously`），App 全功能可用。
- 登入方式（v1）：
  - **Email / 密碼**（含註冊、忘記密碼、重設）。
  - **Google 登入**（`google_sign_in` + Firebase）。
- 已登入：顯示頭像、名稱、Email、登出、刪除帳號。
- 匿名 → 正式帳號可用 `linkWithCredential` 升級，保留既有資料。
- Firebase 設定：`flutterfire configure` 產生 `firebase_options.dart`；Android 需 `google-services.json`。
- 注意：Google 登入需在 Firebase Console 啟用並設定 SHA-1（Android）。
- 🔜 **Apple 登入**：規劃於 [`becklog.md`](becklog.md)，v1 不實作。

### M7 收尾
- 深淺色主題、RTL（`EdgeInsetsDirectional`）、測試、analyze、打磨。
