# 統計圖表(週/月/年視圖):預先聚合期間總量(period totals)+ 同步 v3

狀態:**已實作**(2026-06-13;實機驗證待辦,見文末實作備註)。
影響範圍:`lib/features/profile/statistics/`、`lib/core/sync/sync_service.dart`、`pubspec.yaml`(fl_chart)
相關:`plans/statistics-isar-firestore-sync.md`(現行資料層與同步 v2 的由來)

## 背景 / 問題

- 統計頁(`statistics_page.dart`)即將以 **fl_chart** 顯示聆聽時長折線圖。
- 現行設計「不存任何總和」:唯一儲存是 `DailyTrackStatEntity`(每日 × 每曲),
  總量、排行、`dailyTotals()` 全部在**讀取時**對整份 `days` 聚合導出。
- 圖表若直接 watch `statisticsControllerProvider` 聚合:
  1. `addListenTime` 每 5 秒 commit 一次 state → 圖表每 5 秒對**全量記錄**
     (天數 × 當日曲數,逐年成長)重跑聚合;
  2. 每個資料點都要再對期間子集掃一次,顯示成本隨資料量線性上升。
- 目標:**改為寫入時維護期間總量**,顯示圖表只讀少量已聚合資料點;
  且 totals **納入雲端同步**,換機還原後圖表資料直接到位。

## 圖表規格(已決策)

| 視圖 | 範圍 | 一點 = | 資料點數 | 讀取粒度 |
| --- | --- | --- | --- | --- |
| 週視圖 | 最近 7 天 | 一天總量 | 7 | day |
| 月視圖 | 最近 30 天 | 一天總量 | 30 | day |
| 年視圖 | 最近 12 個月 | **一月總量** | 12 | month |

- 年視圖若也用每日一點會太密集(365 點),故聚成每月一點(2026-06-13 決策)。
- **縱軸只用 `listenMs`**(聆聽時長);playCount 仍照常記錄(排行等既有功能用),
  只是不上圖。
- 範圍採 rolling window(最近 N 天/月),與「最近聽多少」的心智模型一致。
- 缺期間(沒聽歌的天/月)不產生條目,**由顯示層補零**(沿用 dailyTotals 慣例)。

## 結論(設計決策)

1. **新增 materialized 聚合 collection `PeriodStatEntity`**,與每曲明細並存:
   - 一個期間一筆:`kind`(**day / month 兩種粒度即足夠**——週視圖用 day,
     年視圖用 month,不需要 ISO 週 bucket)+ `period` key,
     複合唯一索引(replace),欄位 `playCount` / `listenMs`。
   - period key:day `yyyy-MM-dd`、month `yyyy-MM`(沿用既有
     `dayKey` / `monthKey`,字串排序即時間排序,可做範圍查詢)。
2. **寫入時同交易維護**:`recordPlay` / `addListenTime` 在**同一個
   `writeTxnSync`** 內,除 upsert 每曲明細外,一併 upsert 今天所屬的
   day / month 兩筆 totals(各 +playCount / +listenMs)。
   同交易保證明細與總量不會出現只寫一半的狀態。
3. **雲端只同步月粒度,欄位名 `monthlyTotals`(schema v3)**:
   上傳時與 `days` 明細同一份 `set()` 快照寫入(見下方文件結構)。
   - **day 粒度不上傳**:雲端的 day totals 可由 `days` 明細逐日加總直接導出,
     上傳是冗餘;day totals 只是本機的查詢 cache,還原時重建即可。
   - **month 粒度才需要備份**:它是**未來明細截斷的保護**——日後若 `days`
     文件逼近 1MB 要「保留最近 N 天 + 截斷」,歷史月總量已在
     `monthlyTotals` 內,年視圖與累計不會跟著少算(解決 v2 計畫中
     「總量會跟著少算,屆時再議」的遺留問題);截斷後它就**不再可由明細導出**,
     所以必須存。圖表的週/月視圖只看最近 30 天,截斷保留範圍 ≥ 30 天即不受影響。
   - 整份文件由單次 `set()` 覆寫產出,明細與 totals 必為同一快照,一致性不破。
