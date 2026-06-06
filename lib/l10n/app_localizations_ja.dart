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
  String get music_import => '音楽をインポート';

  @override
  String get music_search => '検索';

  @override
  String get music_empty => '音楽が見つかりません';

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
  String get settings_theme => 'テーマ';

  @override
  String get common_cancel => 'キャンセル';

  @override
  String get common_confirm => '確定';
}
