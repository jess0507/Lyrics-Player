import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_state_provider.dart';
import '../../../core/firebase_available_provider.dart';
import '../../../core/sync/sync_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/format.dart';
import 'statistics_service.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  /// 重設前先跳確認 dialog（已登入時警告雲端備份也會刪除），
  /// 確認後清空本機並立即上傳歸零快照覆寫雲端。
  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final signedIn = ref.read(firebaseAvailableProvider) &&
        ref.read(authStateProvider).valueOrNull != null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.statistics_reset_title),
        content: Text(
          signedIn
              ? l10n.statistics_reset_message_cloud
              : l10n.statistics_reset_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.statistics_reset_confirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    ref.read(statisticsControllerProvider.notifier).reset();
    // 背景覆寫雲端備份為歸零快照；失敗等下次同步達成最終一致。
    unawaited(ref.read(syncServiceProvider).uploadAfterReset());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stats = ref.watch(statisticsControllerProvider);
    final top = stats.topTracks();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile_statistics),
        actions: [
          if (stats.totalPlayCount > 0)
            IconButton(
              tooltip: l10n.statistics_reset,
              onPressed: () => _confirmReset(context, ref),
              icon: const Icon(Icons.restart_alt),
            ),
        ],
      ),
      body: stats.totalPlayCount == 0
          ? Center(child: Text(l10n.statistics_empty))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.timer_outlined,
                        label: l10n.statistics_total_time,
                        value: formatDuration(stats.totalListenTime),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.play_arrow_outlined,
                        label: l10n.statistics_play_count,
                        value: '${stats.totalPlayCount}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.statistics_top_tracks,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (var i = 0; i < top.length; i++)
                  ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(
                      top[i].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(formatDuration(top[i].listenTime)),
                    trailing: Text('×${top[i].playCount}'),
                  ),
              ],
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.primary),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: scheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
