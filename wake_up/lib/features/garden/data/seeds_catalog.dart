import '../domain/models/crop_variant_model.dart';
import '../domain/models/seed_model.dart';

/// Danh mục toàn bộ các loại hạt giống có sẵn trong Cửa hàng Nông Trại Thức Giấc.
class SeedsCatalog {
  // 1. Củ cải trắng (Miễn phí 0 xu)
  static const radish = SeedModel(
    id: 'radish',
    name: 'Củ cải ngọt',
    description: 'Hạt giống khởi đầu miễn phí. Thu hoạch nhanh để tích lũy năng lượng mở Rương Thần Kỳ.',
    iconEmoji: '🌱',
    price: 0,
    growSeconds: 15,
    category: SeedCategory.basic,
    expReward: 15,
    variants: [
      CropVariantModel(
        id: 'radish_white',
        cropType: 'radish',
        name: 'Củ cải trắng ngà',
        colorValue: 0xFFE0E0E0,
        rarity: CropRarity.common,
        dropRate: 0.70,
        rewardCoins: 12,
        rewardEnergy: 6,
        exp: 10,
        iconEmoji: '🤍',
      ),
      CropVariantModel(
        id: 'radish_red',
        cropType: 'radish',
        name: 'Củ cải đỏ thẫm',
        colorValue: 0xFFE53935,
        rarity: CropRarity.rare,
        dropRate: 0.25,
        rewardCoins: 40,
        rewardEnergy: 20,
        exp: 25,
        iconEmoji: '❤️',
      ),
      CropVariantModel(
        id: 'radish_gold',
        cropType: 'radish',
        name: 'Củ cải hoàng kim',
        colorValue: 0xFFFFD700,
        rarity: CropRarity.legendary,
        dropRate: 0.05,
        rewardCoins: 150,
        rewardEnergy: 75,
        exp: 80,
        iconEmoji: '⭐',
      ),
    ],
  );

  // 2. Bắp ngô ngọt (30 xu)
  static const corn = SeedModel(
    id: 'corn',
    name: 'Bắp ngô ngọt',
    description: 'Hạt ngô óng ả, đem lại nguồn Xu dồi dào và nhiều đột biến màu sắc bắt mắt.',
    iconEmoji: '🌽',
    price: 30,
    growSeconds: 45,
    category: SeedCategory.basic,
    expReward: 35,
    variants: [
      CropVariantModel(
        id: 'corn_yellow',
        cropType: 'corn',
        name: 'Bắp ngô vàng óng',
        colorValue: 0xFFFFEE58,
        rarity: CropRarity.common,
        dropRate: 0.70,
        rewardCoins: 50,
        rewardEnergy: 15,
        exp: 25,
        iconEmoji: '🌽',
      ),
      CropVariantModel(
        id: 'corn_purple',
        cropType: 'corn',
        name: 'Bắp nếp tím ngọc',
        colorValue: 0xFFAB47BC,
        rarity: CropRarity.rare,
        dropRate: 0.25,
        rewardCoins: 120,
        rewardEnergy: 40,
        exp: 60,
        iconEmoji: '💜',
      ),
      CropVariantModel(
        id: 'corn_gold',
        cropType: 'corn',
        name: 'Bắp ngô hổ phách kim',
        colorValue: 0xFFFFD700,
        rarity: CropRarity.legendary,
        dropRate: 0.05,
        rewardCoins: 400,
        rewardEnergy: 120,
        exp: 150,
        iconEmoji: '✨',
      ),
    ],
  );

  // 3. Bí ngô khổng lồ (100 xu)
  static const pumpkin = SeedModel(
    id: 'pumpkin',
    name: 'Bí ngô thần kỳ',
    description: 'Bí ngô siêu lớn phát quang trong đêm, giá trị trao đổi cực cao trong Sổ tay.',
    iconEmoji: '🎃',
    price: 100,
    growSeconds: 120,
    category: SeedCategory.special,
    expReward: 90,
    variants: [
      CropVariantModel(
        id: 'pumpkin_orange',
        cropType: 'pumpkin',
        name: 'Bí ngô cam rực',
        colorValue: 0xFFFF9800,
        rarity: CropRarity.common,
        dropRate: 0.70,
        rewardCoins: 180,
        rewardEnergy: 45,
        exp: 70,
        iconEmoji: '🎃',
      ),
      CropVariantModel(
        id: 'pumpkin_green',
        cropType: 'pumpkin',
        name: 'Bí ngô ngọc lục bảo',
        colorValue: 0xFF43A047,
        rarity: CropRarity.rare,
        dropRate: 0.25,
        rewardCoins: 450,
        rewardEnergy: 110,
        exp: 180,
        iconEmoji: '💚',
      ),
      CropVariantModel(
        id: 'pumpkin_gold',
        cropType: 'pumpkin',
        name: 'Bí ngô thái dương kim',
        colorValue: 0xFFFFD700,
        rarity: CropRarity.legendary,
        dropRate: 0.05,
        rewardCoins: 1200,
        rewardEnergy: 300,
        exp: 400,
        iconEmoji: '👑',
      ),
    ],
  );

  /// Danh sách tất cả các loại hạt giống trong trò chơi.
  static const List<SeedModel> all = [
    radish,
    corn,
    pumpkin,
  ];

  /// Tìm kiếm hạt giống theo ID.
  static SeedModel? findById(String id) {
    for (final s in all) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Tìm kiếm biến thể màu sắc theo variantId.
  static CropVariantModel? findVariantById(String variantId) {
    for (final s in all) {
      for (final v in s.variants) {
        if (v.id == variantId) return v;
      }
    }
    return null;
  }
}
