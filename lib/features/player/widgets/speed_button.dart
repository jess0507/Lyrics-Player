import 'package:flutter/material.dart';

import '../../../core/audio/audio_player_service.dart';
import '../../../l10n/app_localizations.dart';

/// 播放速度按鈕：點擊開啟速度選擇對話框，非 1.0x 時顯示選取狀態。
class SpeedButton extends StatelessWidget {
  const SpeedButton({
    super.key,
    required this.audio,
    required this.enabled,
    this.iconSize,
    this.iconColor,
  });

  final AudioPlayerService audio;
  final bool enabled;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: audio.speedStream,
      builder: (context, snapshot) {
        final speed = snapshot.data ?? 1.0;
        return IconButton(
          iconSize: iconSize,
          color: iconColor,
          isSelected: speed != 1.0,
          tooltip: '${speed.toStringAsFixed(1)}x',
          onPressed: enabled
              ? () => _showSpeedDialog(context, audio, speed)
              : null,
          icon: const Icon(Icons.speed),
        );
      },
    );
  }
}

/// 速度選擇對話框：0.5x ~ 4.0x，間隔 0.1，調整時即時套用。
Future<void> _showSpeedDialog(
  BuildContext context,
  AudioPlayerService audio,
  double current,
) async {
  var value = current.clamp(0.5, 4.0);
  await showDialog<void>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.player_speed),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${value.toStringAsFixed(1)}x',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Slider(
                  min: 0.5,
                  max: 4.0,
                  divisions: 35,
                  value: value,
                  label: '${value.toStringAsFixed(1)}x',
                  onChanged: (v) {
                    final snapped = double.parse(v.toStringAsFixed(1));
                    setState(() => value = snapped);
                    audio.setSpeed(snapped);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  audio.setSpeed(1.0);
                  Navigator.of(context).pop();
                },
                child: Text(l10n.player_speed_reset),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.common_ok),
              ),
            ],
          );
        },
      );
    },
  );
}
