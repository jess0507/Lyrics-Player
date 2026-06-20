import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/settings_controller.dart';
import '../../lyrics/lyrics_repository.dart';
import '../../lyrics/track_lyrics_provider.dart';
import 'lyrics_auto_sync_action.dart';
import 'lyrics_font_size_sheet.dart';
import 'lyrics_view.dart';
import 'speed_button.dart';

/// 預設播放速度,用來判斷是否顯示選取狀態。
const double _kDefaultSpeed = 1.0;

enum _LyricsMenuAction {
  hideLyrics,
  shuffle,
  loop,
  speed,
  fontSize,
  autoSync,
  reimport,
  delete,
}

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

    return PopupMenuButton<_LyricsMenuAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => switch (action) {
        _LyricsMenuAction.hideLyrics => _hideLyrics(ref),
        _LyricsMenuAction.shuffle => _toggleShuffle(),
        _LyricsMenuAction.loop => _cycleLoop(),
        _LyricsMenuAction.speed => showSpeedSheet(context, audio),
        _LyricsMenuAction.fontSize => showLyricsFontSizeSheet(context),
        _LyricsMenuAction.autoSync => runLyricsAutoSync(
          context,
          ref,
          trackId: trackId,
          title: title,
        ),
        _LyricsMenuAction.reimport => runLyricsImport(
          context,
          ref,
          trackId: trackId,
          title: title,
        ),
        _LyricsMenuAction.delete => _confirmDelete(context, ref, l10n),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _LyricsMenuAction.hideLyrics,
          child: _MenuRow(icon: Icons.image_outlined, label: l10n.lyrics_hide),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _LyricsMenuAction.shuffle,
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
          value: _LyricsMenuAction.loop,
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
          value: _LyricsMenuAction.speed,
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
        if (hasLyrics) ...[
          const PopupMenuDivider(),
          if (canAutoSync)
            PopupMenuItem(
              value: _LyricsMenuAction.autoSync,
              child: _MenuRow(
                icon: Icons.auto_fix_high,
                label: l10n.lyrics_auto_sync,
              ),
            ),
          PopupMenuItem(
            value: _LyricsMenuAction.fontSize,
            child: _MenuRow(
              icon: Icons.text_fields,
              label: l10n.lyrics_font_size,
            ),
          ),
          PopupMenuItem(
            value: _LyricsMenuAction.reimport,
            child: _MenuRow(
              icon: Icons.file_open_outlined,
              label: l10n.lyrics_reimport,
            ),
          ),
          PopupMenuItem(
            value: _LyricsMenuAction.delete,
            child: _MenuRow(
              icon: Icons.delete_outline,
              label: l10n.lyrics_delete,
            ),
          ),
        ],
      ],
    );
  }

  /// 手動關閉歌詞:同時關閉「自動滿版歌詞」設定,
  /// 避免切歌後又自動跳回滿版。
  void _hideLyrics(WidgetRef ref) {
    ref.read(settingsControllerProvider.notifier).setAutoFullScreenLyrics(false);
    onHideLyrics();
  }

  void _toggleShuffle() =>
      audio.setShuffle(!audio.player.shuffleModeEnabled);

  void _cycleLoop() {
    final next = switch (audio.player.loopMode) {
      LoopMode.off => LoopMode.all,
      LoopMode.all => LoopMode.one,
      LoopMode.one => LoopMode.off,
    };
    audio.setLoopMode(next);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.lyrics_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(lyricsRepositoryProvider).deleteByTrackId(trackId);
    ref.invalidate(trackLyricsProvider(trackId));
    // 刪除歌詞後自動退回封面。
    onHideLyrics();
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
