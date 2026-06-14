# 歌詞功能:自動對時(txt → 同步,forced alignment)(backlog 5)

狀態:**規劃 / 待調查**(2026-06-14)。
相關:`plans/lyrics-import.md`(地基:`LyricsEntity` / 統一 `Lyrics` 模型 /
parser)、`plans/lyrics-display.md`(同步捲動顯示,本任務產物直接複用)、
`plans/lyrics-auto-generate.md`(backlog 6,「沒有歌詞 → STT 從零產生」);
本任務是其姊妹:**已有正確文字、只缺時間**。產物寫回同一 `LyricsEntity`
(`source = generated`、`format = lrc`)。

## 背景 / 目標

- 使用者已匯入 `.txt`(unsynced)歌詞:文字正確、但無時間戳,顯示時只能當
  靜態整篇。目標是**偵測每行起始時間**,產出同步歌詞(LRC),複用顯示計畫的
  逐行 highlight + 自動置中捲動 + 點行 seek。
- 與「自動產生(5)」的關鍵差異:
  - auto-generate:`audio → 文字 + 時間`(STT,從零辨識,丟棄既有文字)。
  - **本任務(auto-sync):`既有文字 + audio → 時間`**(forced alignment)。
    文字已知且已校對,問題更窄、對歌聲的容錯遠高,品質可期。

## 核心技術判斷

- 既然歌詞文字已知,正解是 **forced alignment(強制對齊)**:把已知文字段落
  對齊到音訊,得每行(可含每字)時間戳。對「唱歌人聲」遠優於純 ASR 轉寫,
  且**保留使用者已校對的文字**(只補時間,不改字)。
- 純 ASR(`audio → 文字 + 時間`)不適合本任務:歌聲辨識率低,且會丟棄正確的
  `.txt`。那是 auto-generate 的領域,不是這裡。

## 免費方案盤點(host / 隱私 / 準確度 / 整合成本)

### 1. 自架 forced aligner(推薦正解)
- **aeneas** — Python/C,專為「文字 ↔ 朗讀音訊」對齊而生,直接輸出
  SRT/VTT(可轉 LRC);espeak g2p + DTW,多語。最貼合本任務。
- **WhisperX / NeMo Forced Aligner** — wav2vec2 對齊,字級時間更細,
  中文對齊品質一般優於 aeneas 的 espeak 路線。
- **Montreal Forced Aligner(MFA)** — 最準,但需各語言發音字典、較重。
- **部署**:專案已用 Firebase Functions(GCP),可把 aligner 包成 Cloud Run
  容器、由 Function 觸發。低頻使用在免費 / 低額度內可行。**音訊留在自家後端,
  隱私 / 版權風險最低**。沒有穩定的「免費託管 forced-alignment API」——
  要正解品質基本得自架。

### 2. 免費託管 API(起步最快,品質折衷)
- **Groq 免費 tier**:whisper-large-v3 / turbo,支援 word / segment
  timestamps,免費額度約 2000 RPD。屬 ASR——需拿它的 word timestamps 再
  **模糊比對對映回 `.txt` 各行**(本身也是一道對齊題)。對歌聲準確度與對映
  品質都有風險。
- **Gliss 等線上 lyrics-alignment 免費工具**:無帳號可用,但為第三方網頁服務,
  程式化呼叫 / 穩定性 / 條款未定。
- **共同風險**:把使用者音樂上傳第三方(隱私 / 版權)。

### 3. 裝置端
- whisper.cpp / wav2vec2 + 對齊,離線、不外傳;但 App 體積、記憶體與耗電大,
  最遠期。

## 建議路線(決策)

1. **正解:自架 forced alignment**——aeneas 起步,中文 / 細緻度不足再升
   WhisperX 或 MFA;經 Cloud Run 容器 + Firebase Function 觸發。
2. **MVP / 可行性 spike(可選)**:先接 Groq 免費 API 取 word timestamps,
   比對既有 `.txt` 行驗證流程跑得通;**不作長期方案**(隱私 + 歌聲準確度)。
3. **產物**:組成 LRC 寫回同一 `LyricsEntity`(`source = generated`、
   `format = lrc`);UI 標示「自動對時、可能有誤」,引導用編輯歌詞
   (backlog 7)修正。**顯示端(lyrics-display)完全不用改**。

## 流程(後端對齊 service)

1. 取整段音訊解碼檔 / PCM(**注意:App 以 content URI 播放、不持有檔案本體**,
   需把音訊送後端;上傳成本 / 權限待確認——與 auto-generate 共用此未解問題)。
2. 取 `.txt` 逐行純文字(去空行 / 修飾)。
3. forced alignment → 每行起始(可含結束)時間。
4. 組 LRC(`[mm:ss.xx]` 每行)。
5. 回傳並存回 `LyricsEntity`(`source = generated`、`format = lrc`),
   `invalidate` 對應 `trackLyricsProvider`;顯示自動切到同步視圖。

## 邊界 / 風險 / 待調查

- **音訊取得**:content URI → 後端,與 auto-generate 同一待解問題(權限 /
  傳輸量 / 大檔)。
- **無免費託管對齊 API**:免費託管多是 ASR;要正解品質需自架。
- **中文 / 多語**:aeneas 靠 espeak,中文對齊需實測;WhisperX 中文較佳。
- **失敗降級**:對齊失敗 / 信心低 → 保留原 unsynced 純文字,不硬塞錯時間。
- **成本**:Cloud Run 冷啟動 + 運算;免費 / 低額度內低頻可行,需估算。
- **隱私 / 版權**:自架明顯優於上傳第三方(本任務處理使用者本機音樂)。

## 修改 / 新增(預計)

- `functions/`(或新 Cloud Run 容器)— forced-alignment 端點。
- `lib/features/lyrics/` — 呼叫對齊的 service + 衍生 provider
  (一檔一 provider,依 CLAUDE.md)。
- 產物複用 `LyricsEntity`(`source = generated`、`format = lrc`);
  顯示端 `lyrics-display` 不改。
- `l10n` — 對時中 / 失敗 / 「自動對時、可能有誤」標示
  (en + zh_TW + zh_CN,其餘 fallback,待補 Google Sheet)。
