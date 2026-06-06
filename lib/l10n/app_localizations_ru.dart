// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get app_title => 'Плеер Seek';

  @override
  String get tab_music_list => 'Музыка';

  @override
  String get tab_player => 'Плеер';

  @override
  String get tab_profile => 'Профиль';

  @override
  String get profile_account => 'Аккаунт';

  @override
  String get profile_statistics => 'Статистика';

  @override
  String get profile_settings => 'Настройки';

  @override
  String get profile_about => 'О приложении';

  @override
  String get player_play => 'Воспроизвести';

  @override
  String get player_pause => 'Пауза';

  @override
  String get player_next => 'Следующий';

  @override
  String get player_previous => 'Предыдущий';

  @override
  String get music_import => 'Импорт музыки';

  @override
  String get music_search => 'Поиск';

  @override
  String get music_empty => 'Музыка не найдена';

  @override
  String get permission_title => 'Требуется разрешение на доступ к хранилищу';

  @override
  String get permission_message =>
      'Нам нужен доступ к вашим аудиофайлам для сканирования и воспроизведения локальной музыки.';

  @override
  String get permission_allow => 'Разрешить';

  @override
  String get permission_deny => 'Не сейчас';

  @override
  String get permission_open_settings => 'Открыть настройки';

  @override
  String get settings_language => 'Язык';

  @override
  String get settings_theme => 'Тема';

  @override
  String get common_cancel => 'Отмена';

  @override
  String get common_confirm => 'Подтвердить';
}
