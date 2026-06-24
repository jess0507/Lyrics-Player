import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/settings_controller.dart';
import '../../lyrics/providers/track_lyrics_provider.dart';
import 'lyrics_menu_action.dart';
import 'speed_button.dart';

/// 預設播放速度,用來判斷是否顯示選取狀態。
const double _kDefaultSpeed = 1.0;

/// 歌詞滿版模式專有的選單動作(隨機、循環、播放速度與「顯示封面」)。
/// 歌詞相關動作另以共用的 [LyricsMenuAction] 表示。
enum _LyricsModeAction { hideLyrics, shuffle, loop, speed }

/// 歌詞滿版模式下的 AppBar 選單:整合「顯示封面(關閉歌詞)」、次控制列功能
/// (隨機、循環、播放速度),以及歌詞操作(字體大小、重新匯入、刪除)。
/// 字體大小 / 重新匯入 / 刪除僅在已有歌詞時出現。
class LyricsModeMenu extends ConsumerWidget {
  const LyricsModeMenu({
    super.key,
    required this.audio,
    required this.trackId,
    required this.title,
    required this.onHideLyrics,
  });

  final AudioPlayerService audio;
  final String trackId;
  final String title;
  final VoidCallback onHideLyrics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lyrics = ref.watch(trackLyricsProvider(trackId)).valueOrNull;
    final hasLyrics = lyrics != null && lyrics.isNotEmpty;
    // 對時是「補時間」:只在已有純文字、尚未同步時提供。
    final canAutoSync = hasLyrics && !lyrics.synced;
    final lyricsActions = lyricsMenuActions(
      canAutoSync: canAutoSync,
      hasLyrics: hasLyrics,
    );

    return PopupMenuButton<Object>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _onSelected(context, ref, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _LyricsModeAction.hideLyrics,
          child: _MenuRow(icon: Icons.image_outlined, label: l10n.lyrics_hide),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _LyricsModeAction.shuffle,
          child: StreamBuilder<bool>(
            stream: audio.shuffleModeEnabledStream,
            builder: (context, snapshot) => _MenuRow(
              icon: Icons.shuffle,
              label: l10n.player_shuffle,
              selected: snapshot.data ?? false,
            ),
          ),
        ),
        PopupMenuItem(
          value: _LyricsModeAction.loop,
          child: StreamBuilder<LoopMode>(
            stream: audio.loopModeStream,
            builder: (context, snapshot) {
              final mode = snapshot.data ?? LoopMode.off;
              return _MenuRow(
                icon: mode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                label: l10n.player_loop,
                selected: mode != LoopMode.off,
              );
            },
          ),
        ),
        PopupMenuItem(
          value: _LyricsModeAction.speed,
          child: StreamBuilder<double>(
            stream: audio.speedStream,
            builder: (context, snapshot) {
              final speed = snapshot.data ?? _kDefaultSpeed;
              return _MenuRow(
                icon: Icons.speed,
                label: l10n.player_speed,
                trailing: '${speed.toStringAsFixed(1)}x',
                selected: speed != _kDefaultSpeed,
              );
            },
          ),
        ),
        if (lyricsActions.isNotEmpty) ...[
          const PopupMenuDivider(),
          for (final action in lyricsActions)
            PopupMenuItem(
              value: action,
              child: _MenuRow(icon: action.icon, label: action.label(l10n)),
            ),
        ],
      ],
    );
  }

  void _onSelected(BuildContext context, WidgetRef ref, Object value) {
    if (value is LyricsMenuAction) {
      runLyricsMenuAction(
        context,
        ref,
        value,
        trackId: trackId,
        title: title,
        // 刪除歌詞後自動退回封面。
        onDeleted: onHideLyrics,
      );
      return;
    }
    switch (value as _LyricsModeAction) {
      case _LyricsModeAction.hideLyrics:
        _hideLyrics(ref);
      case _LyricsModeAction.shuffle:
        _toggleShuffle();
      case _LyricsModeAction.loop:
        _cycleLoop();
      case _LyricsModeAction.speed:
        showSpeedSheet(context, audio);
    }
  }

  /// 手動關閉歌詞:同時關閉「自動滿版歌詞」設定,
  /// 避免切歌後又自動跳回滿版。
  void _hideLyrics(WidgetRef ref) {
    ref.read(settingsControllerProvider.notifier).setAutoFullScreenLyrics(false);
    onHideLyrics();
  }

  void _toggleShuffle() => audio.setShuffle(!audio.player.shuffleModeEnabled);

  void _cycleLoop() {
    final next = switch (audio.player.loopMode) {
      LoopMode.off => LoopMode.all,
      LoopMode.all => LoopMode.one,
      LoopMode.one => LoopMode.off,
    };
    audio.setLoopMode(next);
  }
}

/// 選單列:圖示 + 文字,選取時上色,可選右側狀態文字(如速度倍率)。
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.selected = false,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : null;
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(color: color))),
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              trailing!,
              style: TextStyle(color: color ?? scheme.outline),
            ),
          ),
      ],
    );
  }
}
