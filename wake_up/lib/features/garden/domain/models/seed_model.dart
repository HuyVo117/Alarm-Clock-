import 'crop_variant_model.dart';

/// Phân loại tab trong ngăn kéo hạt giống.
enum SeedCategory {
  basic,    // Hạt giống cơ bản (Củ cải, v.v.)
  special,  // Hạt giống đặc biệt (Ngô ngọt, Bí ngô ma thuật)
}

/// Mô hình một loại gói hạt giống có thể mua trong Shop và gieo lên ruộng.
class SeedModel {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final int price;              // 0 = miễn phí (cày rương thoải mái)
  final int growSeconds;        // Thời gian trưởng thành (giây)
  final SeedCategory category;
  final List<CropVariantModel> variants;
  final int expReward;

  const SeedModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    required this.price,
    required this.growSeconds,
    this.category = SeedCategory.basic,
    required this.variants,
    this.expReward = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconEmoji': iconEmoji,
      'price': price,
      'growSeconds': growSeconds,
      'category': category.name,
      'variants': variants.map((v) => v.toJson()).toList(),
      'expReward': expReward,
    };
  }

  factory SeedModel.fromJson(Map<String, dynamic> json) {
    return SeedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconEmoji: json['iconEmoji'] as String? ?? '🌱',
      price: json['price'] as int? ?? 0,
      growSeconds: json['growSeconds'] as int? ?? 15,
      category: SeedCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => SeedCategory.basic,
      ),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => CropVariantModel.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      expReward: json['expReward'] as int? ?? 20,
    );
  }
}
