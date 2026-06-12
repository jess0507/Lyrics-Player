import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/preferences_service.dart';

/// 雲端同步的本機狀態：上次成功上傳時間與本機資料最後變更時間。
///
/// 統計與設定的寫入端呼叫 [markModified]；同步端以
/// 「lastModifiedAt > lastSyncAt」判斷是否有變更需要上傳。
class SyncStateStore {
  SyncStateStore(this._prefs);

  static const _kLastSyncAt = 'sync.lastSyncAt';
  static const _kLastModifiedAt = 'sync.lastModifiedAt';

  final PreferencesService _prefs;

  /// 上次成功上傳的時間；null 表示從未同步。
  DateTime? get lastSyncAt => _read(_kLastSyncAt);

  /// 統計或設定最後一次本機變更的時間；null 表示從未變更。
  DateTime? get lastModifiedAt => _read(_kLastModifiedAt);

  /// 統計或設定每次寫入時呼叫。
  void markModified() => _write(_kLastModifiedAt, DateTime.now());

  /// 上傳成功（或還原完成）時呼叫，更新 lastSyncAt。
  void markSynced() => _write(_kLastSyncAt, DateTime.now());

  DateTime? _read(String key) {
    final ms = _prefs.getInt(key);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  void _write(String key, DateTime value) =>
      _prefs.setInt(key, value.millisecondsSinceEpoch);
}

final syncStateStoreProvider = Provider<SyncStateStore>(
  (ref) => SyncStateStore(ref.watch(preferencesServiceProvider)),
);
