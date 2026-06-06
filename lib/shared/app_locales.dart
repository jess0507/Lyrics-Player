import 'package:flutter/widgets.dart';

/// 應用程式支援的 16 語系（與 supportedLocales / Google Sheet 欄位一致）。
/// `nativeName` 以各語言自身文字呈現，供設定頁切換語言時顯示。
class AppLocaleOption {
  const AppLocaleOption(this.locale, this.nativeName);

  final Locale locale;
  final String nativeName;
}

const List<AppLocaleOption> kAppLocales = [
  AppLocaleOption(Locale('en'), 'English'),
  AppLocaleOption(Locale('zh', 'CN'), '简体中文'),
  AppLocaleOption(Locale('zh', 'TW'), '繁體中文'),
  AppLocaleOption(Locale('es'), 'Español'),
  AppLocaleOption(Locale('fr'), 'Français'),
  AppLocaleOption(Locale('de'), 'Deutsch'),
  AppLocaleOption(Locale('ja'), '日本語'),
  AppLocaleOption(Locale('ko'), '한국어'),
  AppLocaleOption(Locale('pt'), 'Português'),
  AppLocaleOption(Locale('it'), 'Italiano'),
  AppLocaleOption(Locale('ru'), 'Русский'),
  AppLocaleOption(Locale('tr'), 'Türkçe'),
  AppLocaleOption(Locale('hi'), 'हिन्दी'),
  AppLocaleOption(Locale('id'), 'Indonesia'),
  AppLocaleOption(Locale('vi'), 'Tiếng Việt'),
  AppLocaleOption(Locale('ar'), 'العربية'),
];
