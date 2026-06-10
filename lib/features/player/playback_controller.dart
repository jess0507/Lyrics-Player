import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/audio_player_service.dart';
import '../music_list/music_library.dart';
import '../music_list/track.dart';
import '../profile/statistics/statistics_service.dart';

/// 串接音樂庫、音訊服務與統計：負責「從某首開始播放」與背景統計收集。
class PlaybackController {
  PlaybackController(this.ref) {
    _setupListeners();
  }

  final Ref ref;
  final List<StreamSubscription<dynamic>> _subs = [];
  Timer? _listenTimer;

  AudioPlayerService get _audio => ref.read(audioPlayerServiceProvider);

  /// 目前已掃描完成的曲目清單（掃描中／失敗時為空）。
  List<Track> get _tracks =>
      ref.read(musicLibraryProvider).valueOrNull ?? const [];

  void _setupListeners() {
    // 切換到某首（含初次載入）時記錄一次播放。
    _subs.add(_audio.currentIndexStream.listen((index) {
      if (index == null) return;
      final tracks = _tracks;
      if (index >= 0 && index < tracks.length) {
        ref.read(statisticsControllerProvider.notifier).recordPlay(
              tracks[index],
            );
      }
    }));

    // 以 5 秒取樣累加實際聆聽時長。
    _listenTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_audio.playing) {
        ref
            .read(statisticsControllerProvider.notifier)
            .addListenTime(const Duration(seconds: 5));
      }
    });

    ref.onDispose(() {
      for (final s in _subs) {
        s.cancel();
      }
      _listenTimer?.cancel();
    });
  }

  /// 以整個音樂庫為播放清單，從 [index] 開始播放。
  Future<void> playLibraryAt(int index) async {
    final tracks = _tracks;
    if (index < 0 || index >= tracks.length) return;
    await _audio.setPlaylist(tracks, initialIndex: index);
    await _audio.play();
  }

  Future<void> playTrack(Track track) async {
    final tracks = _tracks;
    final index = tracks.indexWhere((t) => t.id == track.id);
    if (index >= 0) await playLibraryAt(index);
  }
}

final playbackControllerProvider = Provider<PlaybackController>(
  (ref) => PlaybackController(ref),
);
