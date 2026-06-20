// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get app_title => '歌詞プレーヤー Lyrics Player';

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
  String get player_shuffle => 'シャッフル';

  @override
  String get player_loop => 'リピート';

  @override
  String get player_forward => '5秒進む';

  @override
  String get player_rewind => '5秒戻る';

  @override
  String get player_speed => '再生速度';

  @override
  String get common_reset => 'リセット';

  @override
  String get player_nothing_playing => '再生中の曲はありません';

  @override
  String get music_import => '音楽をインポート';

  @override
  String get music_search => '検索';

  @override
  String get music_empty => '音楽が見つかりません';

  @override
  String get music_remove => '削除';

  @override
  String get music_rescan => '再スキャン';

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
  String get settings_language_system => 'システムのデフォルト';

  @override
  String get settings_theme => 'テーマ';

  @override
  String get settings_theme_system => 'システム';

  @override
  String get settings_theme_light => 'ライト';

  @override
  String get settings_theme_dark => 'ダーク';

  @override
  String get statistics_total_time => '総再生時間';

  @override
  String get statistics_play_count => '総再生回数';

  @override
  String get statistics_top_tracks => '再生回数が多い曲';

  @override
  String get statistics_empty => 'まだ統計がありません';

  @override
  String get statistics_reset => '統計をリセット';

  @override
  String get statistics_reset_title => '統計をリセットしますか？';

  @override
  String get statistics_reset_message => 'このデバイスのすべての再生統計が削除されます。この操作は取り消せません。';

  @override
  String get statistics_reset_message_cloud =>
      'このデバイスとクラウドバックアップのすべての再生統計が削除されます。この操作は取り消せません。';

  @override
  String get statistics_reset_confirm => 'リセット';

  @override
  String get statistics_chart_title => '再生時間';

  @override
  String get statistics_chart_week => '週';

  @override
  String get statistics_chart_month => '月';

  @override
  String get statistics_chart_year => '年';

  @override
  String get about_version => 'バージョン';

  @override
  String get about_developer => '開発者';

  @override
  String get about_licenses => 'オープンソースライセンス';

  @override
  String get about_privacy => 'プライバシーポリシー';

  @override
  String get about_open_source => 'オープンソースパッケージ';

  @override
  String get account_guest => 'ゲスト';

  @override
  String get account_signed_out_message => 'サインインしてデバイス間でデータを同期します。';

  @override
  String get account_email => 'メールアドレス';

  @override
  String get account_password => 'パスワード';

  @override
  String get account_sign_in => 'サインイン';

  @override
  String get account_sign_up => '新規登録';

  @override
  String get account_sign_in_google => 'Googleでサインイン';

  @override
  String get account_sign_in_facebook => 'Facebookでサインイン';

  @override
  String get account_method_email => 'メールでサインイン';

  @override
  String get account_method_phone => '電話でサインイン';

  @override
  String get account_phone => '電話番号';

  @override
  String get account_send_code => 'コードを送信';

  @override
  String get account_sms_code => '確認コード';

  @override
  String get account_verify_code => '確認してサインイン';

  @override
  String get account_code_sent => '確認コードをSMSで送信しました。';

  @override
  String get account_continue_guest => 'ゲストとして続行';

  @override
  String get account_sign_out => 'サインアウト';

  @override
  String get account_delete => 'アカウントを削除';

  @override
  String get account_delete_confirm => 'アカウントを削除してもよろしいですか？この操作は取り消せません。';

  @override
  String get account_delete_data => 'アカウントデータを削除';

  @override
  String get account_delete_data_confirm =>
      'アカウントを残したままクラウドデータをすべて削除しますか？この操作は取り消せません。';

  @override
  String get account_delete_data_done => 'アカウントデータを削除しました。';

  @override
  String get account_forgot_password => 'パスワードをお忘れですか？';

  @override
  String get account_reset_sent => 'パスワード再設定メールを送信しました';

  @override
  String get account_anonymous => '匿名アカウント';

  @override
  String get account_unavailable => 'アカウント機能は一時的に利用できません。';

  @override
  String get common_cancel => 'キャンセル';

  @override
  String get common_confirm => '確定';

  @override
  String get common_ok => 'OK';

  @override
  String get common_delete => '削除';

  @override
  String get common_retry => '再試行';

  @override
  String get settings_color => 'テーマカラー';

  @override
  String get settings_gradient => 'グラデーションテーマ';

  @override
  String get settings_gradient_desc => 'プレーヤーでテーマカラーのグラデーション背景を使用します';

  @override
  String get lyrics_import => '歌詞をインポート';

  @override
  String get lyrics_import_success => '歌詞をインポートしました';

  @override
  String get lyrics_import_failed => '歌詞をインポートできませんでした';

  @override
  String get lyrics_import_too_large => '歌詞ファイルが大きすぎます';

  @override
  String get lyrics_import_empty => 'このファイルに歌詞が見つかりません';

  @override
  String get lyrics_empty => 'この曲の歌詞はまだありません';

  @override
  String get lyrics_reimport => '再インポート';

  @override
  String get lyrics_delete => '歌詞を削除';

  @override
  String get lyrics_delete_confirm => 'この曲の歌詞を削除しますか？';

  @override
  String get lyrics_show => '歌詞を表示';

  @override
  String get lyrics_hide => 'アートワークを表示';

  @override
  String get cover_edit => 'Edit cover';

  @override
  String get cover_add => 'Add cover';

  @override
  String get cover_change => 'Change cover';

  @override
  String get cover_remove => 'Remove cover';

  @override
  String get cover_updated => 'Cover updated';

  @override
  String get cover_removed => 'Cover removed';

  @override
  String get cover_failed => 'Couldn\'t set cover';

  @override
  String get cover_too_large => 'Image is too large';

  @override
  String get lyrics_font_size => '文字サイズ';

  @override
  String get lyrics_auto_sync => 'Auto-sync timing';

  @override
  String get lyrics_auto_sync_compressing => 'Preparing audio…';

  @override
  String get lyrics_auto_sync_uploading => 'Uploading audio…';

  @override
  String get lyrics_auto_sync_aligning => 'Aligning lyrics…';

  @override
  String get lyrics_auto_sync_success =>
      'Lyrics synced (auto, may be imperfect)';

  @override
  String get lyrics_auto_sync_failed =>
      'Couldn\'t sync lyrics; kept original text';

  @override
  String get lyrics_auto_sync_need_login => 'Sign in to use auto-sync';

  @override
  String get lyrics_auto_sync_rate_limited =>
      'Daily auto-sync limit reached, try tomorrow';

  @override
  String get lyrics_auto_sync_no_audio => 'Audio file not found';

  @override
  String get lyrics_auto_sync_network => 'Connection problem, try again later';

  @override
  String get tab_playlists => 'Playlists';

  @override
  String get playlist_favorites => 'Favorites';

  @override
  String get playlist_new => 'New playlist';

  @override
  String get playlist_name_hint => 'Playlist name';

  @override
  String get playlist_rename => 'Rename';

  @override
  String get playlist_delete => 'Delete playlist';

  @override
  String playlist_delete_confirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get playlist_add_to => 'Add to playlist';

  @override
  String playlist_added(String name) {
    return 'Added to \"$name\"';
  }

  @override
  String playlist_already_added(String name) {
    return 'Already in \"$name\"';
  }

  @override
  String get playlist_remove_track => 'Remove from playlist';

  @override
  String get playlist_empty => 'No songs in this playlist yet';

  @override
  String get playlists_empty => 'No playlists yet';

  @override
  String get playlist_play_all => 'Play all';

  @override
  String playlist_track_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
      zero: 'No songs',
    );
    return '$_temp0';
  }
}
