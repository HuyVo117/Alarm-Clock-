import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/world_clock/data/city_data.dart';
import 'package:wake_up/features/world_clock/data/world_clock_repository.dart';
import 'package:wake_up/features/world_clock/domain/world_city_model.dart';

void main() {
  late Directory tempDir;
  late File tempFile;
  late LocalWorldClockRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('world_clock_test_');
    tempFile = File('${tempDir.path}/test_clocks.json');
    repository = LocalWorldClockRepository(() async => tempFile);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('LocalWorldClockRepository', () {
    test('returns default cities when file does not exist', () async {
      expect(await tempFile.exists(), isFalse);

      final cities = await repository.getSavedCities();
      expect(cities.length, CityData.defaultCities.length);
      expect(await tempFile.exists(), isTrue);
    });

    test('addCity adds new city with correct sortOrder', () async {
      await repository.getSavedCities(); // Initialize defaults

      const newCity = WorldCityModel(
        id: 'city_paris',
        timezoneId: 'Europe/Paris',
        cityName: 'Paris',
        countryName: 'Pháp',
      );

      await repository.addCity(newCity);
      final updated = await repository.getSavedCities();

      expect(updated.any((c) => c.cityName == 'Paris'), isTrue);
      final added = updated.firstWhere((c) => c.cityName == 'Paris');
      expect(added.sortOrder, CityData.defaultCities.length);
    });

    test('addCity rejects duplicate city', () async {
      final initial = await repository.getSavedCities();
      final initialCount = initial.length;

      // Duplicate Hanoi
      const duplicate = WorldCityModel(
        id: 'city_hanoi',
        timezoneId: 'Asia/Ho_Chi_Minh',
        cityName: 'Hà Nội',
        countryName: 'Việt Nam',
      );

      await repository.addCity(duplicate);
      final afterAdd = await repository.getSavedCities();
      expect(afterAdd.length, initialCount);
    });

    test('removeCity removes city and updates sortOrders', () async {
      await repository.getSavedCities(); // init

      await repository.removeCity('city_hanoi');
      final updated = await repository.getSavedCities();

      expect(updated.any((c) => c.id == 'city_hanoi'), isFalse);
      for (int i = 0; i < updated.length; i++) {
        expect(updated[i].sortOrder, i);
      }
    });

    test('reorderCities updates positions and sortOrders', () async {
      await repository.getSavedCities(); // Tokyo is at index 1

      // Move Tokyo (index 1) to top (index 0)
      await repository.reorderCities(1, 0);
      final updated = await repository.getSavedCities();

      expect(updated.first.id, 'city_tokyo');
      for (int i = 0; i < updated.length; i++) {
        expect(updated[i].sortOrder, i);
      }
    });
  });
}
