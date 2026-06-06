// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get app_title => 'Lecteur Seek';

  @override
  String get tab_music_list => 'Musique';

  @override
  String get tab_player => 'Lecteur';

  @override
  String get tab_profile => 'Profil';

  @override
  String get profile_account => 'Compte';

  @override
  String get profile_statistics => 'Statistiques';

  @override
  String get profile_settings => 'Paramètres';

  @override
  String get profile_about => 'À propos';

  @override
  String get player_play => 'Lire';

  @override
  String get player_pause => 'Pause';

  @override
  String get player_next => 'Suivant';

  @override
  String get player_previous => 'Précédent';

  @override
  String get music_import => 'Importer de la musique';

  @override
  String get music_search => 'Rechercher';

  @override
  String get music_empty => 'Aucune musique trouvée';

  @override
  String get permission_title => 'Autorisation de stockage requise';

  @override
  String get permission_message =>
      'Nous avons besoin d\'accéder à vos fichiers audio pour analyser et lire la musique locale.';

  @override
  String get permission_allow => 'Autoriser';

  @override
  String get permission_deny => 'Pas maintenant';

  @override
  String get permission_open_settings => 'Ouvrir les paramètres';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_theme => 'Thème';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get common_confirm => 'Confirmer';
}
