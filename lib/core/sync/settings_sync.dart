import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/settings_controller.dart';

/// 設定與主文件 `settings` 欄位的編解碼與還原（SyncService 調度）。
class SettingsSync {
  SettingsSync(this._ref);

  final Ref _ref;

  /// 主文件 `settings` 欄位內容。
  Map<String, dynamic> encode() =>
      _ref.read(settingsControllerProvider).toRemoteMap();

  /// 還原雲端 `settings` 欄位；格式不符時不動本機。
  void restore(Object? raw) {
    if (raw is! Map) return;
    _ref
        .read(settingsControllerProvider.notifier)
        .restoreFromRemote(
          locale: raw['locale'] as String?,
          themeMode: raw['themeMode'] as String?,
          seedColor: raw['seedColor'] as String?,
          useGradient: raw['useGradient'] as bool?,
          gradientFromCover: raw['gradientFromCover'] as bool?,
          autoFullScreenLyrics: raw['autoFullScreenLyrics'] as bool?,
        );
  }
}

final settingsSyncProvider = Provider<SettingsSync>(
  (ref) => SettingsSync(ref),
);
