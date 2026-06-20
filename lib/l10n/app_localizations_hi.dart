// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get app_title => 'लिरिक्स प्लेयर Lyrics Player';

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
  String get player_shuffle => 'शफ़ल';

  @override
  String get player_loop => 'दोहराएँ';

  @override
  String get player_forward => '5 सेकंड आगे';

  @override
  String get player_rewind => '5 सेकंड पीछे';

  @override
  String get player_speed => 'प्लेबैक गति';

  @override
  String get common_reset => 'रीसेट';

  @override
  String get player_nothing_playing => 'कुछ भी नहीं चल रहा';

  @override
  String get music_import => 'संगीत आयात करें';

  @override
  String get music_search => 'खोजें';

  @override
  String get music_empty => 'कोई संगीत नहीं मिला';

  @override
  String get music_remove => 'हटाएँ';

  @override
  String get music_rescan => 'फिर से स्कैन करें';

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
  String get settings_language_system => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get settings_theme => 'थीम';

  @override
  String get settings_theme_system => 'सिस्टम';

  @override
  String get settings_theme_light => 'लाइट';

  @override
  String get settings_theme_dark => 'डार्क';

  @override
  String get statistics_total_time => 'कुल सुनने का समय';

  @override
  String get statistics_play_count => 'कुल प्ले';

  @override
  String get statistics_top_tracks => 'सबसे ज़्यादा चलाए गए';

  @override
  String get statistics_empty => 'अभी कोई आँकड़े नहीं';

  @override
  String get statistics_reset => 'आँकड़े रीसेट करें';

  @override
  String get statistics_reset_title => 'आँकड़े रीसेट करें?';

  @override
  String get statistics_reset_message =>
      'इस डिवाइस पर सुनने के सभी आँकड़े हटा दिए जाएँगे। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get statistics_reset_message_cloud =>
      'इस डिवाइस और आपके क्लाउड बैकअप पर सुनने के सभी आँकड़े हटा दिए जाएँगे। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get statistics_reset_confirm => 'रीसेट करें';

  @override
  String get statistics_chart_title => 'सुनने का समय';

  @override
  String get statistics_chart_week => 'सप्ताह';

  @override
  String get statistics_chart_month => 'महीना';

  @override
  String get statistics_chart_year => 'वर्ष';

  @override
  String get about_version => 'संस्करण';

  @override
  String get about_developer => 'डेवलपर';

  @override
  String get about_licenses => 'ओपन सोर्स लाइसेंस';

  @override
  String get about_privacy => 'गोपनीयता नीति';

  @override
  String get about_open_source => 'ओपन सोर्स पैकेज';

  @override
  String get account_guest => 'अतिथि';

  @override
  String get account_signed_out_message =>
      'अपने डेटा को डिवाइसों में सिंक करने के लिए साइन इन करें।';

  @override
  String get account_email => 'ईमेल';

  @override
  String get account_password => 'पासवर्ड';

  @override
  String get account_sign_in => 'साइन इन';

  @override
  String get account_sign_up => 'साइन अप';

  @override
  String get account_sign_in_google => 'Google से साइन इन करें';

  @override
  String get account_sign_in_facebook => 'Facebook से साइन इन करें';

  @override
  String get account_method_email => 'ईमेल से साइन इन करें';

  @override
  String get account_method_phone => 'फ़ोन से साइन इन करें';

  @override
  String get account_phone => 'फ़ोन नंबर';

  @override
  String get account_send_code => 'कोड भेजें';

  @override
  String get account_sms_code => 'सत्यापन कोड';

  @override
  String get account_verify_code => 'सत्यापित करें और साइन इन करें';

  @override
  String get account_code_sent =>
      'हमने आपको SMS द्वारा एक सत्यापन कोड भेजा है।';

  @override
  String get account_continue_guest => 'अतिथि के रूप में जारी रखें';

  @override
  String get account_sign_out => 'साइन आउट';

  @override
  String get account_delete => 'खाता हटाएँ';

  @override
  String get account_delete_confirm =>
      'क्या आप वाकई अपना खाता हटाना चाहते हैं? इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get account_delete_data => 'खाता डेटा हटाएँ';

  @override
  String get account_delete_data_confirm =>
      'अपना खाता रखते हुए सभी क्लाउड डेटा हटाएँ? इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get account_delete_data_done => 'आपका खाता डेटा हटा दिया गया है।';

  @override
  String get account_forgot_password => 'पासवर्ड भूल गए?';

  @override
  String get account_reset_sent => 'पासवर्ड रीसेट ईमेल भेजा गया';

  @override
  String get account_anonymous => 'अनाम खाता';

  @override
  String get account_unavailable =>
      'खाता सुविधाएँ अस्थायी रूप से अनुपलब्ध हैं।';

  @override
  String get common_cancel => 'रद्द करें';

  @override
  String get common_confirm => 'पुष्टि करें';

  @override
  String get common_ok => 'ठीक है';

  @override
  String get common_delete => 'हटाएँ';

  @override
  String get common_retry => 'पुनः प्रयास करें';

  @override
  String get settings_color => 'थीम रंग';

  @override
  String get settings_gradient => 'ग्रेडिएंट थीम';

  @override
  String get settings_gradient_desc =>
      'प्लेयर में थीम-रंग वाली ग्रेडिएंट पृष्ठभूमि का उपयोग करें';

  @override
  String get lyrics_import => 'बोल आयात करें';

  @override
  String get lyrics_import_success => 'बोल आयात किए गए';

  @override
  String get lyrics_import_failed => 'बोल आयात नहीं किए जा सके';

  @override
  String get lyrics_import_too_large => 'बोल फ़ाइल बहुत बड़ी है';

  @override
  String get lyrics_import_empty => 'इस फ़ाइल में कोई बोल नहीं मिला';

  @override
  String get lyrics_empty => 'इस ट्रैक के लिए अभी कोई बोल नहीं';

  @override
  String get lyrics_reimport => 'फिर से आयात करें';

  @override
  String get lyrics_delete => 'बोल हटाएँ';

  @override
  String get lyrics_delete_confirm => 'इस ट्रैक के बोल हटाएँ?';

  @override
  String get lyrics_show => 'बोल दिखाएँ';

  @override
  String get lyrics_hide => 'आर्टवर्क दिखाएँ';

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
  String get lyrics_font_size => 'फ़ॉन्ट आकार';

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
