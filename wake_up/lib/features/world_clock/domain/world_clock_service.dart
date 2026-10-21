import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Service thuần Dart xử lý các logic tính toán múi giờ, độ lệch UTC và ngày/đêm.
/// Dễ dàng unit test nhờ hỗ trợ truyền `baseUtc` làm mốc thời gian giả lập.
class WorldClockService {
  static bool _initialized = false;

  /// Khởi tạo cơ sở dữ liệu múi giờ IANA.
  /// Cần được gọi một lần duy nhất khi ứng dụng khởi động (ví dụ trong `main.dart`).
  static void initialize() {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }
  }

  /// Kiểm tra xem service đã khởi tạo chưa (dùng cho unit test).
  static bool get isInitialized => _initialized;

  /// Lấy đối tượng `Location` từ IANA timezone id.
  /// Trả về null nếu không tìm thấy.
  tz.Location? getLocation(String timezoneId) {
    initialize();
    try {
      return tz.getLocation(timezoneId);
    } catch (_) {
      return null;
    }
  }

  /// Lấy thời điểm hiện tại tại một múi giờ.
  /// Nếu truyền `baseUtc`, sẽ tính thời gian quy đổi từ mốc UTC đó.
  tz.TZDateTime nowIn(String timezoneId, [DateTime? baseUtc]) {
    initialize();
    final location = getLocation(timezoneId) ?? tz.local;
    if (baseUtc != null) {
      final utcTime = baseUtc.isUtc ? baseUtc : baseUtc.toUtc();
      return tz.TZDateTime.from(utcTime, location);
    }
    return tz.TZDateTime.now(location);
  }

  /// Lấy chuỗi biểu diễn độ lệch UTC (ví dụ: "UTC+07:00", "UTC-04:00", "UTC+05:30").
  String getUtcOffsetString(String timezoneId, [DateTime? baseUtc]) {
    final time = nowIn(timezoneId, baseUtc);
    final offset = time.timeZoneOffset;
    final totalMinutes = offset.inMinutes;
    final sign = totalMinutes >= 0 ? '+' : '-';
    final absMinutes = totalMinutes.abs();
    final hours = (absMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (absMinutes % 60).toString().padLeft(2, '0');
    return 'UTC$sign$hours:$minutes';
  }

  /// Độ chênh lệch giữa múi giờ mục tiêu và giờ địa phương thiết bị (tính theo giờ).
  /// Ví dụ: Tokyo (UTC+9) so với VN (UTC+7) sẽ là +2.0.
  double getHourDifferenceFromLocal(String timezoneId, [DateTime? baseUtc]) {
    final targetTime = nowIn(timezoneId, baseUtc);
    final localTime = (baseUtc ?? DateTime.now()).toLocal();
    final diffDuration = targetTime.timeZoneOffset - localTime.timeZoneOffset;
    return diffDuration.inMinutes / 60.0;
  }

  /// Xác định xem tại địa điểm đó đang là ban ngày hay ban đêm.
  /// Ban ngày được định nghĩa là từ 06:00 đến 17:59 (6:00 AM - 5:59 PM).
  bool isDaytime(String timezoneId, [DateTime? baseUtc]) {
    final time = nowIn(timezoneId, baseUtc);
    return time.hour >= 6 && time.hour < 18;
  }

  /// Tạo chuỗi mô tả tương quan ngày và giờ so với thiết bị địa phương.
  /// Ví dụ:
  /// - "Hôm nay, +2 giờ"
  /// - "Hôm nay, -11 giờ"
  /// - "Ngày mai, +7 giờ"
  /// - "Hôm qua, -5 giờ"
  /// - "Hôm nay, cùng giờ"
  String getRelativeDescription(
    String timezoneId, {
    DateTime? baseUtc,
    required String todayText,
    required String tomorrowText,
    required String yesterdayText,
    required String sameTimeText,
    required String hoursAheadSuffix,
    required String hoursBehindSuffix,
  }) {
    final targetTime = nowIn(timezoneId, baseUtc);
    final localTime = (baseUtc ?? DateTime.now()).toLocal();

    // So sánh ngày
    final targetDate = DateTime(targetTime.year, targetTime.month, targetTime.day);
    final localDate = DateTime(localTime.year, localTime.month, localTime.day);
    final dayDiff = targetDate.difference(localDate).inDays;

    String dayString;
    if (dayDiff == 0) {
      dayString = todayText;
    } else if (dayDiff > 0) {
      dayString = tomorrowText;
    } else {
      dayString = yesterdayText;
    }

    final hourDiff = getHourDifferenceFromLocal(timezoneId, baseUtc);
    if (hourDiff == 0) {
      return '$dayString, $sameTimeText';
    }

    final isAhead = hourDiff > 0;
    final absDiff = hourDiff.abs();
    final diffFormatted = absDiff % 1 == 0 ? absDiff.toInt().toString() : absDiff.toStringAsFixed(1);
    final sign = isAhead ? '+' : '-';
    final suffix = isAhead ? hoursAheadSuffix : hoursBehindSuffix;

    return '$dayString, $sign$diffFormatted $suffix';
  }
}
