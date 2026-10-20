/// Logic tính thời điểm kêu kế tiếp cho báo thức.
/// Dart thuần, không phụ thuộc UI hoặc plugin.
class NextAlarmCalculator {
  /// Tính thời điểm kêu kế tiếp cho báo thức một lần.
  /// Nếu [alarmTime] đã qua so với [now], trả về null (báo thức hết hiệu lực).
  static DateTime? nextOneTimeAlarm({
    required DateTime alarmTime,
    required DateTime now,
  }) {
    if (alarmTime.isAfter(now)) {
      return alarmTime;
    }
    return null; // Đã qua, không có lần kêu kế tiếp
  }

  /// Tính thời điểm kêu kế tiếp cho báo thức lặp theo thứ.
  ///
  /// [hour] và [minute] là giờ và phút báo thức.
  /// [repeatDays] là danh sách ngày lặp (DateTime.monday=1 → DateTime.sunday=7).
  /// [now] là thời điểm hiện tại.
  ///
  /// Trả về DateTime gần nhất trong tương lai mà báo thức sẽ kêu.
  static DateTime nextRepeatingAlarm({
    required int hour,
    required int minute,
    required List<int> repeatDays,
    required DateTime now,
  }) {
    assert(repeatDays.isNotEmpty, 'repeatDays phải có ít nhất 1 ngày');
    assert(
      repeatDays.every((d) => d >= DateTime.monday && d <= DateTime.sunday),
      'Ngày phải từ 1 (Thứ 2) đến 7 (Chủ nhật)',
    );

    // Sắp xếp để tìm ngày gần nhất
    final sortedDays = List<int>.from(repeatDays)..sort();

    // Thử từ hôm nay đến 7 ngày tới
    for (int offset = 0; offset <= 7; offset++) {
      final candidate = DateTime(
        now.year,
        now.month,
        now.day + offset,
        hour,
        minute,
      );

      // Kiểm tra ngày trong tuần có nằm trong danh sách lặp không
      if (sortedDays.contains(candidate.weekday)) {
        // Nếu là hôm nay, chỉ tính nếu chưa qua giờ
        if (offset == 0 && !candidate.isAfter(now)) {
          continue;
        }
        return candidate;
      }
    }

    // Không bao giờ đến đây nếu repeatDays hợp lệ (7 ngày tới chắc chắn có)
    throw StateError(
      'Không tìm được lần kêu kế tiếp với repeatDays=$repeatDays',
    );
  }

  /// Tính thời điểm kêu kế tiếp, tự động chọn logic một lần hoặc lặp.
  ///
  /// [alarmTime] là giờ báo thức gốc (dùng hour + minute).
  /// [repeatDays] rỗng = một lần, có giá trị = lặp.
  /// [now] là thời điểm hiện tại.
  static DateTime? nextAlarm({
    required DateTime alarmTime,
    required List<int> repeatDays,
    required DateTime now,
  }) {
    if (repeatDays.isEmpty) {
      return nextOneTimeAlarm(alarmTime: alarmTime, now: now);
    }
    return nextRepeatingAlarm(
      hour: alarmTime.hour,
      minute: alarmTime.minute,
      repeatDays: repeatDays,
      now: now,
    );
  }
}
