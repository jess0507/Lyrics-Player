import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/audio_player_service.dart';
import '../music_list/music_library.dart';
import '../music_list/track.dart';
import '../profile/statistics/statistics_service.dart';
import 'playback_session_repository.dart';

/// 串接音樂庫、音訊服務與統計：負責「從某首開始播放」與背景統計收集，
/// 並持久化播放佇列與進度，讓 App 重啟後可接續上次聽到的位置。
class PlaybackController {
  PlaybackController(this.ref) {
    _setupListeners();
    // 啟動時還原上次的播放佇列與進度（暫停狀態，待使用者按播放接續）。
    unawaited(_restoreLastSession());
  }

  final Ref ref;
  final List<StreamSubscription<dynamic>> _subs = [];
  Timer? _listenTimer;

  /// 目前送進播放器的佇列(可能是整個音樂庫,也可能是某個播放清單)。
  /// 統計以此對齊 currentIndex,而非永遠用音樂庫。
  List<Track> _queue = const [];

  /// 還原上次 session 時會以初始索引觸發一次 currentIndexStream，
  /// 該次並非真正開始播放，需抑制 recordPlay 以免灌水統計。
  bool _suppressRestoreRecord = false;

  AudioPlayerService get _audio => ref.read(audioPlayerServiceProvider);

  PlaybackSessionRepository get _sessionRepo =>
      ref.read(playbackSessionRepositoryProvider);

  /// 目前已掃描完成的曲目清單（掃描中／失敗時為空）。
  List<Track> get _tracks =>
      ref.read(musicLibraryProvider).valueOrNull ?? const [];

  void _setupListeners() {
    // 切換到某首（含初次載入）時記錄一次播放，並保存進度。
    _subs.add(_audio.currentIndexStream.listen((index) {
      if (index == null) return;
      final queue = _queue;
      if (index < 0 || index >= queue.length) return;

      _saveProgress();

      // 還原載入造成的初次索引事件不算一次新播放。
      if (_suppressRestoreRecord) {
        _suppressRestoreRecord = false;
        return;
      }
      ref.read(statisticsControllerProvider.notifier).recordPlay(queue[index]);
    }));

    // 播放狀態變動（如暫停）時保存當下進度，降低被系統終止時的遺失。
    _subs.add(_audio.playerStateStream.listen((_) => _saveProgress()));

    // 以 5 秒取樣累加實際聆聽時長（記在目前播放的曲目上），同時保存進度。
    _listenTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_audio.playing) return;
      final index = _audio.currentIndex;
      final queue = _queue;
      if (index == null || index < 0 || index >= queue.length) return;
      ref
          .read(statisticsControllerProvider.notifier)
          .addListenTime(queue[index], const Duration(seconds: 5));
      _saveProgress();
    });

    ref.onDispose(() {
      for (final s in _subs) {
        s.cancel();
      }
      _listenTimer?.cancel();
    });
  }

  /// 保存目前曲目與播放位置。
  void _saveProgress() {
    final index = _audio.currentIndex;
    if (index == null || index < 0 || index >= _queue.length) return;
    final positionMs = _audio.player.position.inMilliseconds;
    // 還原載入期間位置尚未定位（為 0）且非實際播放中，
    // 不可用 0 覆寫已保存的接續點。
    if (positionMs <= 0 && !_audio.playing) return;
    unawaited(_sessionRepo.save(_queue[index], positionMs));
  }

  /// 還原最近一次播放的曲目與進度，載入為暫停狀態（不自動播放）。
  Future<void> _restoreLastSession() async {
    final session = _sessionRepo.loadLast();
    if (session == null) return;
    try {
      _queue = [session.track];
      _suppressRestoreRecord = true;
      await _audio.setPlaylist(
        _queue,
        initialPosition: Duration(milliseconds: session.positionMs),
      );
    } catch (_) {
      // 曲目檔案可能已不存在或無法載入，移除該曲進度以免反覆失敗。
      _suppressRestoreRecord = false;
      _queue = const [];
      unawaited(_sessionRepo.remove(session.track.id));
    }
  }

  /// 回傳 [track] 上次聽到的位置；該曲無紀錄則從頭。
  Duration _resumePositionFor(Track track) {
    final ms = _sessionRepo.positionFor(track.id);
    return ms == null ? Duration.zero : Duration(milliseconds: ms);
  }

  /// 以整個音樂庫為播放清單，從 [index] 開始播放。
  Future<void> playLibraryAt(int index) async {
    final tracks = _tracks;
    if (index < 0 || index >= tracks.length) return;
    _queue = tracks;
    await _audio.setPlaylist(
      tracks,
      initialIndex: index,
      initialPosition: _resumePositionFor(tracks[index]),
    );
    await _audio.play();
  }

  Future<void> playTrack(Track track) async {
    final tracks = _tracks;
    final index = tracks.indexWhere((t) => t.id == track.id);
    if (index >= 0) await playLibraryAt(index);
  }

  /// 以指定曲目清單(如某個播放清單)為佇列,從 [index] 開始播放。
  Future<void> playTracksAt(List<Track> tracks, int index) async {
    if (index < 0 || index >= tracks.length) return;
    _queue = List.unmodifiable(tracks);
    await _audio.setPlaylist(
      tracks,
      initialIndex: index,
      initialPosition: _resumePositionFor(tracks[index]),
    );
    await _audio.play();
  }
}

final playbackControllerProvider = Provider<PlaybackController>(
  (ref) => PlaybackController(ref),
);
