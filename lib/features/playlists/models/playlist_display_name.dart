import '../../../l10n/app_localizations.dart';
import 'playlist_entity.dart';

/// 清單顯示名稱:我的最愛永遠顯示在地化字串(忽略 DB 內存的 fallback 名),
/// 其餘用使用者命名。
String playlistDisplayName(PlaylistEntity playlist, AppLocalizations l10n) =>
    playlist.isFavorites ? l10n.playlist_favorites : playlist.name;
