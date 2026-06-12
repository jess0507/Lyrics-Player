import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/statistics/statistics_service.dart';
import '../../features/profile/statistics/track_stat_entity.dart';
import '../../shared/providers/settings_controller.dart';
import '../auth/auth_service.dart';
import '../firebase_available_provider.dart';
import 'sync_state_store.dart';

/// 使用者資料（設定 + 統計）與 Firestore `users/{uid}` 的同步。
///
/// 上傳為主（背景備份，節流一天）、登入時還原；全程不阻塞 UI、
/// 失敗靜默略過不重試，下次啟動自然再試。詳細策略見
/// `tasks/statistics-isar-firestore-sync.md`。
class SyncService {
  SyncService(this.ref) {
    _init();
  }

  final Ref ref;

  /// Firestore 文件結構版本，欄位結構變動時遞增；還原端據此判斷相容性。
  static const _schemaVersion = 1;

  /// 上傳節流：距上次成功上傳超過此間隔才再上傳（登入當下的觸發不受限）。
  static const _minUploadInterval = Duration(days: 1);

  SyncStateStore get _store => ref.read(syncStateStoreProvider);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  void _init() {
    if (!ref.read(firebaseAvailableProvider)) return;
    // 首個事件是啟動時的既有登入狀態（App 啟動觸發、節流一天）；
    // 其後的 null -> user 轉變才是「登入成功當下」（先還原判斷、上傳不節流）。
    var isStartupEvent = true;
    final sub =
        ref.read(authServiceProvider).authStateChanges().listen((user) {
      final isStartup = isStartupEvent;
      isStartupEvent = false;
      if (user == null) return; // 未登入 / 登出：不同步，本機資料照常累計。
      if (isStartup) {
        unawaited(_maybeUpload(user.uid, throttled: true));
      } else {
        unawaited(_onSignedIn(user.uid));
      }
    });
    ref.onDispose(sub.cancel);
  }

  /// 登入成功當下：先判斷還原，不還原才走上傳判斷（互斥）。
  Future<void> _onSignedIn(String uid) async {
    try {
      if (await _maybeRestore(uid)) return;
    } catch (e) {
      debugPrint('[Sync] 還原失敗，略過：$e');
    }
    await _maybeUpload(uid, throttled: false);
  }

  /// 只在本機沒有有意義的資料（per-track 記錄為空且從未同步）時還原，
  /// 完全避免雙向合併。回傳是否已執行還原。
  Future<bool> _maybeRestore(String uid) async {
    final stats = ref.read(statisticsControllerProvider);
    if (stats.tracks.isNotEmpty || _store.lastSyncAt != null) return false;

    final snapshot = await _userDoc(uid).get();
    final data = snapshot.data();
    if (data == null) return false; // 雲端沒有文件（首次使用）→ 走上傳判斷。
    final version = (data['schemaVersion'] as num?)?.toInt() ?? 1;
    if (version > _schemaVersion) {
      debugPrint('[Sync] 雲端 schemaVersion $version 較新，跳過還原');
      return false;
    }

    final settings = data['settings'];
    if (settings is Map) {
      ref.read(settingsControllerProvider.notifier).restoreFromRemote(
            locale: settings['locale'] as String?,
            themeMode: settings['themeMode'] as String?,
            seedColor: settings['seedColor'] as String?,
          );
    }
    ref
        .read(statisticsControllerProvider.notifier)
        .restoreFromRemote(_decodeTracks(data['tracks']));

    // 還原後視同已同步；lastModifiedAt 不動（還原不算本機變更）。
    _store.markSynced();
    debugPrint('[Sync] 已從雲端還原設定與統計');
    return true;
  }

  /// 上傳條件（全部成立才上傳）：自上次同步後有變更；
  /// [throttled] 時另要求距上次成功上傳超過一天。
  Future<void> _maybeUpload(String uid, {required bool throttled}) async {
    // 先讀統計 provider，確保 prefs -> Isar 遷移已執行
    // （遷移視為本機變更，會更新 lastModifiedAt）。
    final stats = ref.read(statisticsControllerProvider);
    final lastModified = _store.lastModifiedAt;
    if (lastModified == null) return;
    final lastSync = _store.lastSyncAt;
    if (lastSync != null) {
      if (!lastModified.isAfter(lastSync)) return;
      if (throttled &&
          DateTime.now().difference(lastSync) <= _minUploadInterval) {
        return;
      }
    }
    await _upload(uid, stats);
  }

  /// 統計重設後呼叫：立即上傳歸零快照（tracks 清空、settings 維持現值），
  /// 不等下次同步班次。未登入 / Firebase 不可用時為 no-op。
  Future<void> uploadAfterReset() async {
    if (!ref.read(firebaseAvailableProvider)) return;
    final uid = ref.read(authServiceProvider).currentUser?.uid;
    if (uid == null) return;
    await _upload(uid, ref.read(statisticsControllerProvider));
  }

  /// `set()` 整份覆寫（不帶 merge）：雲端永遠是單一裝置的完整快照
  /// （last-write-wins，不合併、不加總）。
  Future<void> _upload(String uid, StatisticsData stats) async {
    try {
      await _userDoc(uid).set({
        'schemaVersion': _schemaVersion,
        'settings': ref.read(settingsControllerProvider).toRemoteMap(),
        'tracks': {
          for (final t in stats.tracks)
            t.trackId: {
              'title': t.title,
              'playCount': t.playCount,
              'listenMs': t.listenMs,
            },
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _store.markSynced();
      debugPrint('[Sync] 已上傳統計與設定（${stats.tracks.length} 首）');
    } catch (e) {
      // 離線、權限、逾時等：靜默略過，lastSyncAt 不動，下次啟動自然再試。
      debugPrint('[Sync] 上傳失敗，略過：$e');
    }
  }

  /// 解析雲端 tracks map，容錯：缺欄位給預設值、格式不符的條目跳過。
  List<TrackStatEntity> _decodeTracks(Object? raw) {
    if (raw is! Map) return const [];
    final entities = <TrackStatEntity>[];
    raw.forEach((key, value) {
      if (value is! Map) return;
      entities.add(TrackStatEntity()
        ..trackId = '$key'
        ..title = (value['title'] as String?) ?? '$key'
        ..playCount = (value['playCount'] as num? ?? 0).toInt()
        ..listenMs = (value['listenMs'] as num? ?? 0).toInt());
    });
    return entities;
  }
}

/// 於 App 根 widget watch 一次以啟動同步（建立後自行監聽登入狀態）。
final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService(ref),
);
