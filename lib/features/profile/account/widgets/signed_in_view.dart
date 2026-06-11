import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../l10n/app_localizations.dart';

/// 已登入:顯示頭像、Email、登出與刪除帳號。
class SignedInView extends ConsumerWidget {
  const SignedInView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.read(authServiceProvider);
    final photo = user.photoURL;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundImage: photo != null ? NetworkImage(photo) : null,
            child: photo == null ? const Icon(Icons.person, size: 48) : null,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            user.displayName ?? user.email ?? l10n.account_guest,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (user.email != null) ...[
          const SizedBox(height: 4),
          Center(child: Text(user.email!)),
        ],
        const SizedBox(height: 32),
        FilledButton.tonalIcon(
          onPressed: () => auth.signOut(),
          icon: const Icon(Icons.logout),
          label: Text(l10n.account_sign_out),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => _confirmDelete(context, auth),
          icon: const Icon(Icons.delete_outline),
          label: Text(l10n.account_delete),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, AuthService auth) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.account_delete),
        content: Text(l10n.account_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await auth.deleteAccount();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
      }
    }
  }
}