4. **重算分兩層,已有 totals 就不重算**:
   - **原則**:totals 與明細同交易維護(本機)、month 粒度與明細同快照
     上傳(雲端),存在即一致——日常寫入增量維護,**不重算**;
     重算只服務「totals 缺漏」的補洞。
   - **定向重算 `recomputePeriods(dayKeys)`**:只重算受影響的期間——
     對每個 dayKey 以明細索引範圍查詢聚合出該 day bucket,
     再對其所屬月份聚合出 month bucket,upsert 覆寫。
     用於 prefs 舊版遷移(只寫遷移當日 → 只重算當日 + 當月兩筆)。
   - **全量重建 `rebuildPeriodTotals({skipMonths})`**:單趟掃明細、
     在記憶體按 day / month 分組加總後 putAll(O(明細筆數) 一次,
     不是逐期間查詢)。用於 totals 缺漏的一次性場合:
     - **還原到 v3 文件**:`monthlyTotals` 直接落地後,
       同一單趟只重建 day totals(`skipMonths`,月粒度以雲端為準——
       將來明細被截斷後,月總量本來就只有雲端是完整的);
     - **還原到 v2 雲端文件**(無 `monthlyTotals` 欄位):day / month 全重建;
     - **本機升級 backfill**:首次啟動偵測「明細非空且 totals 為空」,全重建。
       (此狀態僅出現在既有裝置從現行版本升級的第一次啟動——明細已累積、
       totals collection 剛新增還沒資料;日常寫入同交易必成對,全新安裝兩者皆空,
       故此條件之後不會再成立,偵測本身可常駐無副作用。)
5. **reset 一併清空**:`reset()` 同交易清兩個 collection;
   `uploadAfterReset` 照舊上傳歸零快照(v3 格式,totals 為空 map)。
6. **圖表資料走獨立 provider、只查 totals**:
   - 依 CLAUDE.md 一檔一 provider,新增 `chart_series_provider.dart` 之類,
     以視圖(週/月/年)為參數,從 Isar 對 `(kind, period)` 索引做範圍查詢,
     回傳依時間升冪的資料點。
   - 失效時機:watch `statisticsControllerProvider` 即可——每 5 秒 commit
     會觸發重查,但查詢只撈 7~30 筆已聚合資料點,成本可忽略。
7. **`StatisticsData` 不動**:總計卡片、排行、`onDay`/`inMonth`/`inYear`
   等既有導出維持現狀(排行本來就需要 per-track 明細,無法用 totals 取代)。

### 與「不存總和」原則的關係

原決策(見 statistics-isar-firestore-sync.md)的目的在於避免
「總計與明細對不上」。本任務的 totals 是**可隨時由明細全量重建的聚合**:
本機同交易維護、雲端與明細同一 `set()` 快照、缺漏時一律重建——
明細仍是事實來源,原則的意圖(單一來源、不雙寫出歧義)未被破壞。

### 替代方案(已否決)

- **記憶體內 cache(provider select / memoize)**:啟動與每次資料變更仍要
  全量聚合,只是把成本從「每次顯示」移到「每次寫入」且不持久化,
  資料逐年成長後啟動成本仍線性上升。否決。
- **totals 只留本機、還原時重建**(本計畫初版):換機可用但少了
  「明細截斷後歷史總量仍在」的退路;既然要動同步 schema 的機會成本低
  (v3 只是加欄位),一次補上。否決。

## 資料結構

### 本機(Isar)

```dart
@collection
class PeriodStatEntity {
  Id id = Isar.autoIncrement;

  /// 粒度:day / month。
  @Enumerated(EnumType.ordinal)
  @Index(unique: true, replace: true, composite: [CompositeIndex('period')])
  late PeriodKind kind;

  /// 期間 key:day `yyyy-MM-dd`、month `yyyy-MM`。
  late String period;

  int playCount = 0;
  int listenMs = 0;
}
```

