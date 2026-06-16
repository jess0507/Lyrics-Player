# 歌詞功能:自動對時(txt → 同步)— aeneas 路線(backlog 5)

狀態:**後端容器已實作、待部署驗證;Flutter 端未做**(2026-06-16)。

### 實作進度 / 決策(2026-06-16)

- **範圍**:先做後端容器(本輪),Flutter 端待下一輪。後端部署 / 對齊品質
  驗證需 GCP 權限,於開發環境無法代跑。
- **後端落在新目錄 `aeneas_service/`**(獨立於 `functions/` 的 Firebase
  Functions):aeneas 需 espeak / ffmpeg 系統依賴,標準 Functions runtime 裝
  不下,故走 **Cloud Run 自架容器**(`Dockerfile` + Flask `main.py`)。
  - `main.py`(`/healthz`、`/align`)、`aligner.py`(aeneas 核心)、
    `lrc.py`(秒 → `[mm:ss.xx]`,沿用 import 計畫的百分秒慣例)、
    `test_lrc.py`(純邏輯單元測試,`python -m unittest test_lrc` 9 項全過)。
  - Dockerfile 釘 **Python 3.8 + numpy 1.23.5 + aeneas 1.7.3.0**:aeneas 為
    2017 舊套件、含 C 擴充,對新版 Python/numpy 易編譯失敗,先裝 numpy 再裝
    aeneas。
- **音訊傳輸採「先壓縮 + GCS 中轉」**:`/align` 的 `audio.gcs={bucket,object}`
  為正式路線(後端下載、可 `deleteAfter` 或靠 bucket lifecycle 清理);另留
  `audio.inlineBase64`(≤50MB)供本機 / 小檔測試。App 端應先壓成單聲道低取樣
  (如 16kHz mono opus)再上傳。
- **「音訊取得」其實有解**:`on_audio_query` 的 `SongModel.data` 是真實檔案路徑
  (`music_library.dart:38` 已用),匯入服務也以 `File(path)` 讀檔——Flutter 端
  可由此讀音訊 bytes、壓縮後上傳,毋須只靠 content URI。
- **API 合約 / 錯誤碼 / 部署步驟**:見 `aeneas_service/README.md`。失敗一律不回
  半套時間,對齊失敗(`alignment_failed` 422)時 App 應保留原 unsynced 文字。
- **待辦(下一輪 Flutter 端)**:讀檔 + 壓縮 + 上傳 GCS、呼叫 `/align`(鑑權:
  Firebase Function 代呼或帶 ID token)、寫回 `LyricsEntity`、進度 / 失敗 UI、
  l10n。

---

原始規劃(2026-06-14):
姊妹計畫:`plans/lyrics-auto-sync-whisperx.md`(同一任務的另一條技術路線,
字級時間更細、中文品質一般較佳)。
相關:`plans/lyrics-import.md`(地基:`LyricsEntity` / 統一 `Lyrics` 模型 /
parser)、`plans/lyrics-display.md`(同步捲動顯示,本任務產物直接複用)、
`plans/lyrics-auto-generate.md`(backlog 6,「沒有歌詞 → STT 從零產生」)。
本任務是其姊妹:**已有正確文字、只缺時間**。產物寫回同一 `LyricsEntity`
(`source = generated`、`format = lrc`)。

## 背景 / 目標

- 使用者已匯入 `.txt`(unsynced)歌詞:文字正確、但無時間戳,顯示時只能當
  靜態整篇。目標是**偵測每行起始時間**,產出同步歌詞(LRC),複用顯示計畫的
  逐行 highlight + 自動置中捲動 + 點行 seek。
- 與「自動產生(6)」的關鍵差異:
  - auto-generate:`audio → 文字 + 時間`(STT,從零辨識,丟棄既有文字)。
  - **本任務(auto-sync):`既有文字 + audio → 時間`**(forced alignment)。
    文字已知且已校對,問題更窄、對歌聲的容錯遠高,品質可期。

## 為何選 aeneas(本路線定位)

- **aeneas** 專為「文字 ↔ 朗讀音訊」對齊而生:espeak g2p + DTW,多語,
  直接輸出 SRT/VTT(可轉 LRC)。是 forced alignment 的**起步首選**——
  依賴單純、容器化容易、行級對齊夠用。
- 既然歌詞文字已知,正解就是 forced alignment(保留使用者已校對的文字,
  只補時間、不改字),遠優於純 ASR 轉寫。
- **限制 / 風險**:aeneas 靠 espeak g2p,**中文對齊品質需實測**;歌聲
  (拉長音、配樂干擾)比朗讀難對。若中文 / 細緻度不足 → 升 WhisperX 路線
  (見姊妹計畫)。

## 部署

- 專案已用 Firebase Functions(GCP),可把 aeneas 包成 **Cloud Run 容器**、
  由 Function 觸發。低頻使用在免費 / 低額度內可行。
- **音訊留在自家後端,隱私 / 版權風險最低**(本任務處理使用者本機音樂)。
  沒有穩定的「免費託管 forced-alignment API」——要正解品質基本得自架。

## 流程(後端對齊 service)

1. 取整段音訊解碼檔 / PCM(**注意:App 以 content URI 播放、不持有檔案本體**,
   需把音訊送後端;上傳成本 / 權限待確認——與 auto-generate 共用此未解問題)。
2. 取 `.txt` 逐行純文字(去空行 / 修飾)。
3. aeneas forced alignment → 每行起始(可含結束)時間。
4. 組 LRC(`[mm:ss.xx]` 每行)。
5. 回傳並存回 `LyricsEntity`(`source = generated`、`format = lrc`),
   `invalidate` 對應 `trackLyricsProvider`;顯示自動切到同步視圖。

## 建議路線(決策)

1. **以 aeneas 起步**:容器化、Cloud Run + Firebase Function 觸發,先驗證
   行級對齊在實際歌曲上的品質。
2. **中文 / 細緻度不足再升級**:轉 `plans/lyrics-auto-sync-whisperx.md`
   (wav2vec2 字級對齊)或 MFA。
3. **產物**:組成 LRC 寫回同一 `LyricsEntity`(`source = generated`、
   `format = lrc`);UI 標示「自動對時、可能有誤」,引導用編輯歌詞
   (backlog 7)修正。**顯示端(lyrics-display)完全不用改**。

## 邊界 / 風險 / 待調查

- **音訊取得**:content URI → 後端,與 auto-generate 同一待解問題(權限 /
  傳輸量 / 大檔)。
- **中文對齊**:aeneas 靠 espeak,中文需實測;不足則改 WhisperX。
- **歌聲難度**:拉長音 / 配樂干擾比朗讀難對,行級時間可能漂移。
- **失敗降級**:對齊失敗 / 信心低 → 保留原 unsynced 純文字,不硬塞錯時間。
- **成本**:Cloud Run 冷啟動 + 運算;免費 / 低額度內低頻可行,需估算。
- **隱私 / 版權**:自架明顯優於上傳第三方。

## 修改 / 新增(預計)

- `functions/`(或新 Cloud Run 容器)— aeneas forced-alignment 端點。
- `lib/features/lyrics/` — 呼叫對齊的 service + 衍生 provider
  (一檔一 provider,依 CLAUDE.md)。
- 產物複用 `LyricsEntity`(`source = generated`、`format = lrc`);
  顯示端 `lyrics-display` 不改。
- `l10n` — 對時中 / 失敗 / 「自動對時、可能有誤」標示
  (en + zh_TW + zh_CN,其餘 fallback,待補 Google Sheet)。
