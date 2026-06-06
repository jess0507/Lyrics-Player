// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_title => 'مشغل سيك';

  @override
  String get tab_music_list => 'الموسيقى';

  @override
  String get tab_player => 'المشغل';

  @override
  String get tab_profile => 'حسابي';

  @override
  String get profile_account => 'الحساب';

  @override
  String get profile_statistics => 'الإحصائيات';

  @override
  String get profile_settings => 'الإعدادات';

  @override
  String get profile_about => 'حول';

  @override
  String get player_play => 'تشغيل';

  @override
  String get player_pause => 'إيقاف مؤقت';

  @override
  String get player_next => 'التالي';

  @override
  String get player_previous => 'السابق';

  @override
  String get music_import => 'استيراد الموسيقى';

  @override
  String get music_search => 'بحث';

  @override
  String get music_empty => 'لم يتم العثور على موسيقى';

  @override
  String get permission_title => 'مطلوب إذن التخزين';

  @override
  String get permission_message =>
      'نحتاج إلى الوصول إلى ملفاتك الصوتية لفحص الموسيقى المحلية وتشغيلها.';

  @override
  String get permission_allow => 'السماح';

  @override
  String get permission_deny => 'ليس الآن';

  @override
  String get permission_open_settings => 'فتح الإعدادات';

  @override
  String get settings_language => 'اللغة';

  @override
  String get settings_theme => 'السمة';

  @override
  String get common_cancel => 'إلغاء';

  @override
  String get common_confirm => 'تأكيد';
}
