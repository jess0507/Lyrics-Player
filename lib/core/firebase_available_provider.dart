import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 標記 Firebase 是否成功初始化（無設定 / 無網路時為 false）。
///
/// 於 main() 以 overrideWithValue 注入實際結果。
final firebaseAvailableProvider = Provider<bool>((ref) => false);
