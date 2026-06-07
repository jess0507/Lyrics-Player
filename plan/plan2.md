# Plan2

## 待辦
1. ⬜ **增加播放器快進或快退按鈕**：點擊一下會快進、退後5秒，持續點著會快速進退。
2. ⬜ **增加播放器播放速度按鈕**：會有dialog顯示可選的播放速度，從0.5x~4x，間隔0.1，選擇後會改變播放速度。
3. ⬜ **i18n 新增字串尚未進 Sheet**：本次新增的 UI key 僅 `en`/`zh_TW`/`zh_CN` 有翻譯，其餘 13 語系 gen-l10n fallback 到 `en`。需將新 key 補進 tool/app_string.csv, 幫我產生另一個script: gen_l10n_from_local, 先以local翻譯為主。
4. ⬜ **本地資料**: 使用 Isar 實作資料庫, 儲存audio or media file data
5. ⬜ **本地資料**: 使用 SharedPreferences 儲存使用者設定, ex. 語系, 主題; 不儲存任何audio or media file data
6. ⬜ **上架CICD**: 當master有新的TAG則自動上架到Play Store
7. ⬜ **關於頁**：隱私權政策連結為占位，尚未接實際網址。 
8. ⬜ **實機驗證**：尚未在實體裝置 / 模擬器執行（僅通過 build / analyze / test）。 