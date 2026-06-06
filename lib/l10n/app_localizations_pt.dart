// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get app_title => 'Reprodutor Seek';

  @override
  String get tab_music_list => 'Música';

  @override
  String get tab_player => 'Reprodutor';

  @override
  String get tab_profile => 'Perfil';

  @override
  String get profile_account => 'Conta';

  @override
  String get profile_statistics => 'Estatísticas';

  @override
  String get profile_settings => 'Configurações';

  @override
  String get profile_about => 'Sobre';

  @override
  String get player_play => 'Reproduzir';

  @override
  String get player_pause => 'Pausar';

  @override
  String get player_next => 'Próxima';

  @override
  String get player_previous => 'Anterior';

  @override
  String get music_import => 'Importar música';

  @override
  String get music_search => 'Pesquisar';

  @override
  String get music_empty => 'Nenhuma música encontrada';

  @override
  String get permission_title => 'Permissão de armazenamento necessária';

  @override
  String get permission_message =>
      'Precisamos de acesso aos seus arquivos de áudio para verificar e reproduzir músicas locais.';

  @override
  String get permission_allow => 'Permitir';

  @override
  String get permission_deny => 'Agora não';

  @override
  String get permission_open_settings => 'Abrir configurações';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_theme => 'Tema';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_confirm => 'Confirmar';
}
