import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/app_locales.dart';
import '../../../shared/providers/settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile_settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settings_language),
            subtitle: Text(_localeLabel(settings.locale, l10n)),
            onTap: () => _pickLanguage(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l10n.settings_theme),
            subtitle: Text(_themeLabel(settings.themeMode, l10n)),
          ),
          RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (mode) {
              if (mode != null) controller.setThemeMode(mode);
            },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  title: Text(l10n.settings_theme_system),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  title: Text(l10n.settings_theme_light),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  title: Text(l10n.settings_theme_dark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode, AppLocalizations l10n) => switch (mode) {
        ThemeMode.light => l10n.settings_theme_light,
        ThemeMode.dark => l10n.settings_theme_dark,
        ThemeMode.system => l10n.settings_theme_system,
      };

  String _localeLabel(Locale? locale, AppLocalizations l10n) {
    if (locale == null) return l10n.settings_language_system;
    for (final option in kAppLocales) {
      if (option.locale == locale) return option.nativeName;
    }
    return locale.toLanguageTag();
  }

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(settingsControllerProvider.notifier);
    final current = ref.read(settingsControllerProvider).locale;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: RadioGroup<Locale?>(
            groupValue: current,
            onChanged: (locale) {
              controller.setLocale(locale);
              Navigator.of(context).pop();
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                RadioListTile<Locale?>(
                  value: null,
                  title: Text(l10n.settings_language_system),
                ),
                for (final option in kAppLocales)
                  RadioListTile<Locale?>(
                    value: option.locale,
                    title: Text(option.nativeName),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
