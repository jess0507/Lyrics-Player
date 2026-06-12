# 歌詞功能:手動匯入 + 顯示(backlog 2、3)

狀態:**規劃中**(2026-06-12 起草,未實作)。
影響範圍(預計):`lib/features/lyrics/`(新)、`lib/features/player/`、`pubspec.yaml`、l10n。
相關:`plans/becklog.md`(項目 2–6 為歌詞功能群,本計畫為第一階段;
項目 7 ID3 中繼資料與「嵌入式歌詞」共用讀 tag 能力,見文末分期)。

## 背景 / 目標

- 曲目來自 MediaStore 掃描(`music_library.dart`),以 content URI 播放,
  App 不持有音訊檔本體,也未讀任何 tag(標題取自 MediaStore)。
- v2 backlog 的歌詞功能群共五項(匯入 / 顯示 / 上網搜尋 / 自動產生 / 編輯)。
  本計畫先做地基:**手動匯入歌詞檔 + 在播放頁顯示(含時間同步捲動)**,
  資料模型與儲存設計需讓後續三項(搜尋 / 產生 / 編輯)直接複用。

## 歌詞檔案格式調查(file types)

### 外部歌詞檔(本階段支援)

| 格式 | 副檔名 | 時間資訊 | 說明 / 解析要點 |
| --- | --- | --- | --- |
| LRC(標準) | `.lrc` | 每行 `[mm:ss.xx]` | 主流歌詞格式。需處理:ID tags(`[ti:]` `[ar:]` `[al:]` `[offset:]` 等)、**一行多時間戳**(副歌重複句共用一行)、`offset` 全域平移。 |
| LRC(Enhanced) | `.lrc` | 行 + 逐字 `<mm:ss.xx>` | 逐字 karaoke 標記。v1 **降級為整行**:取行時間戳、剝除 `<>` 標記,不做逐字高亮。 |
| SRT | `.srt` | 起迄時間區段 | 字幕格式(`00:01:02,500 --> ...`)。格式單純,匯入時轉內部模型、只取起始時間。 |
| WebVTT | `.vtt` | 起迄時間區段 | 同 SRT 處理,差異:`WEBVTT` 檔頭、毫秒用 `.`。 |
| 純文字 | `.txt` | 無 | 不同步,顯示為可捲動的靜態整篇。 |

### 文字編碼

- UTF-8(含 BOM 偵測)為主;歷史 LRC 常見 GBK / Big5 / Shift-JIS。
- v1 策略:嚴格 UTF-8 解碼失敗時,改 `allowMalformed` 顯示並接受少量亂碼,
  列為已知限制;若實際遇到再引入 `charset_converter`(走平台原生解碼)做
  GBK / Big5 嘗試,不預先加依賴。

## 結論(設計決策)

1. **匯入走 SAF 手動選檔**(`file_picker`,`FileType.custom`,
   extensions: lrc / txt / srt / vtt)。**不做 sidecar 自動配對**
   (音訊同資料夾的同名 `.lrc`):Android 13+ 的 `READ_MEDIA_AUDIO`
   不涵蓋非媒體檔,讀不到歌詞檔;sidecar 需另要 SAF 資料夾授權,列入後續。
2. **儲存「原始內文」進 Isar,顯示時解析**:新 `LyricsEntity`
   (trackId 唯一索引 replace / title / format / source / content / addedAt)。
   - 存原文不存解析結果:編輯(backlog 6)與 parser 演進都不受內部模型綁死;
     解析很快,讀取時 parse 即可。
   - 不複製歌詞檔到 App 目錄(內容已入庫,檔案本體不再需要)。
   - **不同步 Firestore**:歌詞文字有體積與版權疑慮,純本機資料;
     換機遺失屬可接受(重新匯入即可)。
3. **內部統一模型**:`Lyrics { lines: List<LyricsLine(time?, text)>, synced }`。
   四種檔案格式都收斂到這一個模型;`time == null` 全部成立即 unsynced,
   顯示為靜態文字。LRC 的 `offset` 在 parse 時套進 time。
