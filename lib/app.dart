import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/sync/sync_service.dart';
import 'core/update/app_update_listener.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'shared/providers/settings_controller.dart';
import 'shared/theme/app_theme.dart';

class SeekPlayerApp extends ConsumerWidget {
  const SeekPlayerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 啟動雲端同步（App 啟動 / 登入時依條件上傳或還原）。
    ref.watch(syncServiceProvider);
    final settings = ref.watch(settingsControllerProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.app_title,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings.locale,
      theme: AppTheme.light(settings.seedColor),
      darkTheme: AppTheme.dark(settings.seedColor),
      themeMode: settings.themeMode,
      routerConfig: router,
      // 更新提示:Google Play 新版本優先,其次 Shorebird patch 重啟提示。
      builder: (context, child) => AppUpdateListener(child: child!),
    );
  }
}
