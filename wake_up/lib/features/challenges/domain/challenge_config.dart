import 'dart:convert';

/// Cấu hình cho một thử thách, lưu trong cột `challenges` của bảng Alarms.
///
/// Format JSON trong DB: `[{"type":"math","params":{"difficulty":2}}, ...]`
class ChallengeConfig {
  /// Loại thử thách: 'math', 'shake', 'qr'
  final String type;

  /// Tham số tùy chỉnh cho từng loại:
  /// - math: {"difficulty": 1|2|3, "questionCount": 3}
  /// - shake: {"targetCount": 30, "shakeThreshold": 15.0}
  /// - qr: {"qrHashes": ["abc123...", "def456..."]}
  final Map<String, dynamic> params;

  const ChallengeConfig({
    required this.type,
    this.params = const {},
  });

  /// Tạo config mặc định cho từng loại thử thách.
  factory ChallengeConfig.defaultFor(String type) {
    switch (type) {
      case 'math':
        return const ChallengeConfig(
          type: 'math',
          params: {'difficulty': 1, 'questionCount': 3},
        );
      case 'shake':
        return const ChallengeConfig(
          type: 'shake',
          params: {'targetCount': 30, 'shakeThreshold': 15.0},
        );
      case 'qr':
        return const ChallengeConfig(
          type: 'qr',
          params: {'qrHashes': <String>[]},
        );
      default:
        throw ArgumentError('Unknown challenge type: $type');
    }
  }

  /// Tạo ChallengeConfig từ JSON Map.
  factory ChallengeConfig.fromJson(Map<String, dynamic> json) {
    return ChallengeConfig(
      type: json['type'] as String,
      params: (json['params'] as Map<String, dynamic>?) ?? {},
    );
  }

  /// Chuyển thành JSON Map.
  Map<String, dynamic> toJson() => {
        'type': type,
        'params': params,
      };

  /// Parse danh sách ChallengeConfig từ JSON string (cột DB).
  /// Trả về list rỗng nếu null hoặc rỗng.
  static List<ChallengeConfig> fromJsonString(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
      return decoded
          .map((e) => ChallengeConfig.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Chuyển danh sách ChallengeConfig thành JSON string để lưu DB.
  /// Trả về null nếu list rỗng.
  static String? toJsonString(List<ChallengeConfig> configs) {
    if (configs.isEmpty) return null;
    return jsonEncode(configs.map((c) => c.toJson()).toList());
  }

  /// Copy với params mới.
  ChallengeConfig copyWith({Map<String, dynamic>? params}) {
    return ChallengeConfig(
      type: type,
      params: params ?? this.params,
    );
  }

  @override
  String toString() => 'ChallengeConfig(type: $type, params: $params)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeConfig &&
          type == other.type &&
          _mapEquals(params, other.params);

  @override
  int get hashCode => Object.hash(type, params.toString());

  static bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key].toString() != b[key].toString()) return false;
    }
    return true;
  }
}
