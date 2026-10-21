import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/garden/data/garden_repository.dart';
import 'package:wake_up/features/garden/domain/models/garden_profile_model.dart';
import 'package:wake_up/features/garden/domain/models/plot_model.dart';

void main() {
  late Directory tempDir;
  late File tempFile;
  late LocalGardenRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('garden_test_');
    tempFile = File('${tempDir.path}/test_garden.json');
    repository = LocalGardenRepository(() async => tempFile);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('LocalGardenRepository Tests', () {
    test('loadProfile returns default profile when file does not exist', () async {
      final profile = await repository.loadProfile();
      expect(profile.coins, equals(500));
      expect(profile.chestEnergy, equals(0));
      expect(profile.inventory['radish'], equals(20));
    });

    test('saveProfile and loadProfile persist correctly', () async {
      const customProfile = GardenProfileModel(
        coins: 1250,
        chestEnergy: 180,
        maxChestEnergy: 300,
        chestsOpened: 3,
        inventory: {'radish': 15, 'corn': 8},
        unlockedVariantIds: {'radish_white', 'radish_red'},
      );

      await repository.saveProfile(customProfile);
      final loaded = await repository.loadProfile();

      expect(loaded.coins, equals(1250));
      expect(loaded.chestEnergy, equals(180));
      expect(loaded.chestsOpened, equals(3));
      expect(loaded.inventory['corn'], equals(8));
      expect(loaded.unlockedVariantIds.contains('radish_red'), isTrue);
    });

    test('loadPlots returns 16 empty plots initially', () async {
      final plots = await repository.loadPlots();
      expect(plots.length, equals(16));
      expect(plots.every((p) => p.state == PlotState.empty), isTrue);
    });

    test('savePlots and loadPlots persist 16 plots with data', () async {
      final plots = List.generate(
        16,
        (i) => PlotModel(
          index: i,
          state: i == 0 ? PlotState.growing : PlotState.empty,
          seedId: i == 0 ? 'corn' : null,
          growDurationSeconds: i == 0 ? 45 : 0,
        ),
      );

      await repository.savePlots(plots);
      final loaded = await repository.loadPlots();

      expect(loaded.length, equals(16));
      expect(loaded[0].state, equals(PlotState.growing));
      expect(loaded[0].seedId, equals('corn'));
      expect(loaded[1].state, equals(PlotState.empty));
    });
  });
}
