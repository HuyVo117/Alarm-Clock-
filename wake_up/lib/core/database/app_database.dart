import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/alarm_table.dart';

part 'app_database.g.dart';

/// Database chính của app Wake Up.
/// Sử dụng Drift (SQLite) để lưu trữ cục bộ.
@DriftDatabase(tables: [Alarms])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor cho testing
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(alarms, alarms.mediaPath);
      }
      if (from < 3) {
        await m.addColumn(alarms, alarms.soundPath);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'wake_up_db');
  }
}
