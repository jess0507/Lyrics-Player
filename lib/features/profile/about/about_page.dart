import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // 對應 pubspec.yaml 的 version。
  static const _version = '1.0.0+1';

  static final _privacyPolicyUrl = Uri.parse(
    'https://jess0507.github.io/seek_player/privacy-policy',
  );

  Future<void> _openPrivacyPolicy() async {
    await launchUrl(_privacyPolicyUrl, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile_about)),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/icon/app_logo.png'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              l10n.app_title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.tag),
            title: Text(l10n.about_version),
            trailing: const Text(_version),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.about_privacy),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openPrivacyPolicy,
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.about_licenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.app_title,
              applicationVersion: _version,
            ),
          ),
        ],
      ),
    );
  }
}
