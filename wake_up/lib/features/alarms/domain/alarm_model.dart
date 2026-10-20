import 'dart:convert';

/// Enum cho chế độ đánh thức
enum WakeMode { normal, deep }

/// Domain model cho báo thức.
/// Tách biệt khỏi Drift entity để giữ domain logic thuần Dart.
class AlarmModel {
  final int? id;
  final DateTime time;
  final List<int> repeatDays; // DateTime.monday (1) → DateTime.sunday (7)
  final String label;
  final WakeMode mode;
  final int? soundId;
  final int? mediaId;
  final int snoozeIntervalMinutes;
  final int snoozeMaxCount;
  final String? timezone;
  final bool enabled;

  const AlarmModel({
    this.id,
    required this.time,
    this.repeatDays = const [],
    this.label = '',
    this.mode = WakeMode.normal,
    this.soundId,
    this.mediaId,
    this.snoozeIntervalMinutes = 5,
    this.snoozeMaxCount = 3,
    this.timezone,
    this.enabled = true,
  });

  /// Báo thức một lần (không lặp)
  bool get isOneTime => repeatDays.isEmpty;

  /// Báo thức lặp lại
  bool get isRepeating => repeatDays.isNotEmpty;

  AlarmModel copyWith({
    int? id,
    DateTime? time,
    List<int>? repeatDays,
    String? label,
    WakeMode? mode,
    int? soundId,
    int? mediaId,
    int? snoozeIntervalMinutes,
    int? snoozeMaxCount,
    String? timezone,
    bool? enabled,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      time: time ?? this.time,
      repeatDays: repeatDays ?? this.repeatDays,
      label: label ?? this.label,
      mode: mode ?? this.mode,
      soundId: soundId ?? this.soundId,
      mediaId: mediaId ?? this.mediaId,
      snoozeIntervalMinutes:
          snoozeIntervalMinutes ?? this.snoozeIntervalMinutes,
      snoozeMaxCount: snoozeMaxCount ?? this.snoozeMaxCount,
      timezone: timezone ?? this.timezone,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Chuyển repeatDays sang JSON string để lưu vào DB
  String? repeatDaysToJson() {
    if (repeatDays.isEmpty) return null;
    return jsonEncode(repeatDays);
  }

  /// Parse repeatDays từ JSON string
  static List<int> repeatDaysFromJson(String? json) {
    if (json == null || json.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
    return decoded.cast<int>();
  }
}
