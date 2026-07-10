import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

/// ShorebirdUpdater 實例。
///
/// 建構子會同步做一次 FFI 呼叫(讀本機 patch 編號),因此不在 main() 建立,
/// 由 [patchUpdateControllerProvider] 於第一幀之後首次讀取時才初始化。
final shorebirdUpdaterProvider = Provider<ShorebirdUpdater>((ref) {
  return ShorebirdUpdater();
});
