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
  String get music_import => '음악 가져오기';

  @override
  String get music_search => '검색';

  @override
  String get music_empty => '음악을 찾을 수 없습니다';

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
  String get settings_theme => '테마';

  @override
  String get common_cancel => '취소';

  @override
  String get common_confirm => '확인';
}
