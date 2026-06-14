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
  String get player_shuffle => 'Shuffle';

  @override
  String get player_loop => 'Repeat';

  @override
  String get player_forward => '5 सेकंड आगे';

  @override
  String get player_rewind => '5 सेकंड पीछे';

  @override
  String get player_speed => 'प्लेबैक गति';

  @override
  String get player_speed_reset => 'रीसेट';

  @override
  String get player_nothing_playing => 'Nothing playing';

  @override
  String get music_import => 'संगीत आयात करें';

  @override
  String get music_search => 'खोजें';

  @override
  String get music_empty => 'कोई संगीत नहीं मिला';

  @override
  String get music_remove => 'Remove';

  @override
  String get music_rescan => 'Rescan';

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
  String get settings_language_system => 'System default';

  @override
  String get settings_theme => 'थीम';

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
  String get statistics_reset_title => 'Reset statistics?';

  @override
  String get statistics_reset_message =>
      'All listening statistics on this device will be deleted. This cannot be undone.';

  @override
  String get statistics_reset_message_cloud =>
      'All listening statistics on this device and your cloud backup will be deleted. This cannot be undone.';

  @override
  String get statistics_reset_confirm => 'Reset';

  @override
  String get statistics_chart_title => 'Listening time';

  @override
  String get statistics_chart_week => 'Week';

  @override
  String get statistics_chart_month => 'Month';

  @override
  String get statistics_chart_year => 'Year';

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
      'Sign in to sync your data across devices.';

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
  String get account_sign_in_facebook => 'Sign in with Facebook';

  @override
  String get account_method_email => 'Sign in with email';

  @override
  String get account_method_phone => 'Sign in with phone';

  @override
  String get account_phone => 'Phone number';

  @override
  String get account_send_code => 'Send code';

  @override
  String get account_sms_code => 'Verification code';

  @override
  String get account_verify_code => 'Verify and sign in';

  @override
  String get account_code_sent => 'We\'ve texted you a verification code.';

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
  String get account_delete_data => 'Delete account data';

  @override
  String get account_delete_data_confirm =>
      'Delete all your cloud data while keeping your account? This cannot be undone.';

  @override
  String get account_delete_data_done => 'Your account data has been deleted.';

  @override
  String get account_forgot_password => 'Forgot password?';

  @override
  String get account_reset_sent => 'Password reset email sent';

  @override
  String get account_anonymous => 'Anonymous account';

  @override
  String get account_unavailable =>
      'Account features are temporarily unavailable.';

  @override
  String get common_cancel => 'रद्द करें';

  @override
  String get common_confirm => 'पुष्टि करें';

  @override
  String get common_ok => 'OK';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_retry => 'Retry';

  @override
  String get settings_color => 'थीम रंग';

  @override
  String get lyrics_import => 'Import lyrics';

  @override
  String get lyrics_import_success => 'Lyrics imported';

  @override
  String get lyrics_import_failed => 'Couldn\'t import lyrics';

  @override
  String get lyrics_import_too_large => 'Lyrics file is too large';

  @override
  String get lyrics_import_empty => 'No lyrics found in this file';
}
