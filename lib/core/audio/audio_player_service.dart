import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../../features/music_list/track.dart';

/// 進度條所需的合併資料。
class PositionData {
  const PositionData(this.position, this.buffered, this.duration);

  final Duration position;
  final Duration buffered;
  final Duration duration;
}

/// 封裝 just_audio 的 [AudioPlayer]，提供本機播放清單、背景播放與通知列控制。
class AudioPlayerService {
  AudioPlayerService() {
    _player.setLoopMode(LoopMode.off);
  }

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<bool> get shuffleModeEnabledStream =>
      _player.shuffleModeEnabledStream;
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;
  bool get playing => _player.playing;

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (pos, buf, dur) => PositionData(pos, buf, dur ?? Duration.zero),
      );

  /// 以整個音樂庫建立播放清單，並從 [initialIndex] 開始播放。
  Future<void> setPlaylist(
    List<Track> tracks, {
    int initialIndex = 0,
  }) async {
    if (tracks.isEmpty) return;
    final source = ConcatenatingAudioSource(
      children: [
        for (final t in tracks)
          AudioSource.uri(
            Uri.parse(t.uri),
            tag: MediaItem(
              id: t.id,
              title: t.title,
              artist: t.artist ?? '',
            ),
          ),
      ],
    );
    await _player.setAudioSource(source, initialIndex: initialIndex);
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> seekToNext() => _player.seekToNext();
  Future<void> seekToPrevious() => _player.seekToPrevious();
  Future<void> setLoopMode(LoopMode mode) => _player.setLoopMode(mode);
  Future<void> setShuffle(bool enabled) =>
      _player.setShuffleModeEnabled(enabled);

  void dispose() => _player.dispose();
}

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});
