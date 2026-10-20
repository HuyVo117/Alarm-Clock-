import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wake_up/core/database/app_database.dart';
import 'package:wake_up/core/platform/alarm_scheduler.dart';
import 'package:wake_up/features/alarms/data/alarm_repository.dart';
import 'package:wake_up/features/alarms/data/android_alarm_scheduler.dart';
import 'package:wake_up/features/alarms/data/ios_alarm_scheduler.dart';
import 'package:wake_up/features/alarms/domain/alarm_model.dart';

/// Provider cho AppDatabase (singleton)
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider cho AlarmRepository
final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AlarmRepository(db);
});

/// Provider cho AlarmScheduler (chọn theo platform)
final alarmSchedulerProvider = Provider<AlarmScheduler>((ref) {
  final repo = ref.watch(alarmRepositoryProvider);
  if (defaultTargetPlatform == TargetPlatform.android) {
    return AndroidAlarmScheduler(repo);
  } else {
    return IosAlarmScheduler(repo);
  }
});

/// Provider stream cho danh sách báo thức
final alarmListProvider = StreamProvider<List<AlarmModel>>((ref) {
  final repo = ref.watch(alarmRepositoryProvider);
  return repo.watchAllAlarms();
});
