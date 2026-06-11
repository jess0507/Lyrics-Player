import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/auth/auth_state_provider.dart';
import '../../../core/firebase_available_provider.dart';
import '../../../l10n/app_localizations.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final firebaseReady = ref.watch(firebaseAvailableProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile_account)),
      body: !firebaseReady
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.firebase_unavailable,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ref.watch(authStateProvider).when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (user) => user == null || user.isAnonymous
                    ? _SignedOutView(anonymous: user?.isAnonymous ?? false)
                    : _SignedInView(user: user),
              ),
    );
  }
}

/// 未登入 / 匿名：顯示登入表單與 Google / 訪客入口。
class _SignedOutView extends ConsumerStatefulWidget {
  const _SignedOutView({required this.anonymous});

  final bool anonymous;

  @override
  ConsumerState<_SignedOutView> createState() => _SignedOutViewState();
}

class _SignedOutViewState extends ConsumerState<_SignedOutView> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  AuthService get _auth => ref.read(authServiceProvider);

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? e.code);
    } catch (e) {
      _showMessage('$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.account_signed_out_message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: l10n.account_email,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _password,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.account_password,
            border: const OutlineInputBorder(),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: _busy ? null : _resetPassword,
            child: Text(l10n.account_forgot_password),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _busy
              ? null
              : () => _run(() => _auth.signInWithEmail(
                    _email.text.trim(),
                    _password.text,
                  )),
          child: Text(l10n.account_sign_in),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _run(() => _auth.registerWithEmail(
                    _email.text.trim(),
                    _password.text,
                  )),
          child: Text(l10n.account_sign_up),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _run(_auth.signInWithGoogle),
          icon: const Icon(Icons.account_circle),
          label: Text(l10n.account_sign_in_google),
        ),
        if (!widget.anonymous) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: _busy ? null : () => _run(_auth.signInAnonymously),
            child: Text(l10n.account_continue_guest),
          ),
        ],
        if (_busy) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _email.text.trim();
    if (email.isEmpty) return;
    await _run(() => _auth.sendPasswordReset(email));
    _showMessage(l10n.account_reset_sent);
  }
}

/// 已登入：顯示頭像、Email、登出與刪除帳號。
class _SignedInView extends ConsumerWidget {
  const _SignedInView({required this.user});

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
