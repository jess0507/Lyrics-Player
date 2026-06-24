# 播放清單 (Playlists)

讓使用者建立多個播放清單、把曲目加入清單、播放整個清單。預設內建一個
「我的最愛」清單(每裝置唯一、不可刪除 / 改名,永遠排在最前)。

## 設計重點

- **持久層用 Isar**(同統計 / 歌詞),純本機資料,v1 不同步 Firestore。
- 清單以**有序的 MediaStore trackId 清單**保存(裝置綁定,同統計 / 歌詞的
  已知限制);顯示時再回 music library 解析成 `Track`,來源檔被移除 / 尚未
  掃描到的曲目自動略過,保留原順序。
- 「我的最愛」用 `isFavorites` 旗標識別:DB 內存的 `name` 僅作 fallback,
  UI 一律以在地化字串(`l10n.playlist_favorites`)顯示,因此切語言會跟著變。
- 遵守專案慣例:一檔一 provider、sub-widget 各自成檔。

## 做了哪些步驟

### 資料層
1. `lib/features/playlists/playlist_entity.dart` — Isar `@collection`:
   `name` / `trackIds`(有序)/ `createdAt` / `isFavorites`(`@Index`)。
2. `lib/features/playlists/playlist_repository.dart` — `PlaylistRepository`
   + `playlistRepositoryProvider`。CRUD:`watchAll`(Isar stream)、
   `ensureDefaultFavorites`、`create` / `rename` / `delete`、
   `addTrack`(去重附加)/ `removeTrack`、`setTrackIds`(拖曳排序整批覆寫)。
3. `lib/features/playlists/playlists_provider.dart` — `playlistsProvider`
   (StreamProvider),排序:我的最愛固定最前,其餘依 `createdAt` 由舊到新。
4. `lib/features/playlists/playlist_tracks_provider.dart` —
   `playlistTracksProvider`(family by id),把 trackIds 解析成 `Track`,
   隨清單與音樂庫變動。
5. `lib/core/storage/isar_service.dart` — 註冊 `PlaylistEntitySchema`。
6. `lib/main.dart` — 啟動時 `PlaylistRepository(isar).ensureDefaultFavorites('我的最愛')`,
   確保預設清單存在(已存在則 no-op)。

### 播放
7. `lib/features/player/playback_controller.dart` — 新增
   `playTracksAt(tracks, index)` 以任意清單為佇列播放;並修正統計索引
   改對齊「目前播放的佇列 `_queue`」(原本永遠假設是整個音樂庫,播子集會錯)。

### UI / 導覽
8. `lib/features/playlists/playlist_display_name.dart` — 顯示名稱 helper
   (我的最愛回在地化字串)。
9. `lib/features/playlists/playlists_page.dart` — 清單列表:FAB 新增、
   每列顯示曲數、非我的最愛可重新命名 / 刪除、點擊進詳細頁。
10. `lib/features/playlists/playlist_detail_page.dart` — 清單內容:
    播放全部、逐首播放、移除曲目、`ReorderableListView` 拖曳排序。
11. `lib/features/playlists/widgets/playlist_name_dialog.dart` —
    建立 / 重新命名共用的命名對話框。
12. `lib/features/playlists/widgets/add_to_playlist_sheet.dart` —
    「加入播放清單」底部表單(含「新增播放清單」入口、已加入顯示打勾)。
13. `lib/features/music_list/music_list_page.dart` — 每首歌 trailing 加
    `playlist_add` 按鈕,開啟上述底部表單。
14. `lib/router/app_router.dart` — 新增 `/playlists` 分頁與
    `/playlists/:id` 詳細路由(第三個 `StatefulShellBranch`)。
15. `lib/shared/widgets/scaffold_with_nav.dart` — 底部導覽新增
    「播放清單」分頁(音樂 / 播放清單 / 我的)。

### i18n
16. 新增字串至模板 `app_en.arb` 與中文 `app_zh.arb` / `app_zh_TW.arb` /
    `app_zh_CN.arb`(`tab_playlists`、`playlist_favorites`、`playlist_new`、
    `playlist_rename`、`playlist_delete`(_confirm)、`playlist_add_to`、
    `playlist_added` / `playlist_already_added`、`playlist_remove_track`、
    `playlist_empty` / `playlists_empty`、`playlist_play_all`、
    `playlist_track_count` plural)。其餘語系暫 fallback 英文。

### 驗證
17. `flutter gen-l10n`、`dart run build_runner build --delete-conflicting-outputs`、
    `flutter analyze`(No issues found)。

## 待辦 / 後續

- 其餘 13 種語系尚未在地化(目前 fallback 英文)。
- v1 不同步 Firestore;若要跨機保留清單,需擴充 sync schema。
- 尚未提供「在播放器 / mini player 把目前曲目加入清單」的快捷入口。
