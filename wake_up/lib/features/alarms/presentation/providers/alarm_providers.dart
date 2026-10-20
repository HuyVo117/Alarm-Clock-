import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../data/alarm_repository.dart';
import '../domain/alarm_model.dart';

part 'alarm_providers.g.dart';

/// Provider cho AppDatabase (singleton)
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

/// Provider cho AlarmRepository
@Riverpod(keepAlive: true)
AlarmRepository alarmRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AlarmRepository(db);
}

/// Provider stream cho danh sách báo thức
@riverpod
Stream<List<AlarmModel>> alarmList(Ref ref) {
  final repo = ref.watch(alarmRepositoryProvider);
  return repo.watchAllAlarms();
}
