/// Cấp bậc của Rương Thần Kỳ.
enum ChestType {
  normal,     // Rương thường (300 năng lượng)
  rare,       // Rương hiếm (550 năng lượng)
  legendary,  // Rương cực hiếm (1000 năng lượng)
}

/// Mô hình phần thưởng khi mở Rương Thần Kỳ.
class ChestRewardModel {
  final ChestType type;
  final int coins;
  final int bonusEnergy;
  final Map<String, int> bonusSeeds; // seedId -> số lượng
  final String description;

  const ChestRewardModel({
    required this.type,
    required this.coins,
    this.bonusEnergy = 0,
    required this.bonusSeeds,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'coins': coins,
      'bonusEnergy': bonusEnergy,
      'bonusSeeds': bonusSeeds,
      'description': description,
    };
  }

  factory ChestRewardModel.fromJson(Map<String, dynamic> json) {
    return ChestRewardModel(
      type: ChestType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChestType.normal,
      ),
      coins: json['coins'] as int? ?? 0,
      bonusEnergy: json['bonusEnergy'] as int? ?? 0,
      bonusSeeds: (json['bonusSeeds'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {},
      description: json['description'] as String? ?? '',
    );
  }
}
