---
name: isar-codegen-null-aware-element
description: build_runner/isar_generator 因舊 analyzer 無法解析 null-aware element 語法,重新 codegen 的解法
metadata:
  type: project
---

`dart run build_runner build`(isar_generator)會對整個 package 報語法錯誤:
`secondary_controls.dart` 等檔用了 Dart 新版 **null-aware element** 語法(集合字面量內的 `?expr,`,如 `?autoSync,`),但 isar 3.1.0 綁的 **analyzer 5.13.0** 不支援 → `Expected an identifier`,導致所有 `.g.dart` 都無法重新產生(`flutter analyze` 與 runtime 則正常,因為用 SDK 內建 analyzer)。

**重新 codegen 的解法**:暫時把那幾行 `?x,` 改成等價的 collection-if `if (x != null) x,`,執行 `dart run build_runner clean && dart run build_runner build --delete-conflicting-outputs`,完成後再還原 `?x,`。重產不會動到其他 `.g.dart`(內容一致)。

升級 isar / analyzer 可根治,但 isar 3.1.0 已停止維護。相關:[[impl-decisions]]
