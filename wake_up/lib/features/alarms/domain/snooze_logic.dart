/// Logic báo lại (snooze) cho báo thức.
/// Dart thuần, không phụ thuộc UI hoặc plugin.
class SnoozeLogic {
  final int intervalMinutes;
  final int maxCount;
  int _currentCount;

  SnoozeLogic({
    required this.intervalMinutes,
    required this.maxCount,
  }) : _currentCount = 0;

  /// Số lần đã báo lại
  int get currentCount => _currentCount;

  /// Còn được phép báo lại không
  bool get canSnooze => _currentCount < maxCount;

  /// Số lần báo lại còn lại
  int get remainingCount => maxCount - _currentCount;

  /// Thực hiện báo lại: tăng đếm và trả về thời điểm reo tiếp.
  /// Trả về null nếu đã hết lượt.
  DateTime? snooze(DateTime now) {
    if (!canSnooze) return null;
    _currentCount++;
    return now.add(Duration(minutes: intervalMinutes));
  }

  /// Reset bộ đếm (khi người dùng tắt hoàn toàn báo thức)
  void reset() {
    _currentCount = 0;
  }
}
