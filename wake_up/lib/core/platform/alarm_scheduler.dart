/// Interface trừu tượng cho việc lên lịch báo thức.
/// Có hai cài đặt riêng cho Android và iOS, giúp dễ test và thay thế.
abstract class AlarmScheduler {
  /// Lên lịch một báo thức sẽ reo vào [scheduledTime].
  /// [alarmId] là ID duy nhất từ database.
  /// [label] là nhãn hiển thị khi reo.
  /// [soundPath] là đường dẫn file âm thanh hoặc asset âm thanh.
  Future<void> scheduleAlarm({
    required int alarmId,
    required DateTime scheduledTime,
    required String label,
    String? soundPath,
  });

  /// Hủy một báo thức đã lên lịch.
  Future<void> cancelAlarm(int alarmId);

  /// Lên lịch lại tất cả báo thức đang bật.
  /// Gọi sau reboot, khi múi giờ đổi, hoặc khi giờ hệ thống thay đổi.
  Future<void> rescheduleAll();

  /// Kiểm tra xem đã có đủ quyền cần thiết chưa.
  Future<bool> hasRequiredPermissions();

  /// Yêu cầu các quyền cần thiết.
  /// Trả về true nếu tất cả quyền đã được cấp.
  Future<bool> requestPermissions();
}
