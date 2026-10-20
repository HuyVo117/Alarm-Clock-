import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/alarms/presentation/providers/alarm_providers.dart';

/// Root widget của app Wake Up.
class WakeUpApp extends ConsumerStatefulWidget {
  const WakeUpApp({super.key});

  @override
  ConsumerState<WakeUpApp> createState() => _WakeUpAppState();
}

class _WakeUpAppState extends ConsumerState<WakeUpApp> {
  StreamSubscription<dynamic>? _ringSubscription;

  @override
  void initState() {
    super.initState();
    // Yêu cầu quyền thông báo & báo thức
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(alarmSchedulerProvider).requestPermissions();
    });

    // Lắng nghe chuông kêu để tự động chuyển màn hình
    _ringSubscription = Alarm.ringing.listen((alarms) {
      if (alarms.alarms.isNotEmpty) {
        appRouter.push('${AppRoutes.alarmRinging}?id=${alarms.alarms.first.id}');
      }
    });
  }

  @override
  void dispose() {
    _ringSubscription?.cancel();
    super.dispose();
  }

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
