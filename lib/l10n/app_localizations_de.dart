// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get app_title => 'Seek Player';

  @override
  String get tab_music_list => 'Musik';

  @override
  String get tab_player => 'Player';

  @override
  String get tab_profile => 'Profil';

  @override
  String get profile_account => 'Konto';

  @override
  String get profile_statistics => 'Statistiken';

  @override
  String get profile_settings => 'Einstellungen';

  @override
  String get profile_about => 'Über';

  @override
  String get player_play => 'Wiedergabe';

  @override
  String get player_pause => 'Pause';

  @override
  String get player_next => 'Weiter';

  @override
  String get player_previous => 'Zurück';

  @override
  String get music_import => 'Musik importieren';

  @override
  String get music_search => 'Suchen';

  @override
  String get music_empty => 'Keine Musik gefunden';

  @override
  String get permission_title => 'Speicherberechtigung erforderlich';

  @override
  String get permission_message =>
      'Wir benötigen Zugriff auf deine Audiodateien um lokale Musik zu scannen und abzuspielen.';

  @override
  String get permission_allow => 'Zulassen';

  @override
  String get permission_deny => 'Nicht jetzt';

  @override
  String get permission_open_settings => 'Einstellungen öffnen';

  @override
  String get settings_language => 'Sprache';

  @override
  String get settings_theme => 'Design';

  @override
  String get common_cancel => 'Abbrechen';

  @override
  String get common_confirm => 'Bestätigen';
}
