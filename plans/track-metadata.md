# 曲目中繼資料 + 嵌入式歌詞(backlog 7)

狀態:**規劃中**(2026-06-12 起草,未實作)。
影響範圍(預計):`lib/features/music_list/`、`lib/core/audio/`、
`lib/features/player/`、`lib/features/mini_player/`、`lib/features/lyrics/`(承接
`lyrics-import-display.md` M1 的資料層)、`pubspec.yaml`。
相關:`plans/becklog.md` 項目 7;嵌入式歌詞依 `lyrics-import-display.md` 文末分期併入本任務。

## 現況

- `Track` 只有 id / uri / title / artist / durationMs(`track.dart`),
  掃描時未取 album / albumId(`music_library.dart`)。
- 通知列 `MediaItem` 只填 title / artist,無 album、無 `artUri` → 通知列無封面
  (`audio_player_service.dart:56`)。
- UI 全部用 placeholder icon:mini player 是 `Icons.music_note`,
  播放頁 `PlayerArtwork` 也是占位。
- 嵌入式歌詞完全沒讀(MediaStore 本來就不提供 lyrics)。
- **實機抽查(2026-06-12)**:adb 拉取裝置上 3 個 MP3 檢視 ID3 區塊,
  全部**沒有 USLT / SYLT 歌詞 frame**,連 TIT2 / TPE1 / TALB / APIC 都沒有
  (檔案多為 ffmpeg 轉出,只有 TSSE 編碼器 frame)——這正是 becklog 7
  「標題取自檔名」的真正原因:檔案本身無 tag,MediaStore 行為其實正確。
  → 嵌入式歌詞讀取保留為 fallback(順序:先查 embedded,無則走手動匯入),
  但對目前曲庫不會命中;**手動匯入(M1)才是實際主路徑,優先實作**。

## 調查結論:兩層中繼資料來源

### 第一層:MediaStore 已解析好的欄位(便宜,掃描時就拿)

on_audio_query 的 `SongModel` 已含 ID3 解析結果(由系統 media scanner 完成),
**封面 / 演出者 / 專輯不需要自己解析 tag**:

| 需求 | 來源 |
| --- | --- |
| 演出者 | `s.artist`(已在用) |
| 專輯 | `s.album`、`s.albumId`(未取,加進 `Track` 即可) |
| 封面 | `queryArtwork(id, ArtworkType.AUDIO)` 取 bytes(UI 縮圖 / 播放頁);通知列 `artUri` 用 `content://media/external/audio/albumart/<albumId>` |
| 標題 | `s.title` 即 MediaStore 解析的 ID3 title;becklog 說「標題取自檔名」是檔案本身無 title tag 時的 fallback,行為已正確,不需改 |

### 第二層:自己讀 tag(較貴,只為嵌入式歌詞)

MediaStore / MediaMetadataRetriever 都不暴露歌詞,必須讀檔案本體解析。

- **套件選定:`audio_metadata_reader`**(pub 1.6.0,純 Dart 無原生碼)。
  - `readMetadata(File, getImage: false)` → `AudioMetadata.lyrics: String?`,
    文件註明「Can be normal text or LRC」→ 正好交給 M1 自寫 parser 做格式偵測。
  - 涵蓋 MP3(ID3v2 USLT)/ MP4 `©lyr` / FLAC / OGG Vorbis `LYRICS`,
    與 `lyrics-import-display.md` 調查的三種容器一致。SYLT(同步 ID3)不支援,
    但實務罕見,接受。
  - 落選:`metadata_god`(Rust FFI,體積大)、`dart_tags`(年久失修、僅 ID3)。
- **檔案存取**:讀 tag 需要實體路徑,`Track` 增存 `s.data`。
  Android 13+ `READ_MEDIA_AUDIO` 下媒體檔可經 FUSE 路徑直接讀,
  但雲端 / 特殊 provider 的曲目可能讀不到 → try/catch 靜默失敗即可。

## 設計決策

1. **不在掃描時全庫讀 tag**:歌詞 lazy 讀——開播放頁歌詞視圖、
   且 Isar 查無該曲歌詞時,才讀該檔 tag 一次。
2. **嵌入式歌詞走與手動匯入完全相同的路徑**:讀到字串 → parser 偵測格式 →
   存 `LyricsEntity(source: embedded)`。入庫(而非每次即時解析)讓
   編輯(backlog 6)與覆蓋邏輯統一。優先序:已有任何歌詞(manual / online)
   就不讀 tag;embedded 可被手動匯入覆蓋(唯一索引 replace 天然成立)。
   讀過但**沒有**歌詞的曲目記個負快取(記憶體即可),避免每次開頁都重讀檔。
3. **封面不入庫**:`queryArtwork` 本身有 MediaStore 縮圖快取,UI 端用
   `QueryArtworkWidget`(或自製含記憶體快取的小 widget)即取即用。
4. **依賴順序**:封面 / 專輯部分(步驟 1–2)獨立、可先做;
   嵌入式歌詞部分(步驟 3–4)依賴 `lyrics-import-display.md` M1 的
   `LyricsEntity` + parser,排在 M1 之後。

## 步驟

1. **資料補齊**:`Track` 增 `album` / `albumId` / `data`(檔案路徑);
   `music_library.dart` 掃描時帶出;`MediaItem` 補 `album` 與 `artUri`
   (albumart content URI)→ 通知列出現封面。
2. **UI 封面**:mini player 與播放頁 `PlayerArtwork` 換成真封面
   (`queryArtwork` bytes,無封面 fallback 現有 icon);列表頁縮圖視覺密度
   實作時再定(可選)。
3. **嵌入式歌詞讀取**:加依賴 `audio_metadata_reader`;
   `lib/features/lyrics/embedded_lyrics_service.dart`(一檔一 provider):
   讀 `track.data` → `readMetadata(getImage: false)` → 取 `lyrics`。
   用 `Isolate.run` 包,避免大檔 I/O 卡 UI。
4. **整合**:歌詞視圖空狀態時先嘗試 embedded(找到 → parse → 入庫顯示;
   失敗或無 → 顯示手動匯入入口)。
5. **驗證**:`flutter analyze`、`flutter test`;實機:含 USLT 的 MP3、
   `©lyr` 的 M4A、無 tag 檔、`data` 路徑不可讀的曲目各走一輪。

## 邊界 / 風險

- `data` 路徑不可讀(雲端曲目、奇特 provider)→ 靜默 fallback 到匯入入口,
  不彈錯誤。
- `albumart` content URI 在個別 ROM 可能查無圖 → 通知列無封面屬可接受降級。
- USLT 多語言 frame(同檔多組歌詞)套件只回一組,接受。
- 歌詞編碼由 ID3 frame 自帶宣告(UTF-16 / UTF-8 / Latin-1),套件處理,
  不適用外部檔的 GBK / Big5 問題。
