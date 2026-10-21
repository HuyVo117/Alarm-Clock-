import 'package:flutter/foundation.dart';

/// Model thuần Dart đại diện cho một thành phố trong Đồng hồ Thế giới.
@immutable
class WorldCityModel {
  /// Mã định danh duy nhất (thường là timezoneId hoặc kết hợp tên + id)
  final String id;

  /// Mã IANA timezone (ví dụ: 'Asia/Ho_Chi_Minh', 'America/New_York')
  final String timezoneId;

  /// Tên thành phố hiển thị (ví dụ: 'Hà Nội', 'Tokyo', 'London')
  final String cityName;

  /// Tên quốc gia hiển thị (ví dụ: 'Việt Nam', 'Nhật Bản', 'Vương quốc Anh')
  final String countryName;

  /// Thứ tự hiển thị trong danh sách người dùng đã lưu
  final int sortOrder;

  const WorldCityModel({
    required this.id,
    required this.timezoneId,
    required this.cityName,
    required this.countryName,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timezoneId': timezoneId,
      'cityName': cityName,
      'countryName': countryName,
      'sortOrder': sortOrder,
    };
  }

  factory WorldCityModel.fromJson(Map<String, dynamic> json) {
    final tzId = json['timezoneId'] as String;
    return WorldCityModel(
      id: json['id'] as String? ?? tzId,
      timezoneId: tzId,
      cityName: json['cityName'] as String,
      countryName: json['countryName'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  WorldCityModel copyWith({
    String? id,
    String? timezoneId,
    String? cityName,
    String? countryName,
    int? sortOrder,
  }) {
    return WorldCityModel(
      id: id ?? this.id,
      timezoneId: timezoneId ?? this.timezoneId,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorldCityModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timezoneId == other.timezoneId &&
          cityName == other.cityName &&
          countryName == other.countryName &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode =>
      id.hashCode ^
      timezoneId.hashCode ^
      cityName.hashCode ^
      countryName.hashCode ^
      sortOrder.hashCode;

  @override
  String toString() =>
      'WorldCityModel(id: $id, cityName: $cityName, countryName: $countryName, tz: $timezoneId, order: $sortOrder)';
}
