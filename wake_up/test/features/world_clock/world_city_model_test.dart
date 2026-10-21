import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/world_clock/domain/world_city_model.dart';

void main() {
  group('WorldCityModel', () {
    test('serialization and deserialization to/from JSON works correctly', () {
      const city = WorldCityModel(
        id: 'Asia/Ho_Chi_Minh',
        timezoneId: 'Asia/Ho_Chi_Minh',
        cityName: 'Hồ Chí Minh',
        countryName: 'Việt Nam',
        sortOrder: 1,
      );

      final json = city.toJson();
      expect(json['id'], 'Asia/Ho_Chi_Minh');
      expect(json['timezoneId'], 'Asia/Ho_Chi_Minh');
      expect(json['cityName'], 'Hồ Chí Minh');
      expect(json['countryName'], 'Việt Nam');
      expect(json['sortOrder'], 1);

      final deserialized = WorldCityModel.fromJson(json);
      expect(deserialized, equals(city));
      expect(deserialized.hashCode, equals(city.hashCode));
    });

    test('copyWith updates properties correctly', () {
      const city = WorldCityModel(
        id: 'Asia/Tokyo',
        timezoneId: 'Asia/Tokyo',
        cityName: 'Tokyo',
        countryName: 'Nhật Bản',
        sortOrder: 0,
      );

      final updated = city.copyWith(sortOrder: 5, cityName: 'Đông Kinh');
      expect(updated.cityName, 'Đông Kinh');
      expect(updated.sortOrder, 5);
      expect(updated.timezoneId, 'Asia/Tokyo');
      expect(updated.countryName, 'Nhật Bản');
    });

    test('fallback id to timezoneId when id is missing from json', () {
      final json = {
        'timezoneId': 'Europe/London',
        'cityName': 'London',
        'countryName': 'United Kingdom',
      };

      final city = WorldCityModel.fromJson(json);
      expect(city.id, 'Europe/London');
      expect(city.sortOrder, 0);
    });
  });
}
