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
  String get player_shuffle => 'Случайно';

  @override
  String get player_loop => 'Повтор';

  @override
  String get player_forward => 'Вперёд 5с';

  @override
  String get player_rewind => 'Назад 5с';

  @override
  String get player_speed => 'Скорость воспроизведения';

  @override
  String get common_reset => 'Сброс';

  @override
  String get player_nothing_playing => 'Ничего не воспроизводится';

  @override
  String get music_import => 'Импорт музыки';

  @override
  String get music_search => 'Поиск';

  @override
  String get music_empty => 'Музыка не найдена';

  @override
  String get music_remove => 'Удалить';

  @override
  String get music_rescan => 'Пересканировать';

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
  String get settings_language_system => 'Системный язык';

  @override
  String get settings_theme => 'Тема';

  @override
  String get settings_theme_system => 'Системная';

  @override
  String get settings_theme_light => 'Светлая';

  @override
  String get settings_theme_dark => 'Тёмная';

  @override
  String get statistics_total_time => 'Общее время прослушивания';

  @override
  String get statistics_play_count => 'Всего прослушиваний';

  @override
  String get statistics_top_tracks => 'Самые прослушиваемые';

  @override
  String get statistics_empty => 'Пока нет статистики';

  @override
  String get statistics_reset => 'Сбросить статистику';

  @override
  String get statistics_reset_title => 'Сбросить статистику?';

  @override
  String get statistics_reset_message =>
      'Вся статистика прослушивания на этом устройстве будет удалена. Это действие нельзя отменить.';

  @override
  String get statistics_reset_message_cloud =>
      'Вся статистика прослушивания на этом устройстве и в облачной резервной копии будет удалена. Это действие нельзя отменить.';

  @override
  String get statistics_reset_confirm => 'Сбросить';

  @override
  String get statistics_chart_title => 'Время прослушивания';

  @override
  String get statistics_chart_week => 'Неделя';

  @override
  String get statistics_chart_month => 'Месяц';

  @override
  String get statistics_chart_year => 'Год';

  @override
  String get about_version => 'Версия';

  @override
  String get about_developer => 'Разработчик';

  @override
  String get about_licenses => 'Лицензии открытого ПО';

  @override
  String get about_privacy => 'Политика конфиденциальности';

  @override
  String get about_open_source => 'Пакеты с открытым исходным кодом';

  @override
  String get account_guest => 'Гость';

  @override
  String get account_signed_out_message =>
      'Войдите, чтобы синхронизировать данные между устройствами.';

  @override
  String get account_email => 'Эл. почта';

  @override
  String get account_password => 'Пароль';

  @override
  String get account_sign_in => 'Войти';

  @override
  String get account_sign_up => 'Зарегистрироваться';

  @override
  String get account_sign_in_google => 'Войти через Google';

  @override
  String get account_sign_in_facebook => 'Войти через Facebook';

  @override
  String get account_method_email => 'Войти по эл. почте';

  @override
  String get account_method_phone => 'Войти по телефону';

  @override
  String get account_phone => 'Номер телефона';

  @override
  String get account_send_code => 'Отправить код';

  @override
  String get account_sms_code => 'Код подтверждения';

  @override
  String get account_verify_code => 'Подтвердить и войти';

  @override
  String get account_code_sent => 'Мы отправили вам код подтверждения по SMS.';

  @override
  String get account_continue_guest => 'Продолжить как гость';

  @override
  String get account_sign_out => 'Выйти';

  @override
  String get account_delete => 'Удалить аккаунт';

  @override
  String get account_delete_confirm =>
      'Вы уверены, что хотите удалить аккаунт? Это действие нельзя отменить.';

  @override
  String get account_delete_data => 'Удалить данные аккаунта';

  @override
  String get account_delete_data_confirm =>
      'Удалить все облачные данные, сохранив аккаунт? Это действие нельзя отменить.';

  @override
  String get account_delete_data_done => 'Данные вашего аккаунта удалены.';

  @override
  String get account_forgot_password => 'Забыли пароль?';

  @override
  String get account_reset_sent => 'Письмо для сброса пароля отправлено';

  @override
  String get account_anonymous => 'Анонимный аккаунт';

  @override
  String get account_unavailable => 'Функции аккаунта временно недоступны.';

  @override
  String get common_cancel => 'Отмена';

  @override
  String get common_confirm => 'Подтвердить';

  @override
  String get common_ok => 'ОК';

  @override
  String get common_delete => 'Удалить';

  @override
  String get common_retry => 'Повторить';

  @override
  String get settings_color => 'Цвет темы';

  @override
  String get lyrics_import => 'Импортировать текст';

  @override
  String get lyrics_import_success => 'Текст песни импортирован';

  @override
  String get lyrics_import_failed => 'Не удалось импортировать текст';

  @override
  String get lyrics_import_too_large => 'Файл с текстом слишком большой';

  @override
  String get lyrics_import_empty => 'В этом файле не найден текст';

  @override
  String get lyrics_empty => 'Для этого трека пока нет текста';

  @override
  String get lyrics_reimport => 'Импортировать заново';

  @override
  String get lyrics_delete => 'Удалить текст';

  @override
  String get lyrics_delete_confirm => 'Удалить текст этого трека?';

  @override
  String get lyrics_show => 'Показать текст';

  @override
  String get lyrics_hide => 'Показать обложку';

  @override
  String get lyrics_font_size => 'Размер шрифта';
}
