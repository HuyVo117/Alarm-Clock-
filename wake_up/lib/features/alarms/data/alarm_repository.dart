import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/alarm_model.dart';

/// Repository quản lý CRUD báo thức qua Drift database.
class AlarmRepository {
  final AppDatabase _db;

  AlarmRepository(this._db);

  /// Lấy tất cả báo thức, sắp xếp theo giờ
  Future<List<AlarmModel>> getAllAlarms() async {
    final query = _db.select(_db.alarms)
      ..orderBy([(t) => OrderingTerm.asc(t.time)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  /// Stream theo dõi thay đổi danh sách báo thức
  Stream<List<AlarmModel>> watchAllAlarms() {
    final query = _db.select(_db.alarms)
      ..orderBy([(t) => OrderingTerm.asc(t.time)]);
    return query.watch().map(
      (rows) => rows.map(_toModel).toList(),
    );
  }

  /// Lấy một báo thức theo ID
  Future<AlarmModel?> getAlarmById(int id) async {
    final query = _db.select(_db.alarms)
      ..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  /// Lấy tất cả báo thức đang bật
  Future<List<AlarmModel>> getEnabledAlarms() async {
    final query = _db.select(_db.alarms)
      ..where((t) => t.enabled.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.time)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  /// Thêm báo thức mới, trả về ID
  Future<int> insertAlarm(AlarmModel alarm) async {
    return _db.into(_db.alarms).insert(
      AlarmsCompanion.insert(
        time: alarm.time,
        repeatDays: Value(alarm.repeatDaysToJson()),
        label: Value(alarm.label),
        mode: Value(alarm.mode.name),
        soundId: Value(alarm.soundId),
        mediaId: Value(alarm.mediaId),
        mediaPath: Value(alarm.mediaPath),
        soundPath: Value(alarm.soundPath),
        snoozeIntervalMinutes: Value(alarm.snoozeIntervalMinutes),
        snoozeMaxCount: Value(alarm.snoozeMaxCount),
        challenges: Value(alarm.challengesToJson()),
        timezone: Value(alarm.timezone),
        enabled: Value(alarm.enabled),
      ),
    );
  }

  /// Cập nhật báo thức
  Future<bool> updateAlarm(AlarmModel alarm) async {
    assert(alarm.id != null, 'Alarm ID không được null khi update');
    return _db.update(_db.alarms).replace(
      AlarmsCompanion(
        id: Value(alarm.id!),
        time: Value(alarm.time),
        repeatDays: Value(alarm.repeatDaysToJson()),
        label: Value(alarm.label),
        mode: Value(alarm.mode.name),
        soundId: Value(alarm.soundId),
        mediaId: Value(alarm.mediaId),
        mediaPath: Value(alarm.mediaPath),
        soundPath: Value(alarm.soundPath),
        snoozeIntervalMinutes: Value(alarm.snoozeIntervalMinutes),
        snoozeMaxCount: Value(alarm.snoozeMaxCount),
        challenges: Value(alarm.challengesToJson()),
        timezone: Value(alarm.timezone),
        enabled: Value(alarm.enabled),
      ),
    );
  }

  /// Bật/tắt báo thức
  Future<void> toggleAlarm(int id, bool enabled) async {
    await (_db.update(_db.alarms)..where((t) => t.id.equals(id)))
        .write(AlarmsCompanion(enabled: Value(enabled)));
  }

  /// Xóa báo thức
  Future<void> deleteAlarm(int id) async {
    await (_db.delete(_db.alarms)..where((t) => t.id.equals(id))).go();
  }

  /// Chuyển Drift row sang domain model
  AlarmModel _toModel(Alarm row) {
    return AlarmModel(
      id: row.id,
      time: row.time,
      repeatDays: AlarmModel.repeatDaysFromJson(row.repeatDays),
      label: row.label,
      mode: row.mode == 'deep' ? WakeMode.deep : WakeMode.normal,
      soundId: row.soundId,
      mediaId: row.mediaId,
      mediaPath: row.mediaPath,
      soundPath: row.soundPath,
      snoozeIntervalMinutes: row.snoozeIntervalMinutes,
      snoozeMaxCount: row.snoozeMaxCount,
      challenges: AlarmModel.challengesFromJson(row.challenges),
      timezone: row.timezone,
      enabled: row.enabled,
    );
  }
}
