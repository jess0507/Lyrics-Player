import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/auth/email_link_controller.dart';
import '../../../../l10n/app_localizations.dart';
import 'country_code_dropdown.dart';

/// 未登入:選擇 Google、手機簡訊 OTP 或 Email 登入連結。
/// 選擇手機或 Email 後,於登入選項上方顯示對應的輸入表單。
class SignedOutView extends ConsumerStatefulWidget {
  const SignedOutView({super.key});

  @override
  ConsumerState<SignedOutView> createState() => _SignedOutViewState();
}

/// 目前展開的登入方式(none 表示尚未選擇,只顯示選項清單)。
enum _Method { none, phone, email }

class _SignedOutViewState extends ConsumerState<SignedOutView> {
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _smsCode = TextEditingController();
  bool _busy = false;
  _Method _method = _Method.none;

  /// 目前選擇的國碼(預設為清單首項台灣)。
  DialCode _dialCode = kDialCodes.first;

  /// 手機 OTP 寄出後取得的 verificationId;非 null 時顯示驗證碼輸入。
  String? _verificationId;

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    _smsCode.dispose();
    super.dispose();
  }

  AuthService get _auth => ref.read(authServiceProvider);

  /// 執行 [action],成功回傳 true、失敗顯示錯誤並回傳 false。
  Future<bool> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e, s) {
      debugPrint('[Account] FirebaseAuthException code=${e.code} '
          'message=${e.message}\n$s');
      _showMessage(e.message ?? e.code);
      return false;
    } catch (e, s) {
      debugPrint('[Account] 登入流程錯誤:$e\n$s');
      _showMessage('$e');
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// 選擇登入方式(展開對應表單);重新選擇手機時重置驗證碼狀態。
  void _select(_Method method) {
    setState(() {
      _method = method;
      if (method != _Method.phone) _verificationId = null;
    });
  }

  Future<void> _sendOtp() async {
    final l10n = AppLocalizations.of(context)!;
    final e164 = _composeE164();
    if (e164 == null) return;
    final ok = await _run(() async {
      final id = await _auth.sendPhoneOtp(e164);
      if (mounted) setState(() => _verificationId = id);
    });
    if (ok) _showMessage(l10n.account_code_sent);
  }

  /// 將國碼與輸入號碼組成 E.164(如 `+886912345678`),無號碼時回傳 null。
  ///
  /// 移除非數字字元,並去掉主幹碼前綴的單一前導 0(多數國家適用)。
  String? _composeE164() {
    var national = _phone.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (national.startsWith('0')) national = national.substring(1);
    if (national.isEmpty) return null;
    return '${_dialCode.code}$national';
  }

  Future<void> _verifyOtp() async {
    final id = _verificationId;
    final code = _smsCode.text.trim();
    if (id == null || code.isEmpty) return;
    // 成功後 authState 變更,畫面自動切換為已登入。
    await _run(() => _auth.signInWithSmsCode(id, code));
  }

  Future<void> _sendLink() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _email.text.trim();
    if (email.isEmpty) return;
    final controller = ref.read(emailLinkControllerProvider);
    if (controller == null) return; // Firebase 不可用
    final ok = await _run(() => controller.sendLink(email));
    if (ok) _showMessage(l10n.account_link_sent);
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
        // 選擇方式後,對應輸入表單顯示於登入選項上方。
        if (_method == _Method.phone) ...[
          _phoneForm(l10n),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
        ] else if (_method == _Method.email) ...[
          _emailForm(l10n),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
        ],
        // 登入方式選項:Google → 手機 OTP → Email 登入連結。
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _run(_auth.signInWithGoogle),
          icon: const Icon(Icons.account_circle),
          label: Text(l10n.account_sign_in_google),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _select(_Method.phone),
          icon: const Icon(Icons.sms_outlined),
          label: Text(l10n.account_method_phone),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _select(_Method.email),
          icon: const Icon(Icons.mail_outline),
          label: Text(l10n.account_method_email),
        ),
        if (_busy) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }

  /// 手機 OTP 表單:先輸入號碼寄送驗證碼,寄出後改為輸入驗證碼完成登入。
  Widget _phoneForm(AppLocalizations l10n) {
    final codeSent = _verificationId != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 132,
              child: CountryCodeDropdown(
                value: _dialCode,
                enabled: !codeSent,
                onChanged: (c) => setState(() => _dialCode = c),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _phone,
                enabled: !codeSent,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: l10n.account_phone,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        if (!codeSent) ...[
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy ? null : _sendOtp,
            child: Text(l10n.account_send_code),
          ),
        ] else ...[
          const SizedBox(height: 12),
          TextField(
            controller: _smsCode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.account_sms_code,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy ? null : _verifyOtp,
            child: Text(l10n.account_verify_code),
          ),
        ],
      ],
    );
  }

  /// Email 登入連結表單。
  Widget _emailForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
      ],
    );
  }
}
