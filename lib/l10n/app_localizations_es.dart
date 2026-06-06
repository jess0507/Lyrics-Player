// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'Reproductor Seek';

  @override
  String get tab_music_list => 'Música';

  @override
  String get tab_player => 'Reproductor';

  @override
  String get tab_profile => 'Perfil';

  @override
  String get profile_account => 'Cuenta';

  @override
  String get profile_statistics => 'Estadísticas';

  @override
  String get profile_settings => 'Ajustes';

  @override
  String get profile_about => 'Acerca de';

  @override
  String get player_play => 'Reproducir';

  @override
  String get player_pause => 'Pausa';

  @override
  String get player_next => 'Siguiente';

  @override
  String get player_previous => 'Anterior';

  @override
  String get music_import => 'Importar música';

  @override
  String get music_search => 'Buscar';

  @override
  String get music_empty => 'No se encontró música';

  @override
  String get permission_title => 'Se requiere permiso de almacenamiento';

  @override
  String get permission_message =>
      'Necesitamos acceso a tus archivos de audio para escanear y reproducir música local.';

  @override
  String get permission_allow => 'Permitir';

  @override
  String get permission_deny => 'Ahora no';

  @override
  String get permission_open_settings => 'Abrir ajustes';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_theme => 'Tema';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_confirm => 'Confirmar';
}
