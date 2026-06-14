# 歌詞功能:自動產生(backlog 5)

狀態:**最遠期,暫不設計**(2026-06-14 自歌詞匯入計畫 M4 拆出)。
影響範圍(預計):`lib/features/lyrics/`、平台端語音辨識整合、l10n。
相關:`plans/lyrics-import.md`(歌詞功能群地基:資料模型 `LyricsEntity` /
統一 `Lyrics` 模型 / parser)、`plans/lyrics-display.md`(顯示);
本任務的產出寫回同一個 `LyricsEntity`(source = generated)。

## 背景 / 目標

- 對沒有現成歌詞檔、線上也搜不到的曲目(backlog 4 上網搜尋失敗的 fallback),
  以語音辨識(STT)從音訊直接產生歌詞,理想含逐行時間戳以複用同步捲動顯示。
- 屬歌詞功能群第四階段,排在匯入(2)/ 顯示(3)/ 上網搜尋(4)/ 編輯(6)之後。

## 未定 / 待調查

- **辨識引擎**:裝置端(whisper.cpp / faster-whisper 類)vs 雲端 API,
  成本、品質、隱私、App 體積、離線可用性都未評估。
- **音訊存取**:App 以 content URI 播放、不持有檔案本體;
  STT 需讀取整段 PCM,取得方式與權限待確認。
- **時間戳**:多數 STT 給字級 / 段級時間,需對齊到 `Lyrics` 的逐行模型;
  品質不穩時降級為 unsynced 純文字。
- **產物標記 source = generated**,並在 UI 標示「自動產生、可能有誤」,
  引導使用者用編輯歌詞(backlog 6)修正。

## 備註

- 成本與品質都未定,本任務最遠期;先佔位記錄方向,實作前需專門調查再補設計。