4. **parser 自寫**(不用 [lrc](https://pub.dev/packages/lrc/versions) /
   [lyrics_parser](https://pub.dev/packages/lyrics_parser/versions) 套件):
   LRC / SRT / VTT 規則都很小,自寫才能統一輸出同一個模型、好寫單元測試,
   也避免為三個小格式掛三個依賴。
5. **顯示 UI 自製**(不用 [flutter_lyric](https://pub.dev/packages/flutter_lyric)):
   播放頁 artwork 區切換歌詞視圖(無歌詞時顯示匯入入口)。
   同步歌詞:目前行 highlight + 自動置中捲動 + **點行 seek**;
   位置來源 `positionStream`(節流到 ~200ms 再算目前行,行數用二分搜尋)。
   flutter_lyric 功能完整但樣式與互動綁定深,專案慣例是自組 widget。
6. **trackId 沿用 MediaStore ID**(裝置綁定,同統計的已知限制);
   title 一併入庫,留跨機 / 重掃後對齊的線索,但 v1 不做 title fallback 配對。

## 分期(對應 backlog)

- **M1(本計畫)**:手動匯入(2)+ 顯示(3)。
- **M2:編輯歌詞(6)**:直接編輯 `LyricsEntity.content` 原文 + 重新解析預覽;
  順手加「offset 微調」UI(整體 ±0.5s)。
- **M3:上網搜尋歌詞(4)**:候選來源 LRCLIB(lrclib.net,免費、無 API key,
  以 title / artist / duration 查詢,提供 plain + synced;實作時再驗證服務現況)。
  搜尋結果寫入同一個 `LyricsEntity`(source = online)。
- **M4:自動產生歌詞(5)**:語音辨識(裝置端 whisper 類或雲端 API),
  成本與品質都未定,最遠期,暫不設計。
- **嵌入式歌詞**:併入 backlog 7(ID3 中繼資料)任務。

## M1 步驟

1. **依賴**:加 `file_picker`(僅此一個新依賴)。
2. **資料層**(`lib/features/lyrics/`,依 CLAUDE.md 一檔一 provider):
   `lyrics_entity.dart`(@collection + 產生碼)、
   `lyrics_repository.dart`(Isar CRUD + provider)、
   `track_lyrics_provider.dart`(依目前曲目查歌詞的衍生 provider)。
3. **解析層**:`lyrics_parser.dart`(純函式:偵測格式 → `Lyrics` 模型;
   LRC 多時間戳展開後依時間排序)+ 單元測試
   (LRC 標準 / enhanced 降級 / 多時間戳 / offset、SRT、VTT、TXT、壞檔容錯)。
4. **匯入流程**:`lyrics_import_service.dart`(file_picker 選檔 → 大小上限
   約 1MB → 解碼(編碼策略見上)→ 試 parse 驗證 → 存 Isar)。
   入口:播放頁歌詞視圖的空狀態按鈕(主要入口);失敗以 SnackBar 提示。
5. **顯示**:`features/player/widgets/lyrics_view.dart`
   (synced:highlight + 自動捲動 + 點行 seek;unsynced:靜態捲動;
   使用者手動捲動時暫停自動捲動數秒)。
   播放頁 artwork ↔ 歌詞切換(點擊 artwork 或角落按鈕,擇一,實作時定)。
   歌詞視圖選單:重新匯入、刪除歌詞。
6. **l10n**:匯入按鈕 / 無歌詞空狀態 / 匯入成功與失敗 / 刪除確認等 key,
   照慣例 en + zh_TW + zh_CN,其餘 fallback;**待辦:補進 Google Sheet**。
7. 驗證:`flutter analyze`、`flutter test`(parser 測試為主)、
   實機匯入各格式檔案走一輪(含非 UTF-8 檔與壞檔)。

## 邊界 / 風險

- **孤兒歌詞**:曲目刪除或重掃後 trackId 消失,歌詞留在 Isar 但查不到;
  v1 不清理(量小無害),日後可在重掃時做垃圾回收。
- **LRC 無時間戳行**(檔頭 metadata、空行):parse 時略過或併入 unsynced 段,
  不得讓整檔判定失敗。
- **同一曲重複匯入**:唯一索引 replace,直接覆蓋舊歌詞(符合直覺,不另問)。
- **mini player 不顯示歌詞**,僅完整播放頁。
- **效能**:歌詞行數通常 < 200,ListView + 二分搜尋足夠,無需虛擬化以外的優化。
