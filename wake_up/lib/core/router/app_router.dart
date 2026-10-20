import 'package:flutter/cupertino.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../features/alarms/presentation/alarm_edit_screen.dart';
import '../../features/alarms/presentation/alarm_list_screen.dart';
import '../../features/alarms/presentation/alarm_ringing_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/bedtime/presentation/bedtime_screen.dart';
import '../../features/garden/presentation/garden_screen.dart';
import '../../features/world_clock/presentation/world_clock_screen.dart';
import '../theme/app_theme.dart';

/// Các route paths
class AppRoutes {
  static const String worldClock = '/world-clock';
  static const String alarms = '/alarms';
  static const String bedtime = '/bedtime';
  static const String garden = '/garden';
  static const String analytics = '/analytics';
  static const String alarmEdit = '/alarms/edit';
  static const String alarmRinging = '/alarm-ringing';
}

/// Router chính dùng go_router với CupertinoTabBar 5 mục.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.alarms,
  routes: [
    // Shell route cho tab bar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _MainTabScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Thế giới
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.worldClock,
              builder: (context, state) {
                final l10n = AppLocalizations.of(context)!;
                return PlaceholderScreen(
                  title: l10n.worldClockTitle,
                  icon: CupertinoIcons.globe,
                );
              },
            ),
          ],
        ),
        // Tab 2: Báo thức
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.alarms,
              builder: (context, state) => const AlarmListScreen(),
            ),
          ],
        ),
        // Tab 3: Giờ ngủ
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.bedtime,
              builder: (context, state) => const BedtimeScreen(),
            ),
          ],
        ),
        // Tab 4: Khu vườn
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.garden,
              builder: (context, state) => const GardenScreen(),
            ),
          ],
        ),
        // Tab 5: Thống kê
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.analytics,
              builder: (context, state) => const AnalyticsScreen(),
            ),
          ],
        ),
      ],
    ),
    // Route ngoài tab: thêm/sửa báo thức
    GoRoute(
      path: AppRoutes.alarmEdit,
      builder: (context, state) {
        final alarmId = state.uri.queryParameters['id'];
        return AlarmEditScreen(
          alarmId: alarmId != null ? int.tryParse(alarmId) : null,
        );
      },
    ),
    // Route ngoài tab: màn hình báo thức reo
    GoRoute(
      path: AppRoutes.alarmRinging,
      builder: (context, state) {
        final alarmId = int.parse(
          state.uri.queryParameters['id'] ?? '0',
        );
        return AlarmRingingScreen(alarmId: alarmId);
      },
    ),
  ],
);

/// Scaffold chính với CupertinoTabBar 5 mục, giống app Đồng hồ iPhone.
class _MainTabScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainTabScaffold({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        backgroundColor: AppTheme.backgroundBlack.withValues(alpha: 0.9),
        activeColor: AppTheme.accentOrange,
        inactiveColor: AppTheme.labelTertiary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.globe),
            label: l10n.tabWorldClock,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.alarm_fill),
            label: l10n.tabAlarm,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.moon_fill),
            label: l10n.tabBedtime,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.tree),
            label: l10n.tabGarden,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chart_bar_fill),
            label: l10n.tabAnalytics,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return navigationShell;
      },
    );
  }
}
