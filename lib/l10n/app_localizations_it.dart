// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get app_title => 'Lettore Seek';

  @override
  String get tab_music_list => 'Musica';

  @override
  String get tab_player => 'Lettore';

  @override
  String get tab_profile => 'Profilo';

  @override
  String get profile_account => 'Account';

  @override
  String get profile_statistics => 'Statistiche';

  @override
  String get profile_settings => 'Impostazioni';

  @override
  String get profile_about => 'Informazioni';

  @override
  String get player_play => 'Riproduci';

  @override
  String get player_pause => 'Pausa';

  @override
  String get player_next => 'Successivo';

  @override
  String get player_previous => 'Precedente';

  @override
  String get music_import => 'Importa musica';

  @override
  String get music_search => 'Cerca';

  @override
  String get music_empty => 'Nessuna musica trovata';

  @override
  String get permission_title => 'Autorizzazione di archiviazione richiesta';

  @override
  String get permission_message =>
      'Abbiamo bisogno di accedere ai tuoi file audio per cercare e riprodurre la musica locale.';

  @override
  String get permission_allow => 'Consenti';

  @override
  String get permission_deny => 'Non ora';

  @override
  String get permission_open_settings => 'Apri impostazioni';

  @override
  String get settings_language => 'Lingua';

  @override
  String get settings_theme => 'Tema';

  @override
  String get common_cancel => 'Annulla';

  @override
  String get common_confirm => 'Conferma';
}