### 雲端(Firestore,schema v3)

```
users/{uid}
  ├─ schemaVersion: 3
  ├─ settings:       { locale, themeMode, seedColor }      # 不變
  ├─ days:           { <yyyy-MM-dd>: { <trackId>: { title, playCount, listenMs } } }  # 不變
  ├─ monthlyTotals:  { <yyyy-MM>: { playCount, listenMs } }
  └─ updatedAt:      <server timestamp>                    # 不變
```

- 上傳照舊**整份 `set()` 覆寫**(last-write-wins、不 merge),
  `monthlyTotals` 與 `days` 來自同一本機快照(day 粒度不上傳,見決策 3)。
- 文件大小:一月一筆、無曲目維度,量級遠小於 `days` 本體,
  對 1MB 上限影響可忽略。
- **還原相容性**:v3 文件 → `days` 與 `monthlyTotals` 直接落地,
  day totals 由明細單趟重建;v2 文件(現已上線、無 `monthlyTotals`)→
  落地 `days` 後全量重建。上傳端一律寫 v3。
- 還原後 `lastSyncAt` / `lastModifiedAt` 規則照舊(還原不算本機變更)。

## 步驟

1. **schema**:新增 `period_stat_entity.dart`(@collection + 產生 `.g.dart`),
   `isar_service.dart` 註冊 schema。
2. **寫入端**:`recordPlay` / `addListenTime` 改為單一私有
   `_record(track, {playCount, listenMs})`,同交易 upsert 明細 +
   day / month 兩筆 totals;`_commit` 增量 state 邏輯不變(state 仍只持明細)。
3. **重算與 backfill**:實作 `recomputePeriods(dayKeys)`(定向)與
   `rebuildPeriodTotals()`(全量單趟);`_migrateFromPrefs` 接定向重算
   (只算遷移當日),`build()` 內 backfill 偵測(明細非空 && totals 空)
   接全量重建;`reset()` 清兩個 collection。
4. **同步 v3**:`sync_service.dart` 上傳加 `monthlyTotals`(月粒度 totals)、
   `schemaVersion` 升 3;還原依文件版本分流(v3 落地 monthlyTotals +
   重建 day totals / v2 全量重建),`restoreFromRemote` 介面擴充以一併寫入。
5. **圖表 provider**:新檔(一檔一 provider)提供週/月/年視圖 series 查詢,
   顯示層補零、依時間升冪,縱軸取 `listenMs`。
6. **UI**:`pubspec.yaml` 加 `fl_chart`;統計頁加折線圖
   (LineChart,週/月/年切換)。圖表 widget 依 CLAUDE.md 拆到
   `statistics/widgets/` 子目錄。新增 l10n key(圖表標題、週/月/年切換),
   照慣例 en + zh_TW + zh_CN;**待辦:補進 Google Sheet**。
7. **驗證**:`flutter analyze`、`flutter test`
   (寫入後 totals 與明細一致、rebuild 正確性、v2 文件還原走重建)、
   實機確認登入還原後圖表資料到位。

## 使用流程

### 1. 日常播放(寫入)

1. 曲目開始播放 → `recordPlay`;播放期間每 5 秒取樣 → `addListenTime`。
2. 同一個 `writeTxnSync` 內 upsert 三筆:
   每曲明細(今天, trackId)、day total(今天)、month total(本月)。
3. `_commit` 把明細增量套進 state → 圖表 provider 被觸發,
   重查 7~30 筆 totals,折線即時跟著長。

### 2. 開統計頁看圖表(讀取)

1. 進統計頁,預設週視圖:provider 以 day 粒度範圍查詢最近 7 天 totals。
2. 切月視圖 → 同粒度改查最近 30 天;切年視圖 → month 粒度查最近 12 個月。
3. 顯示層把缺的天/月補零後交給 fl_chart,縱軸 `listenMs`。
   全程不碰每曲明細、不做聚合運算。

### 3. 換機 / 重裝後登入(還原)

