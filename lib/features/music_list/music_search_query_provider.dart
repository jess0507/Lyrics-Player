import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 音樂列表搜尋字串。
final musicSearchQueryProvider = StateProvider<String>((ref) => '');
