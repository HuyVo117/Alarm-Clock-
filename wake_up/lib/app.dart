import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget của app Wake Up.
class WakeUpApp extends StatelessWidget {
  const WakeUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'Wake Up',
      theme: AppTheme.cupertinoTheme,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      debugShowCheckedModeBanner: false,
    );
  }
}
