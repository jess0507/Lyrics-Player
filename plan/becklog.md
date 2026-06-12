# Seek Player — 版本二 (v2) 規劃（Backlog）

## 背景

v1（[`plan.md`](plan.md)）與後續迭代（[`plan2.md`](plan2.md)）完成後，
尚未排入實作的功能集中於此，作為 v2 的 backlog。

## 現況

**全部未開始**（⬜）。各項實作前建議先開對應的 `tasks/*.md` 記錄決策。

## 待辦項目

- ⬜ **背景播放**：目前滑掉 app 可以播放，但在 notification 沒辦法操作暫停或滑動進度條。
- ⬜ **帳戶**：Firebase Auth — 選用登入 OTP / Email / Google。
- ⬜ **遠端資料**：Firestore 雲端同步未實作，要同步使用者設定、統計數據等。
- ⬜ **媒體庫自動掃描**：目前僅手動匯入，未實作開機掃描裝置音訊（可導入 `on_audio_query` 之類）。
- ⬜ **曲目中繼資料**：標題取自檔名，未讀取 ID3（封面 / 演出者 / 專輯）。
- ⬜ **其他上架平台**：華為 AppGallery、蘋果 App Store 等尚未規劃。
