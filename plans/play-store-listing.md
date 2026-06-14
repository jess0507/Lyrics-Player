# Google Play 商店文案（Store Listing）

撰寫日期：2026-06-11。

## 背景 / 問題

App 上架 Google Play 需要商店文案（簡短說明 + 完整說明）。限制與原則：

- Google Play 限制：簡短說明 **80 字元**、完整說明 **4000 字元**。
- 完整說明不支援 Markdown，僅支援少量 HTML（如 `<b>`），故以純文字 + emoji 排版，可直接貼上。
- 依 `lib/features` 與 l10n 字串確認之**既有功能**撰寫，未提及未實作項目（如線上串流、歌詞、等化器）。

## 結論

zh-TW 與 en 兩語系的簡短 / 完整說明已完成（見下方步驟 2–4 的文案區塊，可直接貼上 Play Console）。
其餘 14 個支援語系可後續翻譯。

## 步驟

1. 盤點既有功能（依 `lib/features` 與 l10n 字串）。
2. 撰寫簡短說明（zh-TW）。
3. 撰寫完整說明（zh-TW）。
4. 撰寫英文版（short + full description）。
5. 整理關鍵字策略備註。

## 各步驟說明

### 1. 盤點既有功能
確認可宣稱的功能：本機掃描 / 匯入、搜尋、背景播放與通知列控制、快轉倒轉（含長按連續 seek）、
倍速、循環 / 隨機、播放統計、16 語系（含 RTL）、深淺色 / 自訂主題色、選用帳戶與帳戶刪除。
不宣稱：線上串流、歌詞、等化器（未實作）。

### 2. 簡短說明（zh-TW，≤80 字元）

```
輕巧離線音樂播放器：掃描本機音樂，背景播放、倍速調整、循環隨機，內建播放統計。
```

### 3. 完整說明（zh-TW，≤4000 字元）

```
Seek Player 是一款輕巧、純離線的本機音樂播放器。不需要網路、不串流、不上傳你的音樂——打開 App 就能掃描裝置裡的音樂檔案，立即播放。

🎵 本機音樂，離線播放
• 自動掃描裝置媒體庫，也可手動匯入音樂檔案
• 支援重新掃描與從清單移除
• 關鍵字搜尋，快速找到想聽的歌
• 完全離線運作，不需要行動數據

🎧 背景播放
• 切到其他 App 或鎖定螢幕，音樂不中斷
• 通知列播放控制：播放/暫停、上一首/下一首

⏩ 精準的進度控制
• 快轉、倒轉，按住按鈕可連續快進/倒帶
• 倍速播放，隨時一鍵恢復原速
• 適合語言學習、聽力練習、有聲書與講座錄音：慢速逐句聽清楚，或加速複習

🔁 播放模式
• 循環播放、隨機播放，自由組合

📊 播放統計
• 記錄播放次數與累計聆聽時間
• 最常播放排行，看見自己的聆聽習慣
• 統計資料可隨時重設

🌍 支援 16 種語言
English、繁體中文、簡體中文、Español、Français、Deutsch、日本語、한국어、Português、Italiano、Русский、Türkçe、हिन्दी、Indonesia、Tiếng Việt、العربية（含 RTL 版面）

🎨 個人化
• 深色/淺色/跟隨系統主題
• 自訂主題色
• 介面語言可獨立切換

🔐 重視隱私
• 音樂檔案只留在你的裝置上，不上傳、不分析內容
• 帳戶為選用功能：可直接以訪客使用，也可用 Email、電話或 Google 登入
• 可隨時在 App 內刪除帳戶與相關資料

適合這樣的你：
• 想要一個簡單乾淨、開了就能聽的 MP3 / 音樂播放器
• 用音檔練習外語聽力、聽有聲書或課程錄音，需要倍速與精準快轉
• 不想讓音樂庫被上傳到雲端，重視離線與隱私

現在就下載 Seek Player，把你的本機音樂變成最順手的聆聽工具。
```

（約 760 字元，距 4000 上限仍有充足空間，日後新增功能可擴寫）

### 4. 英文版

Short description（en，≤80 chars）：

```
Offline local music player: background play, speed control, loop & stats.
```

（73 chars）

Full description（en）：

```
Seek Player is a lightweight, fully offline music player for your local files. No streaming, no uploads — open the app, scan your device, and play.

🎵 Local & offline
• Auto-scan your device's music library, or import files manually
• Rescan and remove tracks anytime
• Fast keyword search

🎧 Background playback
• Keeps playing while you use other apps or lock the screen
• Notification controls: play/pause, previous/next

⏩ Precise playback control
• Fast-forward and rewind — hold the button for continuous seeking
• Variable playback speed with one-tap reset
• Great for language learning, audiobooks and lecture recordings

🔁 Playback modes
• Loop and shuffle, combined however you like

📊 Listening statistics
• Play counts and total listening time
• Top tracks ranking, resettable anytime

🌍 16 languages
English, 繁體中文, 简体中文, Español, Français, Deutsch, 日本語, 한국어, Português, Italiano, Русский, Türkçe, हिन्दी, Indonesia, Tiếng Việt, العربية (with RTL layout)

🎨 Personalization
• Dark / light / system theme and custom accent color

🔐 Privacy first
• Your music stays on your device — never uploaded or analyzed
• Account is optional: use as guest, or sign in with Email, phone or Google
• Delete your account and data anytime, right inside the app

Download Seek Player and turn your local music files into the smoothest listening experience.
```

### 5. 關鍵字策略備註

- 簡短說明已涵蓋高搜尋量詞：離線、本機音樂、背景播放、倍速、播放統計。
- 完整說明自然帶入：MP3 播放器、音樂播放器、離線播放、語言學習、有聲書、隱私。
- 未宣稱「無廣告」於正式文案 —— 目前專案無廣告 SDK，若確定不上廣告，可在簡短說明補「無廣告」二字，是強力賣點。
- Google Play 主控台可為各語系分別填寫 listing，16 個支援語系建議至少補齊 en 與 zh-TW（以上已備），其餘可後續翻譯。
