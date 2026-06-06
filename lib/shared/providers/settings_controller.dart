import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences_service.dart';

/// 應用程式偏好：語言與主題模式（持久化於 SharedPreferences）。
class SettingsState {
  const SettingsState({this.locale, this.themeMode = ThemeMode.system});

  /// null 代表「跟隨系統語言」。
  final Locale? locale;
  final ThemeMode themeMode;

  SettingsState copyWith({
    Object? locale = _sentinel,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      locale: identical(locale, _sentinel) ? this.locale : locale as Locale?,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  static const Object _sentinel = Object();
}

class SettingsController extends Notifier<SettingsState> {
  static const _kLocale = 'settings.locale';
  static const _kThemeMode = 'settings.themeMode';

  PreferencesService get _prefs => ref.read(preferencesServiceProvider);

  @override
  SettingsState build() {
    return SettingsState(
      locale: _decodeLocale(_prefs.getString(_kLocale)),
      themeMode: _decodeThemeMode(_prefs.getString(_kThemeMode)),
    );
  }

  void setLocale(Locale? locale) {
    state = state.copyWith(locale: locale);
    if (locale == null) {
      _prefs.remove(_kLocale);
    } else {
      _prefs.setString(_kLocale, _encodeLocale(locale));
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _prefs.setString(_kThemeMode, mode.name);
  }

  static String _encodeLocale(Locale locale) {
    return locale.countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
  }

  static Locale? _decodeLocale(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split('_');
    return parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
  }

  static ThemeMode _decodeThemeMode(String? value) {
    return ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(
  SettingsController.new,
);
