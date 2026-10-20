import 'package:alarm/alarm.dart' as alarm_pkg;
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/platform/alarm_scheduler.dart';
import '../domain/next_alarm_calculator.dart';
import 'alarm_repository.dart';

/// Cài đặt AlarmScheduler cho Android, dùng package `alarm`.
/// Hỗ trợ: foreground service, exact alarm, full-screen intent,
/// tự đặt lại sau reboot.
class AndroidAlarmScheduler implements AlarmScheduler {
  final AlarmRepository _repository;

  AndroidAlarmScheduler(this._repository);

  @override
  Future<void> scheduleAlarm({
    required int alarmId,
    required DateTime scheduledTime,
    required String label,
  }) async {
    final alarmSettings = alarm_pkg.AlarmSettings(
      id: alarmId,
      dateTime: scheduledTime,
      assetAudioPath: 'assets/audio/alarm.mp3',
      notificationSettings: alarm_pkg.NotificationSettings(
        title: 'Wake Up',
        body: label.isNotEmpty ? label : 'Báo thức',
        stopButton: 'Dừng',
      ),
      loopAudio: true,
      vibrate: true,
      volumeSettings: alarm_pkg.VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: const Duration(seconds: 5),
      ),
      warningNotificationOnKill: true,
      androidStopAlarmOnTermination: false,
    );

    await alarm_pkg.Alarm.set(alarmSettings: alarmSettings);
    debugPrint('[AndroidAlarmScheduler] Đã lên lịch alarm #$alarmId lúc $scheduledTime');
  }

  @override
  Future<void> cancelAlarm(int alarmId) async {
    await alarm_pkg.Alarm.stop(alarmId);
    debugPrint('[AndroidAlarmScheduler] Đã hủy alarm #$alarmId');
  }

  @override
  Future<void> rescheduleAll() async {
    final alarms = await _repository.getEnabledAlarms();
    final now = DateTime.now();

    for (final alarm in alarms) {
      final nextTime = NextAlarmCalculator.nextAlarm(
        alarmTime: alarm.time,
        repeatDays: alarm.repeatDays,
        now: now,
      );

      if (nextTime != null) {
        await scheduleAlarm(
          alarmId: alarm.id!,
          scheduledTime: nextTime,
          label: alarm.label,
        );
      } else {
        await _repository.toggleAlarm(alarm.id!, false);
      }
    }
    debugPrint('[AndroidAlarmScheduler] Đã reschedule ${alarms.length} báo thức');
  }

  @override
  Future<bool> hasRequiredPermissions() async {
    final notif = await Permission.notification.isGranted;
    final exact = await Permission.scheduleExactAlarm.isGranted;
    return notif && exact;
  }

  @override
  Future<bool> requestPermissions() async {
    final notifStatus = await Permission.notification.request();
    final exactStatus = await Permission.scheduleExactAlarm.request();
    if (!await Permission.ignoreBatteryOptimizations.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }
    return notifStatus.isGranted && exactStatus.isGranted;
  }
}
