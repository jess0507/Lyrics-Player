import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Seek Player'**
  String get app_title;

  /// No description provided for @tab_music_list.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get tab_music_list;

  /// No description provided for @tab_player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get tab_player;

  /// No description provided for @tab_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tab_profile;

  /// No description provided for @profile_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profile_account;

  /// No description provided for @profile_statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get profile_statistics;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// No description provided for @profile_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profile_about;

  /// No description provided for @player_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get player_play;

  /// No description provided for @player_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get player_pause;

  /// No description provided for @player_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get player_next;

  /// No description provided for @player_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get player_previous;

  /// No description provided for @player_shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get player_shuffle;

  /// No description provided for @player_loop.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get player_loop;

  /// No description provided for @player_forward.
  ///
  /// In en, this message translates to:
  /// **'Forward 5s'**
  String get player_forward;

  /// No description provided for @player_rewind.
  ///
  /// In en, this message translates to:
  /// **'Rewind 5s'**
  String get player_rewind;

  /// No description provided for @player_speed.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get player_speed;

  /// No description provided for @player_speed_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get player_speed_reset;

  /// No description provided for @player_nothing_playing.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get player_nothing_playing;

  /// No description provided for @music_import.
  ///
  /// In en, this message translates to:
  /// **'Import music'**
  String get music_import;

  /// No description provided for @music_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get music_search;

  /// No description provided for @music_empty.
  ///
  /// In en, this message translates to:
  /// **'No music yet. Tap import to add songs.'**
  String get music_empty;

  /// No description provided for @music_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get music_remove;

  /// No description provided for @permission_title.
  ///
  /// In en, this message translates to:
  /// **'Storage permission required'**
  String get permission_title;

  /// No description provided for @permission_message.
  ///
  /// In en, this message translates to:
  /// **'We need access to your audio files to scan and play local music.'**
  String get permission_message;

  /// No description provided for @permission_allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get permission_allow;

  /// No description provided for @permission_deny.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get permission_deny;

  /// No description provided for @permission_open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get permission_open_settings;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_language_system.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settings_language_system;

  /// No description provided for @settings_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme;

  /// No description provided for @settings_theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_theme_system;

  /// No description provided for @settings_theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// No description provided for @settings_theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// No description provided for @statistics_total_time.
  ///
  /// In en, this message translates to:
  /// **'Total listening time'**
  String get statistics_total_time;

  /// No description provided for @statistics_play_count.
  ///
  /// In en, this message translates to:
  /// **'Total plays'**
  String get statistics_play_count;

  /// No description provided for @statistics_top_tracks.
  ///
  /// In en, this message translates to:
  /// **'Most played'**
  String get statistics_top_tracks;

  /// No description provided for @statistics_empty.
  ///
  /// In en, this message translates to:
  /// **'No statistics yet'**
  String get statistics_empty;

  /// No description provided for @statistics_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset statistics'**
  String get statistics_reset;

  /// No description provided for @about_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get about_version;

  /// No description provided for @about_developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get about_developer;

  /// No description provided for @about_licenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get about_licenses;

  /// No description provided for @about_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get about_privacy;

  /// No description provided for @about_open_source.
  ///
  /// In en, this message translates to:
  /// **'Open source packages'**
  String get about_open_source;

  /// No description provided for @account_guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get account_guest;

  /// No description provided for @account_signed_out_message.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync, or continue as a guest.'**
  String get account_signed_out_message;

  /// No description provided for @account_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get account_email;

  /// No description provided for @account_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get account_password;

  /// No description provided for @account_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get account_sign_in;

  /// No description provided for @account_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get account_sign_up;

  /// No description provided for @account_sign_in_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get account_sign_in_google;

  /// No description provided for @account_continue_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get account_continue_guest;

  /// No description provided for @account_sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get account_sign_out;

  /// No description provided for @account_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get account_delete;

  /// No description provided for @account_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This cannot be undone.'**
  String get account_delete_confirm;

  /// No description provided for @account_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get account_forgot_password;

  /// No description provided for @account_reset_sent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get account_reset_sent;

  /// No description provided for @account_anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous account'**
  String get account_anonymous;

  /// No description provided for @firebase_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Account features are unavailable because Firebase is not configured.'**
  String get firebase_unavailable;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @settings_color.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get settings_color;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
