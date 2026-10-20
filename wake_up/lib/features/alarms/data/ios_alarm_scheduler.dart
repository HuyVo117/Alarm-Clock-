import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../core/platform/alarm_scheduler.dart';
import '../domain/next_alarm_calculator.dart';
import 'alarm_repository.dart';

/// Cài đặt AlarmScheduler cho iOS.
/// - iOS 26+: dùng flutter_alarmkit (AlarmKit).
/// - iOS < 26: hiển thị thông báo "chưa hỗ trợ", không crash.
///
/// Lưu ý: Build và test iOS cần Mac với Xcode. Trên Windows, file này
/// sẽ compile nhưng không thể test thực tế.
class IosAlarmScheduler implements AlarmScheduler {
  final AlarmRepository _repository;

  IosAlarmScheduler(this._repository);

  /// Kiểm tra iOS version có >= 26 không.
  bool get _isIos26OrAbove {
    if (!Platform.isIOS) return false;
    // TODO: Kiểm tra iOS version thực tế khi build trên Mac
    return true;
  }

  @override
  Future<void> scheduleAlarm({
    required int alarmId,
    required DateTime scheduledTime,
    required String label,
    String? soundPath,
  }) async {
    if (!_isIos26OrAbove) {
      debugPrint('[IosAlarmScheduler] iOS < 26: không hỗ trợ báo thức');
      return;
    }

    // TODO: Tích hợp flutter_alarmkit khi build trên Mac
    debugPrint(
      '[IosAlarmScheduler] Đã lên lịch alarm #$alarmId lúc $scheduledTime với sound $soundPath '
      '(TODO: cần tích hợp AlarmKit trên Mac)',
    );
  }

  @override
  Future<void> cancelAlarm(int alarmId) async {
    if (!_isIos26OrAbove) return;
    debugPrint('[IosAlarmScheduler] Đã hủy alarm #$alarmId');
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
          soundPath: alarm.soundPath,
        );
      } else {
        await _repository.toggleAlarm(alarm.id!, false);
      }
    }
    debugPrint('[IosAlarmScheduler] Đã reschedule ${alarms.length} báo thức');
  }

  @override
  Future<bool> hasRequiredPermissions() async {
    if (!_isIos26OrAbove) return false;
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    if (!_isIos26OrAbove) return false;
    return true;
  }
}
