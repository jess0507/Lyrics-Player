import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  bool _importing = false;

  Future<void> _import() async {
    final granted = await permissionService.ensureAudioPermission(context);
    if (!granted || !mounted) return;

    setState(() => _importing = true);
    try {
      final count = await ref.read(musicLibraryProvider.notifier).importFiles();
      if (!mounted) return;
      if (count > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('+$count')),
        );
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _play(Track track) async {
    await ref.read(playbackControllerProvider).playTrack(track);
    if (mounted) context.go('/player');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tracks = ref.watch(filteredTracksProvider);
    final hasLibrary = ref.watch(musicLibraryProvider).isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tab_music_list),
        actions: [
          IconButton(
            tooltip: l10n.music_import,
            onPressed: _importing ? null : _import,
            icon: _importing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
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
      body: tracks.isEmpty
          ? _EmptyState(message: l10n.music_empty)
          : ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return Dismissible(
                  key: ValueKey(track.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Theme.of(context).colorScheme.errorContainer,
                    padding: const EdgeInsetsDirectional.only(end: 20),
                    child: const Icon(Icons.delete_outline),
                  ),
                  onDismissed: (_) =>
                      ref.read(musicLibraryProvider.notifier).remove(track.id),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.music_note)),
                    title: Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: track.artist == null
                        ? null
                        : Text(track.artist!, maxLines: 1),
                    trailing: track.duration == null
                        ? null
                        : Text(formatDuration(track.duration!)),
                    onTap: () => _play(track),
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

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
          ],
        ),
      ),
    );
  }
}
