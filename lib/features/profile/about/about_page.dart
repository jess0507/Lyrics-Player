import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // 對應 pubspec.yaml 的 version。
  static const _version = '1.0.0+1';

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
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.graphic_eq, size: 40),
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
            leading: const Icon(Icons.code),
            title: Text(l10n.about_developer),
            trailing: const Text('Seek Player'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.about_privacy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
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
