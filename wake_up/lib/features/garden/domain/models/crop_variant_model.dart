/// Độ hiếm của biến thể nông sản sau khi đột biến màu sắc.
enum CropRarity {
  common,     // Thường (tỷ lệ cao, ví dụ 70%)
  rare,       // Hiếm (tỷ lệ trung bình, ví dụ 25%)
  legendary,  // Cực phẩm / Hoàng kim (tỷ lệ thấp, ví dụ 5%)
}

/// Mô hình một biến thể nông sản đột biến màu sắc.
class CropVariantModel {
  final String id;
  final String cropType;
  final String name;
  final int colorValue;
  final CropRarity rarity;
  final double dropRate;
  final int rewardCoins;
  final int rewardEnergy;
  final int exp;
  final String iconEmoji;

  const CropVariantModel({
    required this.id,
    required this.cropType,
    required this.name,
    required this.colorValue,
    required this.rarity,
    required this.dropRate,
    required this.rewardCoins,
    required this.rewardEnergy,
    this.exp = 10,
    required this.iconEmoji,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropType': cropType,
      'name': name,
      'colorValue': colorValue,
      'rarity': rarity.name,
      'dropRate': dropRate,
      'rewardCoins': rewardCoins,
      'rewardEnergy': rewardEnergy,
      'exp': exp,
      'iconEmoji': iconEmoji,
    };
  }

  factory CropVariantModel.fromJson(Map<String, dynamic> json) {
    return CropVariantModel(
      id: json['id'] as String,
      cropType: json['cropType'] as String,
      name: json['name'] as String,
      colorValue: json['colorValue'] as int? ?? 0xFFFFFFFF,
      rarity: CropRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => CropRarity.common,
      ),
      dropRate: (json['dropRate'] as num?)?.toDouble() ?? 1.0,
      rewardCoins: json['rewardCoins'] as int? ?? 0,
      rewardEnergy: json['rewardEnergy'] as int? ?? 0,
      exp: json['exp'] as int? ?? 10,
      iconEmoji: json['iconEmoji'] as String? ?? '🌱',
    );
  }
}
