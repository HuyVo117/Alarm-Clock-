import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/garden/data/seeds_catalog.dart';
import 'package:wake_up/features/garden/domain/logic/mutation_engine.dart';
import 'package:wake_up/features/garden/domain/models/chest_reward_model.dart';
import 'package:wake_up/features/garden/domain/models/crop_variant_model.dart';

// Deterministic mock random for testing cumulative distributions
class FixedRandom implements Random {
  final double fixedDouble;
  FixedRandom(this.fixedDouble);

  @override
  double nextDouble() => fixedDouble;

  @override
  bool nextBool() => true;

  @override
  int nextInt(int max) => 0;
}

void main() {
  group('MutationEngine Tests', () {
    test('determineMutation selects Common variant when roll is small', () {
      final seed = SeedsCatalog.radish;
      final variant = MutationEngine.determineMutation(seed, FixedRandom(0.10));
      expect(variant.rarity, equals(CropRarity.common));
      expect(variant.id, equals('radish_white'));
    });

    test('determineMutation selects Rare variant when roll is in rare bracket', () {
      final seed = SeedsCatalog.radish;
      // Radish: Common = 0.70, Rare = 0.25 (cumulative: 0.70 -> 0.95)
      final variant = MutationEngine.determineMutation(seed, FixedRandom(0.80));
      expect(variant.rarity, equals(CropRarity.rare));
      expect(variant.id, equals('radish_red'));
    });

    test('determineMutation selects Legendary variant when roll is high', () {
      final seed = SeedsCatalog.radish;
      // Radish: Legendary = 0.05 (cumulative: 0.95 -> 1.00)
      final variant = MutationEngine.determineMutation(seed, FixedRandom(0.98));
      expect(variant.rarity, equals(CropRarity.legendary));
      expect(variant.id, equals('radish_gold'));
    });

    test('generateChestReward creates valid rewards for all chest types', () {
      for (final type in ChestType.values) {
        final reward = MutationEngine.generateChestReward(type);
        expect(reward.coins, greaterThan(0));
        expect(reward.bonusSeeds, isNotEmpty);
        expect(reward.description, isNotEmpty);
      }
    });

    test('calculateWaterReduction produces reduction within min and max seconds', () {
      for (int i = 0; i < 50; i++) {
        final reduction = MutationEngine.calculateWaterReduction(null, 4, 7);
        expect(reduction, inInclusiveRange(4, 7));
      }
    });
  });
}
