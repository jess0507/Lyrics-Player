// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get app_title => '시크 플레이어';

  @override
  String get tab_music_list => '음악';

  @override
  String get tab_player => '플레이어';

  @override
  String get tab_profile => '마이';

  @override
  String get profile_account => '계정';

  @override
  String get profile_statistics => '통계';

  @override
  String get profile_settings => '설정';

  @override
  String get profile_about => '정보';

  @override
  String get player_play => '재생';

  @override
  String get player_pause => '일시정지';

  @override
  String get player_next => '다음';

  @override
  String get player_previous => '이전';

  @override
  String get player_shuffle => 'Shuffle';

  @override
  String get player_loop => 'Repeat';

  @override
  String get player_forward => '5초 앞으로';

  @override
  String get player_rewind => '5초 뒤로';

  @override
  String get player_speed => '재생 속도';

  @override
  String get player_speed_reset => '초기화';

  @override
  String get player_nothing_playing => 'Nothing playing';

  @override
  String get music_import => '음악 가져오기';

  @override
  String get music_search => '검색';

  @override
  String get music_empty => '음악을 찾을 수 없습니다';

  @override
  String get music_remove => 'Remove';

  @override
  String get music_rescan => 'Rescan';

  @override
  String get permission_title => '저장소 권한이 필요합니다';

  @override
  String get permission_message => '로컬 음악을 검색하고 재생하려면 오디오 파일에 대한 접근 권한이 필요합니다.';

  @override
  String get permission_allow => '허용';

  @override
  String get permission_deny => '나중에';

  @override
  String get permission_open_settings => '설정 열기';

  @override
  String get settings_language => '언어';

  @override
  String get settings_language_system => 'System default';

  @override
  String get settings_theme => '테마';

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
  String get common_cancel => '취소';

  @override
  String get common_confirm => '확인';

  @override
  String get common_ok => 'OK';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_retry => 'Retry';

  @override
  String get settings_color => '테마 색상';
}
