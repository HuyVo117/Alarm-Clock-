import 'dart:math';

import '../models/chest_reward_model.dart';
import '../models/crop_variant_model.dart';
import '../models/seed_model.dart';

/// Bộ máy quyết định tỷ lệ đột biến màu sắc nông sản và sinh phần thưởng rương.
class MutationEngine {
  /// Quyết định biến thể nông sản khi cây đến độ chín bằng thuật toán tích lũy xác suất.
  static CropVariantModel determineMutation(
    SeedModel seed, [
    Random? random,
  ]) {
    if (seed.variants.isEmpty) {
      return CropVariantModel(
        id: '${seed.id}_default',
        cropType: seed.id,
        name: seed.name,
        colorValue: 0xFFFFFFFF,
        rarity: CropRarity.common,
        dropRate: 1.0,
        rewardCoins: 10,
        rewardEnergy: 5,
        iconEmoji: seed.iconEmoji,
      );
    }

    final rand = random ?? Random();
    final roll = rand.nextDouble(); // [0.0, 1.0)

    double cumulative = 0.0;
    for (final variant in seed.variants) {
      cumulative += variant.dropRate;
      if (roll <= cumulative) {
        return variant;
      }
    }

    return seed.variants.first;
  }

  /// Sinh phần thưởng ngẫu nhiên khi mở Rương Thần Kỳ.
  static ChestRewardModel generateChestReward(
    ChestType type, [
    Random? random,
  ]) {
    final rand = random ?? Random();

    switch (type) {
      case ChestType.normal:
        final coins = 100 + rand.nextInt(101); // 100 - 200 xu
        return ChestRewardModel(
          type: type,
          coins: coins,
          bonusEnergy: 0,
          bonusSeeds: {'radish': 5, 'corn': 2},
          description: 'Mở Rương Thường: Nhận $coins Xu và 7 hạt giống!',
        );

      case ChestType.rare:
        final coins = 300 + rand.nextInt(201); // 300 - 500 xu
        return ChestRewardModel(
          type: type,
          coins: coins,
          bonusEnergy: 20,
          bonusSeeds: {'corn': 5, 'pumpkin': 3},
          description: 'Mở Rương Hiếm: Nhận $coins Xu, hạt giống quý và +20 Năng lượng!',
        );

      case ChestType.legendary:
        final coins = 800 + rand.nextInt(501); // 800 - 1300 xu
        return ChestRewardModel(
          type: type,
          coins: coins,
          bonusEnergy: 50,
          bonusSeeds: {'pumpkin': 10, 'corn': 10},
          description: 'Mở Rương Cực Hiếm: Nhận $coins Xu và kho hạt giống đặc biệt!',
        );
    }
  }

  /// Tính toán số giây được giảm trừ khi người chơi tưới nước vào ô đất.
  /// Mặc định giảm ngẫu nhiên từ 4 đến 7 giây như trong tài liệu video.
  static int calculateWaterReduction([Random? random, int minSec = 4, int maxSec = 7]) {
    final rand = random ?? Random();
    return minSec + rand.nextInt(maxSec - minSec + 1);
  }
}
