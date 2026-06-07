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
  String get player_shuffle => 'Shuffle';

  @override
  String get player_loop => 'Repeat';

  @override
  String get player_forward => 'Вперёд 5с';

  @override
  String get player_rewind => 'Назад 5с';

  @override
  String get player_speed => 'Скорость воспроизведения';

  @override
  String get player_speed_reset => 'Сброс';

  @override
  String get player_nothing_playing => 'Nothing playing';

  @override
  String get music_import => 'Импорт музыки';

  @override
  String get music_search => 'Поиск';

  @override
  String get music_empty => 'Музыка не найдена';

  @override
  String get music_remove => 'Remove';

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
  String get settings_language_system => 'System default';

  @override
  String get settings_theme => 'Тема';

  @override
  String get settings_theme_system => 'System';

  @override
  String get settings_theme_light => 'Light';

  @override
  String get settings_theme_dark => 'Dark';

  @override
  String get statistics_total_time => 'Total listening time';

  @override
  String get statistics_play_count => 'Total plays';

  @override
  String get statistics_top_tracks => 'Most played';

  @override
  String get statistics_empty => 'No statistics yet';

  @override
  String get statistics_reset => 'Reset statistics';

  @override
  String get about_version => 'Version';

  @override
  String get about_developer => 'Developer';

  @override
  String get about_licenses => 'Open source licenses';

  @override
  String get about_privacy => 'Privacy policy';

  @override
  String get about_open_source => 'Open source packages';

  @override
  String get account_guest => 'Guest';

  @override
  String get account_signed_out_message =>
      'Sign in to sync, or continue as a guest.';

  @override
  String get account_email => 'Email';

  @override
  String get account_password => 'Password';

  @override
  String get account_sign_in => 'Sign in';

  @override
  String get account_sign_up => 'Sign up';

  @override
  String get account_sign_in_google => 'Sign in with Google';

  @override
  String get account_continue_guest => 'Continue as guest';

  @override
  String get account_sign_out => 'Sign out';

  @override
  String get account_delete => 'Delete account';

  @override
  String get account_delete_confirm =>
      'Are you sure you want to delete your account? This cannot be undone.';

  @override
  String get account_forgot_password => 'Forgot password?';

  @override
  String get account_reset_sent => 'Password reset email sent';

  @override
  String get account_anonymous => 'Anonymous account';

  @override
  String get firebase_unavailable =>
      'Account features are unavailable because Firebase is not configured.';

  @override
  String get common_cancel => 'Отмена';

  @override
  String get common_confirm => 'Подтвердить';

  @override
  String get common_ok => 'OK';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_retry => 'Retry';
}
