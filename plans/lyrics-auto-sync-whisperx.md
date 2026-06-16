# 歌詞功能:自動對時(txt → 同步)— WhisperX 路線(backlog 5)

狀態:**規劃 / 待調查**(2026-06-14)。
姊妹計畫:`plans/lyrics-auto-sync-aeneas.md`(同一任務的起步路線,依賴單純、
容器化容易、行級對齊)。本路線為**升級選項**:字級時間更細、中文對齊一般較佳。
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

## 為何選 WhisperX(本路線定位)

- **WhisperX / NeMo Forced Aligner**:以 **wav2vec2 對齊**,產出**字級**
  時間戳,粒度比 aeneas 的行級更細。
- **中文對齊品質一般優於 aeneas 的 espeak g2p 路線**——當 aeneas 行級對齊在
  中文 / 歌聲上漂移時,這是主要升級方向。
- 仍是 forced alignment 的範疇:保留使用者已校對的文字,只補時間、不改字。
  (若要再追求極致準確度,MFA 最準但需各語言發音字典、較重,屬更後期選項。)
- **成本權衡**:wav2vec2 模型較重,Cloud Run 運算 / 記憶體需求高於 aeneas,
  冷啟動與費用需估算。

## 部署

- 專案已用 Firebase Functions(GCP),把 WhisperX 包成 **Cloud Run 容器**、
  由 Function 觸發(模型較大,留意映像體積 / 記憶體 / GPU 與否)。
- **音訊留在自家後端,隱私 / 版權風險最低**(本任務處理使用者本機音樂)。
  沒有穩定的「免費託管 forced-alignment API」——要正解品質基本得自架。

## 流程(後端對齊 service)

1. 取整段音訊解碼檔 / PCM(**注意:App 以 content URI 播放、不持有檔案本體**,
   需把音訊送後端;上傳成本 / 權限待確認——與 auto-generate 共用此未解問題)。
2. 取 `.txt` 逐行純文字(去空行 / 修飾)。
3. WhisperX forced alignment(wav2vec2)→ 字級時間;聚合回每行起始
   (可含結束)時間。
4. 組 LRC(`[mm:ss.xx]` 每行;字級時間預留給未來逐字 highlight)。
5. 回傳並存回 `LyricsEntity`(`source = generated`、`format = lrc`),
   `invalidate` 對應 `trackLyricsProvider`;顯示自動切到同步視圖。

## 建議路線(決策)

1. **作為 aeneas 的升級**:當 `lyrics-auto-sync-aeneas.md` 在中文 / 細緻度
   實測不足時切到本路線。若一開始就以中文歌為主,可直接評估 WhisperX。
2. **字級時間**:LRC 先用行級,字級時間保留供未來逐字 highlight。
3. **產物**:組成 LRC 寫回同一 `LyricsEntity`(`source = generated`、
   `format = lrc`);UI 標示「自動對時、可能有誤」,引導用編輯歌詞
   (backlog 7)修正。**顯示端(lyrics-display)完全不用改**。

## 邊界 / 風險 / 待調查

- **音訊取得**:content URI → 後端,與 auto-generate 同一待解問題(權限 /
  傳輸量 / 大檔)。
- **模型重量**:wav2vec2 映像 / 記憶體 / 冷啟動成本高於 aeneas,需估算
  (是否需 GPU)。
- **歌聲難度**:拉長音 / 配樂干擾仍是挑戰,但字級對齊容錯通常較佳。
- **失敗降級**:對齊失敗 / 信心低 → 保留原 unsynced 純文字,不硬塞錯時間。
- **成本**:Cloud Run 運算 + 冷啟動;低頻使用需估算是否仍在可接受額度。
- **隱私 / 版權**:自架明顯優於上傳第三方。

## 修改 / 新增(預計)

- `functions/`(或新 Cloud Run 容器)— WhisperX forced-alignment 端點。
- `lib/features/lyrics/` — 呼叫對齊的 service + 衍生 provider
  (一檔一 provider,依 CLAUDE.md)。
- 產物複用 `LyricsEntity`(`source = generated`、`format = lrc`);
  顯示端 `lyrics-display` 不改。
- `l10n` — 對時中 / 失敗 / 「自動對時、可能有誤」標示
  (en + zh_TW + zh_CN,其餘 fallback,待補 Google Sheet)。