1. 登入成功 → SyncService 讀 `users/{uid}`。
2. v3 文件:`days` 與 `monthlyTotals` 直接落地本機,
   day totals 由明細單趟重建(月粒度以雲端為準,不重算)。
3. v2 文件(舊備份):落地 `days` 後全量重建 day / month totals。
4. 之後首次上傳即以 v3 格式覆寫雲端。

### 4. 既有裝置升級(backfill)

1. 更新 App 後首次啟動,`build()` 偵測「明細非空且 totals 空」。
2. `rebuildPeriodTotals()` 由本機明細一次重算,之後走日常寫入流程。
3. 下次同步班次照常把 v3 快照(含 `monthlyTotals`)上傳。

### 5. 重設統計

1. 統計頁點重設 → 確認 dialog(登入版警告雲端一併刪除)。
2. 確認後同交易清空明細與 totals 兩個 collection,圖表歸零。
3. 已登入時立即上傳歸零快照(v3,`days` 與 `monthlyTotals` 皆空 map)覆寫雲端。

## 實作備註(2026-06-13)

- 依計畫實作,無設計偏離。補充細節:
  - 補零在 `chart_series_provider.dart` 內完成(provider 即圖表的
    view-model,回傳固定長度、已補零、升冪的 series,widget 不再處理 key 邏輯)。
  - v3 文件若 `monthlyTotals` 欄位缺漏或格式不符,還原時降級走 v2 路徑
    (day / month 全由明細重建),不會留下空的月總量。
  - backfill 偵測在 `build()` 內、`_migrateFromPrefs` 之前執行
    (順序相反時遷移的定向重算會讓 totals 非空,backfill 永不觸發)。
  - fl_chart 取 `^0.69.2`;圖表 widget 在 `statistics/widgets/listen_time_chart.dart`,
    縱軸以分鐘為單位、滿一小時改顯示小時。
- 測試:`test/period_totals_test.dart` 以真 Isar 跑 controller
  (測試 binding 擋 HttpClient,故 setUpAll 改用 curl 預抓 IsarCore dylib
  到 `.dart_tool/isar_test/`,僅 macOS;此 pattern 可供後續 Isar 相關測試沿用)。
## 設計修訂(2026-06-14):`PeriodStatEntity` 改為只存月粒度

- **動機**:day 粒度的 totals 與 `DailyTrackStatEntity`(每日 × 每曲)重複——
  day 數據就是明細本身,再存一份 day total 是冗餘。原本「圖表全程不碰明細」的
  考量在 7/30 天視窗下成本可忽略(一次索引範圍查詢 + 記憶體加總),不值得多維護一份 cache。
- **變更**:
  - `PeriodStatEntity` 移除 `PeriodKind` enum 與 `kind` 欄位,`period` 直接是月 key
    `yyyy-MM`,唯一索引改為單欄 `period`(getter 變 `getByPeriodSync` /
    `getAllByPeriodSync`)。
  - 寫入端 `_record` 只 upsert 明細 + 本月 month total(`_bumpMonthSync`);
    `recomputePeriods` 只重算受影響日所屬月份;移除 day totals 的聚合/落地。
  - `restoreFromRemote`:v3 直接落地雲端 `monthlyTotals`;v2(`monthlyTotals` 為
    null)由明細單趟重建月總量(`_aggregateMonthTotals`)。day 數據隨明細落地,
    兩種情形都不需重建。
  - 週/月視圖改在 `chart_series_provider` 內對明細 `day` 索引做範圍查詢後按日加總;
    年視圖維持點查 `PeriodStatEntity` 月總量。
  - 移除已不存在於 service 的 `rebuildPeriodTotals` / `build()` backfill 對應測試。
- 上方「day 粒度」相關敘述(決策 1~3、圖表規格的 day 讀取粒度、資料結構的 `kind`
  欄位)以本節為準。

- 待辦:
  - 實機確認登入還原後圖表資料到位(計畫步驟 7 的最後一項)。
  - 新增的 4 個 l10n key(`statistics_chart_*`)補進 Google Sheet,
    其餘語系現以英文 fallback。
