import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/auth/email_link_controller.dart';
import '../../../../l10n/app_localizations.dart';

/// 未登入:選擇 Email(OTP / 登入連結)或 Google 登入。
/// 選擇 Email 後,於上方顯示輸入表單。
class SignedOutView extends ConsumerStatefulWidget {
  const SignedOutView({super.key});

  @override
  ConsumerState<SignedOutView> createState() => _SignedOutViewState();
}

class _SignedOutViewState extends ConsumerState<SignedOutView> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _emailSelected = false;

  @override
  void dispose() {
    _email.dispose();
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

  Future<void> _sendLink() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _email.text.trim();
    if (email.isEmpty) return;
    final controller = ref.read(emailLinkControllerProvider);
    if (controller == null) return; // Firebase 不可用
    await _run(() => controller.sendLink(email));
    _showMessage(l10n.account_link_sent);
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
        // 選擇 Email 後,輸入表單顯示於登入選項上方。
        if (_emailSelected) ...[
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l10n.account_email,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy ? null : _sendLink,
            child: Text(l10n.account_send_link),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
        ],
        // 登入方式選項。
        OutlinedButton.icon(
          onPressed:
              _busy ? null : () => setState(() => _emailSelected = true),
          icon: const Icon(Icons.mail_outline),
          label: Text(l10n.account_method_email),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _run(_auth.signInWithGoogle),
          icon: const Icon(Icons.account_circle),
          label: Text(l10n.account_sign_in_google),
        ),
        if (_busy) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
