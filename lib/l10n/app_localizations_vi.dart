// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get app_title => 'Trình phát Seek';

  @override
  String get tab_music_list => 'Nhạc';

  @override
  String get tab_player => 'Trình phát';

  @override
  String get tab_profile => 'Cá nhân';

  @override
  String get profile_account => 'Tài khoản';

  @override
  String get profile_statistics => 'Thống kê';

  @override
  String get profile_settings => 'Cài đặt';

  @override
  String get profile_about => 'Giới thiệu';

  @override
  String get player_play => 'Phát';

  @override
  String get player_pause => 'Tạm dừng';

  @override
  String get player_next => 'Tiếp theo';

  @override
  String get player_previous => 'Trước đó';

  @override
  String get music_import => 'Nhập nhạc';

  @override
  String get music_search => 'Tìm kiếm';

  @override
  String get music_empty => 'Không tìm thấy nhạc';

  @override
  String get permission_title => 'Cần quyền truy cập bộ nhớ';

  @override
  String get permission_message =>
      'Chúng tôi cần quyền truy cập tệp âm thanh để quét và phát nhạc cục bộ.';

  @override
  String get permission_allow => 'Cho phép';

  @override
  String get permission_deny => 'Để sau';

  @override
  String get permission_open_settings => 'Mở cài đặt';

  @override
  String get settings_language => 'Ngôn ngữ';

  @override
  String get settings_theme => 'Giao diện';

  @override
  String get common_cancel => 'Hủy';

  @override
  String get common_confirm => 'Xác nhận';
}
