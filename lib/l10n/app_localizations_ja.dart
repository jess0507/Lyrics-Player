// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get app_title => 'シークプレイヤー';

  @override
  String get tab_music_list => '音楽';

  @override
  String get tab_player => 'プレイヤー';

  @override
  String get tab_profile => 'マイページ';

  @override
  String get profile_account => 'アカウント';

  @override
  String get profile_statistics => '統計';

  @override
  String get profile_settings => '設定';

  @override
  String get profile_about => 'アプリについて';

  @override
  String get player_play => '再生';

  @override
  String get player_pause => '一時停止';

  @override
  String get player_next => '次へ';

  @override
  String get player_previous => '前へ';

  @override
  String get player_shuffle => 'Shuffle';

  @override
  String get player_loop => 'Repeat';

  @override
  String get player_nothing_playing => 'Nothing playing';

  @override
  String get music_import => '音楽をインポート';

  @override
  String get music_search => '検索';

  @override
  String get music_empty => '音楽が見つかりません';

  @override
  String get music_remove => 'Remove';

  @override
  String get permission_title => 'ストレージへのアクセス許可が必要です';

  @override
  String get permission_message => 'ローカルの音楽をスキャンして再生するためにオーディオファイルへのアクセスが必要です。';

  @override
  String get permission_allow => '許可';

  @override
  String get permission_deny => '後で';

  @override
  String get permission_open_settings => '設定を開く';

  @override
  String get settings_language => '言語';

  @override
  String get settings_language_system => 'System default';

  @override
  String get settings_theme => 'テーマ';

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
  String get common_cancel => 'キャンセル';

  @override
  String get common_confirm => '確定';

  @override
  String get common_ok => 'OK';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_retry => 'Retry';
}
