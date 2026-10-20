import 'package:drift/drift.dart';

/// Bảng Alarm theo mô hình dữ liệu trong PLAN.md mục 6.
/// Các trường chưa dùng ở GĐ1 để nullable.
class Alarms extends Table {
  /// ID tự tăng
  IntColumn get id => integer().autoIncrement()();

  /// Giờ báo thức (UTC timestamp)
  DateTimeColumn get time => dateTime()();

  /// Các ngày lặp lại, lưu dạng JSON array, ví dụ: [1,2,3] = Thứ 2, 3, 4
  /// Dùng DateTime.monday (1) đến DateTime.sunday (7)
  /// null = báo thức một lần
  TextColumn get repeatDays => text().nullable()();

  /// Nhãn tùy chỉnh
  TextColumn get label => text().withDefault(const Constant(''))();

  /// Chế độ đánh thức: 'normal' hoặc 'deep'
  TextColumn get mode => text().withDefault(const Constant('normal'))();

  /// ID âm thanh tùy chỉnh (GĐ 2)
  IntColumn get soundId => integer().nullable()();

  /// ID media (video) tùy chỉnh (GĐ 2)
  IntColumn get mediaId => integer().nullable()();

  /// Đường dẫn file video nền tùy chỉnh (GĐ 2)
  TextColumn get mediaPath => text().nullable()();

  /// Khoảng thời gian báo lại (phút)
  IntColumn get snoozeIntervalMinutes =>
      integer().withDefault(const Constant(5))();

  /// Số lần báo lại tối đa
  IntColumn get snoozeMaxCount =>
      integer().withDefault(const Constant(3))();

  /// Danh sách thử thách dạng JSON (GĐ 3)
  TextColumn get challenges => text().nullable()();

  /// Múi giờ IANA, ví dụ 'Asia/Tokyo' (GĐ 6)
  TextColumn get timezone => text().nullable()();

  /// Báo thức đang bật hay tắt
  BoolColumn get enabled =>
      boolean().withDefault(const Constant(true))();
}
