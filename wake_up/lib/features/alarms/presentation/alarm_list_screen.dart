import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/alarm_model.dart';
import '../domain/next_alarm_calculator.dart';
import 'providers/alarm_providers.dart';
import 'widgets/alarm_tile.dart';

/// Danh sách báo thức chính, giống giao diện app Đồng hồ iPhone.
class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({super.key});

  @override
  ConsumerState<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alarmsAsync = ref.watch(alarmListProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() => _isEditing = !_isEditing);
          },
          child: Text(
            _isEditing ? l10n.done : l10n.edit,
            style: const TextStyle(color: AppTheme.accentOrange),
          ),
        ),
        middle: Text(l10n.alarmListTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            context.push(AppRoutes.alarmEdit);
          },
          child: const Icon(
            CupertinoIcons.add,
            color: AppTheme.accentOrange,
          ),
        ),
      ),
      child: SafeArea(
        child: alarmsAsync.when(
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: AppTheme.destructiveRed),
            ),
          ),
          data: (alarms) {
            if (alarms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.alarm,
                      size: 64,
                      color: AppTheme.labelTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noAlarms,
                      style: const TextStyle(
                        color: AppTheme.labelSecondary,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              );
            }

            return _buildAlarmList(alarms, l10n);
          },
        ),
      ),
    );
  }

  Widget _buildAlarmList(List<AlarmModel> alarms, AppLocalizations l10n) {
    // Hiển thị thời gian đến báo thức gần nhất
    final now = DateTime.now();
    final nextAlarmTime = _findNextAlarmTime(alarms, now);

    return ListView(
      children: [
        // Hiển thị "Báo thức sau Xg Yp"
        if (nextAlarmTime != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildNextAlarmBanner(nextAlarmTime, now, l10n),
          ),
        // Danh sách báo thức
        ...alarms.map(
          (alarm) => AlarmTile(
            alarm: alarm,
            isEditing: _isEditing,
            onToggle: (enabled) => _toggleAlarm(alarm, enabled),
            onTap: () => _editAlarm(alarm),
            onDelete: () => _deleteAlarm(alarm),
          ),
        ),
      ],
    );
  }

  Widget _buildNextAlarmBanner(
    DateTime nextAlarm,
    DateTime now,
    AppLocalizations l10n,
  ) {
    final diff = nextAlarm.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.bell_fill,
            color: AppTheme.accentOrange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.alarmIn(hours, minutes),
            style: const TextStyle(
              color: AppTheme.labelSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _findNextAlarmTime(List<AlarmModel> alarms, DateTime now) {
    DateTime? nearest;
    for (final alarm in alarms) {
      if (!alarm.enabled) continue;
      final next = NextAlarmCalculator.nextAlarm(
        alarmTime: alarm.time,
        repeatDays: alarm.repeatDays,
        now: now,
      );
      if (next != null && (nearest == null || next.isBefore(nearest))) {
        nearest = next;
      }
    }
    return nearest;
  }

  Future<void> _toggleAlarm(AlarmModel alarm, bool enabled) async {
    final repo = ref.read(alarmRepositoryProvider);
    final scheduler = ref.read(alarmSchedulerProvider);
    await repo.toggleAlarm(alarm.id!, enabled);
    if (enabled) {
      final next = NextAlarmCalculator.nextAlarm(
        alarmTime: alarm.time,
        repeatDays: alarm.repeatDays,
        now: DateTime.now(),
      );
      if (next != null) {
        await scheduler.scheduleAlarm(
          alarmId: alarm.id!,
          scheduledTime: next,
          label: alarm.label,
        );
      }
    } else {
      await scheduler.cancelAlarm(alarm.id!);
    }
  }

  void _editAlarm(AlarmModel alarm) {
    context.push('${AppRoutes.alarmEdit}?id=${alarm.id}');
  }

  Future<void> _deleteAlarm(AlarmModel alarm) async {
    final repo = ref.read(alarmRepositoryProvider);
    final scheduler = ref.read(alarmSchedulerProvider);
    await repo.deleteAlarm(alarm.id!);
    await scheduler.cancelAlarm(alarm.id!);
  }
}
