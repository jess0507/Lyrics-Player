// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get app_title => 'सीक प्लेयर';

  @override
  String get tab_music_list => 'संगीत';

  @override
  String get tab_player => 'प्लेयर';

  @override
  String get tab_profile => 'प्रोफ़ाइल';

  @override
  String get profile_account => 'खाता';

  @override
  String get profile_statistics => 'आँकड़े';

  @override
  String get profile_settings => 'सेटिंग्स';

  @override
  String get profile_about => 'परिचय';

  @override
  String get player_play => 'चलाएँ';

  @override
  String get player_pause => 'रोकें';

  @override
  String get player_next => 'अगला';

  @override
  String get player_previous => 'पिछला';

  @override
  String get music_import => 'संगीत आयात करें';

  @override
  String get music_search => 'खोजें';

  @override
  String get music_empty => 'कोई संगीत नहीं मिला';

  @override
  String get permission_title => 'स्टोरेज अनुमति आवश्यक है';

  @override
  String get permission_message =>
      'स्थानीय संगीत को स्कैन और चलाने के लिए हमें आपकी ऑडियो फ़ाइलों तक पहुँच की आवश्यकता है।';

  @override
  String get permission_allow => 'अनुमति दें';

  @override
  String get permission_deny => 'अभी नहीं';

  @override
  String get permission_open_settings => 'सेटिंग्स खोलें';

  @override
  String get settings_language => 'भाषा';

  @override
  String get settings_theme => 'थीम';

  @override
  String get common_cancel => 'रद्द करें';

  @override
  String get common_confirm => 'पुष्टि करें';
}
