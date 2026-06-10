import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions/permission_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format.dart';
import '../player/playback_controller.dart';
import 'music_library.dart';
import 'track.dart';

class MusicListPage extends ConsumerStatefulWidget {
  const MusicListPage({super.key});

  @override
  ConsumerState<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends ConsumerState<MusicListPage> {
  bool _scanning = false;

  /// 確保權限後重新掃描裝置音樂庫。
  Future<void> _rescan() async {
    final granted = await permissionService.ensureAudioPermission(context);
    if (!granted || !mounted) return;

    setState(() => _scanning = true);
    try {
      await ref.read(musicLibraryProvider.notifier).refresh();
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _play(Track track) async {
    // 點擊播放後只在底部顯示 mini player，不自動展開全螢幕 PlayerPage。
    await ref.read(playbackControllerProvider).playTrack(track);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final libraryAsync = ref.watch(musicLibraryProvider);
    final tracks = ref.watch(filteredTracksProvider);
    final hasLibrary = libraryAsync.valueOrNull?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tab_music_list),
        actions: [
          IconButton(
            tooltip: l10n.music_rescan,
            onPressed: _scanning ? null : _rescan,
            icon: _scanning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
        bottom: hasLibrary
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SearchBar(
                    leading: const Icon(Icons.search),
                    hintText: l10n.music_search,
                    onChanged: (value) => ref
                        .read(musicSearchQueryProvider.notifier)
                        .state = value,
                  ),
                ),
              )
            : null,
      ),
      body: _buildBody(l10n, libraryAsync, tracks),
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    AsyncValue<List<Track>> libraryAsync,
    List<Track> tracks,
  ) {
    // 首次掃描中（尚無資料）顯示進度。
    if (libraryAsync.isLoading && !(libraryAsync.valueOrNull?.isNotEmpty ?? false)) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tracks.isEmpty) {
      return _EmptyState(
        message: l10n.music_empty,
        actionLabel: l10n.music_rescan,
        onAction: _scanning ? null : _rescan,
      );
    }
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.music_note)),
          title: Text(
            track.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle:
              track.artist == null ? null : Text(track.artist!, maxLines: 1),
          trailing: track.duration == null
              ? null
              : Text(formatDuration(track.duration!)),
          onTap: () => _play(track),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_music_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
