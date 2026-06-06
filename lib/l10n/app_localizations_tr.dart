// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get app_title => 'Seek Oynatıcı';

  @override
  String get tab_music_list => 'Müzik';

  @override
  String get tab_player => 'Oynatıcı';

  @override
  String get tab_profile => 'Profil';

  @override
  String get profile_account => 'Hesap';

  @override
  String get profile_statistics => 'İstatistikler';

  @override
  String get profile_settings => 'Ayarlar';

  @override
  String get profile_about => 'Hakkında';

  @override
  String get player_play => 'Oynat';

  @override
  String get player_pause => 'Duraklat';

  @override
  String get player_next => 'Sonraki';

  @override
  String get player_previous => 'Önceki';

  @override
  String get music_import => 'Müzik içe aktar';

  @override
  String get music_search => 'Ara';

  @override
  String get music_empty => 'Müzik bulunamadı';

  @override
  String get permission_title => 'Depolama izni gerekli';

  @override
  String get permission_message =>
      'Yerel müzikleri taramak ve çalmak için ses dosyalarınıza erişmemiz gerekiyor.';

  @override
  String get permission_allow => 'İzin ver';

  @override
  String get permission_deny => 'Şimdi değil';

  @override
  String get permission_open_settings => 'Ayarları aç';

  @override
  String get settings_language => 'Dil';

  @override
  String get settings_theme => 'Tema';

  @override
  String get common_cancel => 'İptal';

  @override
  String get common_confirm => 'Onayla';
}
