import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../l10n/app_localizations.dart';

/// 未登入 / 匿名:顯示登入表單與 Google / 訪客入口。
class SignedOutView extends ConsumerStatefulWidget {
  const SignedOutView({super.key, required this.anonymous});

  final bool anonymous;

  @override
  ConsumerState<SignedOutView> createState() => _SignedOutViewState();
}

class _SignedOutViewState extends ConsumerState<SignedOutView> {
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
