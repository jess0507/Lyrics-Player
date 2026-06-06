// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Seek Player';

  @override
  String get tab_music_list => 'Music';

  @override
  String get tab_player => 'Player';

  @override
  String get tab_profile => 'Profile';

  @override
  String get profile_account => 'Account';

  @override
  String get profile_statistics => 'Statistics';

  @override
  String get profile_settings => 'Settings';

  @override
  String get profile_about => 'About';

  @override
  String get player_play => 'Play';

  @override
  String get player_pause => 'Pause';

  @override
  String get player_next => 'Next';

  @override
  String get player_previous => 'Previous';

  @override
  String get music_import => 'Import music';

  @override
  String get music_search => 'Search';

  @override
  String get music_empty => 'No music found';

  @override
  String get permission_title => 'Storage permission required';

  @override
  String get permission_message =>
      'We need access to your audio files to scan and play local music.';

  @override
  String get permission_allow => 'Allow';

  @override
  String get permission_deny => 'Not now';

  @override
  String get permission_open_settings => 'Open settings';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_theme => 'Theme';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_confirm => 'Confirm';
}
