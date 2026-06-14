// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get app_title => '時間位移播放器';

  @override
  String get tab_music_list => '音樂';

  @override
  String get tab_player => '播放器';

  @override
  String get tab_profile => '我的';

  @override
  String get profile_account => '帳戶';

  @override
  String get profile_statistics => '統計數據';

  @override
  String get profile_settings => '設定';

  @override
  String get profile_about => '關於';

  @override
  String get player_play => '播放';

  @override
  String get player_pause => '暫停';

  @override
  String get player_next => '下一首';

  @override
  String get player_previous => '上一首';

  @override
  String get player_shuffle => 'Shuffle';

  @override
  String get player_loop => 'Repeat';

  @override
  String get player_forward => '快進5秒';

  @override
  String get player_rewind => '快退5秒';

  @override
  String get player_speed => '播放速度';

  @override
  String get player_speed_reset => '重設';

  @override
  String get player_nothing_playing => 'Nothing playing';

  @override
  String get music_import => '匯入音樂';

  @override
  String get music_search => '搜尋';

  @override
  String get music_empty => '尚無音樂，點擊重新掃描以載入裝置音樂。';

  @override
  String get music_remove => 'Remove';

  @override
  String get music_rescan => '重新掃描';

  @override
  String get permission_title => '需要儲存權限';

  @override
  String get permission_message => '我們需要存取您的音訊檔案以掃描並播放本機音樂。';

  @override
  String get permission_allow => '允許';

  @override
  String get permission_deny => '暫不';

  @override
  String get permission_open_settings => '前往設定';

  @override
  String get settings_language => '語言';

  @override
  String get settings_language_system => 'System default';

  @override
  String get settings_theme => '主題';

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
  String get statistics_reset_title => 'Reset statistics?';

  @override
  String get statistics_reset_message =>
      'All listening statistics on this device will be deleted. This cannot be undone.';

  @override
  String get statistics_reset_message_cloud =>
      'All listening statistics on this device and your cloud backup will be deleted. This cannot be undone.';

  @override
  String get statistics_reset_confirm => 'Reset';

  @override
  String get statistics_chart_title => 'Listening time';

  @override
  String get statistics_chart_week => 'Week';

  @override
  String get statistics_chart_month => 'Month';

  @override
  String get statistics_chart_year => 'Year';

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
      'Sign in to sync your data across devices.';

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
  String get account_sign_in_facebook => 'Sign in with Facebook';

  @override
  String get account_method_email => 'Sign in with email';

  @override
  String get account_method_phone => 'Sign in with phone';

  @override
  String get account_phone => 'Phone number';

  @override
  String get account_send_code => 'Send code';

  @override
  String get account_sms_code => 'Verification code';

  @override
  String get account_verify_code => 'Verify and sign in';

  @override
  String get account_code_sent => 'We\'ve texted you a verification code.';

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
  String get account_delete_data => 'Delete account data';

  @override
  String get account_delete_data_confirm =>
      'Delete all your cloud data while keeping your account? This cannot be undone.';

  @override
  String get account_delete_data_done => 'Your account data has been deleted.';

  @override
  String get account_forgot_password => 'Forgot password?';

  @override
  String get account_reset_sent => 'Password reset email sent';

  @override
  String get account_anonymous => 'Anonymous account';

  @override
  String get account_unavailable =>
      'Account features are temporarily unavailable.';

  @override
  String get common_cancel => '取消';

  @override
  String get common_confirm => '確定';

  @override
  String get common_ok => 'OK';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_retry => 'Retry';

  @override
  String get settings_color => '主題顏色';

  @override
  String get lyrics_import => 'Import lyrics';

  @override
  String get lyrics_import_success => 'Lyrics imported';

  @override
  String get lyrics_import_failed => 'Couldn\'t import lyrics';

  @override
  String get lyrics_import_too_large => 'Lyrics file is too large';

  @override
  String get lyrics_import_empty => 'No lyrics found in this file';

  @override
  String get lyrics_empty => 'No lyrics for this track yet';

  @override
  String get lyrics_reimport => 'Re-import';

  @override
  String get lyrics_delete => 'Delete lyrics';

  @override
  String get lyrics_delete_confirm => 'Delete lyrics for this track?';

  @override
  String get lyrics_show => 'Show lyrics';

  @override
  String get lyrics_hide => 'Show artwork';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get app_title => '时间位移播放器';

  @override
  String get tab_music_list => '音乐';

  @override
  String get tab_player => '播放器';

  @override
  String get tab_profile => '我的';

  @override
  String get profile_account => '账户';

  @override
  String get profile_statistics => '统计数据';

  @override
  String get profile_settings => '设置';

  @override
  String get profile_about => '关于';

  @override
  String get player_play => '播放';

  @override
  String get player_pause => '暂停';

  @override
  String get player_next => '下一首';

  @override
  String get player_previous => '上一首';

  @override
  String get player_shuffle => '随机播放';

  @override
  String get player_loop => '循环播放';

  @override
  String get player_forward => '快进5秒';

  @override
  String get player_rewind => '快退5秒';

  @override
  String get player_speed => '播放速度';

  @override
  String get player_speed_reset => '重置';

  @override
  String get player_nothing_playing => '当前没有正在播放的曲目';

  @override
  String get music_import => '导入音乐';

  @override
  String get music_search => '搜索';

  @override
  String get music_empty => '找不到音乐，点击重新扫描以加载设备音乐。';

  @override
  String get music_remove => '移除';

  @override
  String get music_rescan => '重新扫描';

  @override
  String get permission_title => '需要存储权限';

  @override
  String get permission_message => '我们需要访问您的音频文件以扫描并播放本地音乐。';

  @override
  String get permission_allow => '允许';

  @override
  String get permission_deny => '暂不';

  @override
  String get permission_open_settings => '前往设置';

  @override
  String get settings_language => '语言';

  @override
  String get settings_language_system => '跟随系统';

  @override
  String get settings_theme => '主题';

  @override
  String get settings_theme_system => '跟随系统';

  @override
  String get settings_theme_light => '浅色';

  @override
  String get settings_theme_dark => '深色';

  @override
  String get statistics_total_time => '总收听时长';

  @override
  String get statistics_play_count => '总播放次数';

  @override
  String get statistics_top_tracks => '最常收听';

  @override
  String get statistics_empty => '暂无统计数据';

  @override
  String get statistics_reset => '重置统计数据';

  @override
  String get statistics_reset_title => '重置统计数据？';

  @override
  String get statistics_reset_message => '将删除此设备上的所有收听统计，此操作无法撤销。';

  @override
  String get statistics_reset_message_cloud => '将删除此设备上的所有收听统计与云端备份，此操作无法撤销。';

  @override
  String get statistics_reset_confirm => '重置';

  @override
  String get statistics_chart_title => '收听时长';

  @override
  String get statistics_chart_week => '周';

  @override
  String get statistics_chart_month => '月';

  @override
  String get statistics_chart_year => '年';

  @override
  String get about_version => '版本';

  @override
  String get about_developer => '开发者';

  @override
  String get about_licenses => '开源许可';

  @override
  String get about_privacy => '隐私政策';

  @override
  String get about_open_source => '开源依赖';

  @override
  String get account_guest => '访客';

  @override
  String get account_signed_out_message => '登录以在不同设备间同步你的数据。';

  @override
  String get account_email => '电子邮件';

  @override
  String get account_password => '密码';

  @override
  String get account_sign_in => '登录';

  @override
  String get account_sign_up => '注册';

  @override
  String get account_sign_in_google => '使用 Google 登录';

  @override
  String get account_sign_in_facebook => '使用 Facebook 登录';

  @override
  String get account_method_email => '使用 Email 登录';

  @override
  String get account_method_phone => '使用手机号码登录';

  @override
  String get account_phone => '手机号码';

  @override
  String get account_send_code => '发送验证码';

  @override
  String get account_sms_code => '验证码';

  @override
  String get account_verify_code => '验证并登录';

  @override
  String get account_code_sent => '已将验证码以短信发送到你的手机。';

  @override
  String get account_continue_guest => '以访客身份继续';

  @override
  String get account_sign_out => '退出登录';

  @override
  String get account_delete => '删除账号';

  @override
  String get account_delete_confirm => '确定要删除账号吗？此操作无法撤销。';

  @override
  String get account_delete_data => '删除账号数据';

  @override
  String get account_delete_data_confirm => '确定要删除你的所有云端数据但保留账号吗？此操作无法撤销。';

  @override
  String get account_delete_data_done => '你的账号数据已删除。';

  @override
  String get account_forgot_password => '忘记密码？';

  @override
  String get account_reset_sent => '已发送密码重置邮件';

  @override
  String get account_anonymous => '匿名账号';

  @override
  String get account_unavailable => '账户功能暂时不可用。';

  @override
  String get common_cancel => '取消';

  @override
  String get common_confirm => '确定';

  @override
  String get common_ok => '好';

  @override
  String get common_delete => '删除';

  @override
  String get common_retry => '重试';

  @override
  String get settings_color => '主题颜色';

  @override
  String get lyrics_import => '导入歌词';

  @override
  String get lyrics_import_success => '歌词已导入';

  @override
  String get lyrics_import_failed => '无法导入歌词';

  @override
  String get lyrics_import_too_large => '歌词文件太大';

  @override
  String get lyrics_import_empty => '这个文件没有歌词内容';

  @override
  String get lyrics_empty => '尚未导入这首歌的歌词';

  @override
  String get lyrics_reimport => '重新导入';

  @override
  String get lyrics_delete => '删除歌词';

  @override
  String get lyrics_delete_confirm => '要删除这首歌的歌词吗?';

  @override
  String get lyrics_show => '显示歌词';

  @override
  String get lyrics_hide => '显示封面';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get app_title => '時間位移播放器';

  @override
  String get tab_music_list => '音樂';

  @override
  String get tab_player => '播放器';

  @override
  String get tab_profile => '我的';

  @override
  String get profile_account => '帳戶';

  @override
  String get profile_statistics => '統計數據';

  @override
  String get profile_settings => '設定';

  @override
  String get profile_about => '關於';

  @override
  String get player_play => '播放';

  @override
  String get player_pause => '暫停';

  @override
  String get player_next => '下一首';

  @override
  String get player_previous => '上一首';

  @override
  String get player_shuffle => '隨機播放';

  @override
  String get player_loop => '循環播放';

  @override
  String get player_forward => '快進5秒';

  @override
  String get player_rewind => '快退5秒';

  @override
  String get player_speed => '播放速度';

  @override
  String get player_speed_reset => '重設';

  @override
  String get player_nothing_playing => '目前沒有播放中的曲目';

  @override
  String get music_import => '匯入音樂';

  @override
  String get music_search => '搜尋';

  @override
  String get music_empty => '找不到音樂，點擊重新掃描以載入裝置音樂。';

  @override
  String get music_remove => '移除';

  @override
  String get music_rescan => '重新掃描';

  @override
  String get permission_title => '需要儲存權限';

  @override
  String get permission_message => '我們需要存取您的音訊檔案以掃描並播放本機音樂。';

  @override
  String get permission_allow => '允許';

  @override
  String get permission_deny => '暫不';

  @override
  String get permission_open_settings => '前往設定';

  @override
  String get settings_language => '語言';

  @override
  String get settings_language_system => '跟隨系統';

  @override
  String get settings_theme => '主題';

  @override
  String get settings_theme_system => '跟隨系統';

  @override
  String get settings_theme_light => '淺色';

  @override
  String get settings_theme_dark => '深色';

  @override
  String get statistics_total_time => '總聆聽時長';

  @override
  String get statistics_play_count => '總播放次數';

  @override
  String get statistics_top_tracks => '最常聆聽';

  @override
  String get statistics_empty => '尚無統計數據';

  @override
  String get statistics_reset => '重設統計數據';

  @override
  String get statistics_reset_title => '重設統計數據？';

  @override
  String get statistics_reset_message => '將刪除此裝置上的所有聆聽統計，此操作無法復原。';

  @override
  String get statistics_reset_message_cloud => '將刪除此裝置上的所有聆聽統計與雲端備份，此操作無法復原。';

  @override
  String get statistics_reset_confirm => '重設';

  @override
  String get statistics_chart_title => '聆聽時長';

  @override
  String get statistics_chart_week => '週';

  @override
  String get statistics_chart_month => '月';

  @override
  String get statistics_chart_year => '年';

  @override
  String get about_version => '版本';

  @override
  String get about_developer => '開發者';

  @override
  String get about_licenses => '開源授權';

  @override
  String get about_privacy => '隱私權政策';

  @override
  String get about_open_source => '開源套件';

  @override
  String get account_guest => '訪客';

  @override
  String get account_signed_out_message => '登入以在不同裝置間同步你的資料。';

  @override
  String get account_email => '電子郵件';

  @override
  String get account_password => '密碼';

  @override
  String get account_sign_in => '登入';

  @override
  String get account_sign_up => '註冊';

  @override
  String get account_sign_in_google => '使用 Google 登入';

  @override
  String get account_sign_in_facebook => '使用 Facebook 登入';

  @override
  String get account_method_email => '使用 Email 登入';

  @override
  String get account_method_phone => '使用手機號碼登入';

  @override
  String get account_phone => '手機號碼';

  @override
  String get account_send_code => '傳送驗證碼';

  @override
  String get account_sms_code => '驗證碼';

  @override
  String get account_verify_code => '驗證並登入';

  @override
  String get account_code_sent => '已將驗證碼以簡訊傳送到你的手機。';

  @override
  String get account_continue_guest => '以訪客身分繼續';

  @override
  String get account_sign_out => '登出';

  @override
  String get account_delete => '刪除帳號';

  @override
  String get account_delete_confirm => '確定要刪除帳號嗎？此操作無法復原。';

  @override
  String get account_delete_data => '刪除帳號資料';

  @override
  String get account_delete_data_confirm => '確定要刪除你的所有雲端資料但保留帳號嗎？此操作無法復原。';

  @override
  String get account_delete_data_done => '你的帳號資料已刪除。';

  @override
  String get account_forgot_password => '忘記密碼？';

  @override
  String get account_reset_sent => '已寄出密碼重設信';

  @override
  String get account_anonymous => '匿名帳號';

  @override
  String get account_unavailable => '帳戶功能暫時無法使用。';

  @override
  String get common_cancel => '取消';

  @override
  String get common_confirm => '確定';

  @override
  String get common_ok => '好';

  @override
  String get common_delete => '刪除';

  @override
  String get common_retry => '重試';

  @override
  String get settings_color => '主題顏色';

  @override
  String get lyrics_import => '匯入歌詞';

  @override
  String get lyrics_import_success => '歌詞已匯入';

  @override
  String get lyrics_import_failed => '無法匯入歌詞';

  @override
  String get lyrics_import_too_large => '歌詞檔案太大';

  @override
  String get lyrics_import_empty => '這個檔案沒有歌詞內容';

  @override
  String get lyrics_empty => '尚未匯入這首歌的歌詞';

  @override
  String get lyrics_reimport => '重新匯入';

  @override
  String get lyrics_delete => '刪除歌詞';

  @override
  String get lyrics_delete_confirm => '要刪除這首歌的歌詞嗎?';

  @override
  String get lyrics_show => '顯示歌詞';

  @override
  String get lyrics_hide => '顯示封面';
}
