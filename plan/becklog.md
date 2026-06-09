# Seek Player — 版本二 (v2) 規劃

## 0. Tasks
- ⬜ **背景播放**: 目前滑掉app可以播放，但在notification沒辦法操作暫停或滑動進度條。
- ⬜ 帳戶：Firebase Auth — 選用登入 OTP / Email / Google
- ⬜ **遠端資料**: Firestore 雲端同步未實作, 要同步使用者設定、統計數據等。
- ⬜ **媒體庫自動掃描**：目前僅手動匯入，未實作開機掃描裝置音訊（可導入 `on_audio_query` 之類）。 
- ⬜ **曲目中繼資料**：標題取自檔名，未讀取 ID3（封面 / 演出者 / 專輯）。
- ⬜ **其他上架平台**: 華為 AppGallery、蘋果 App Store 等尚未規劃。