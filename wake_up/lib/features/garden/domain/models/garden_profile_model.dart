/// Hồ sơ tổng quan của người chơi trong Nông Trại Thức Giấc.
class GardenProfileModel {
  final int coins;
  final int chestEnergy;
  final int maxChestEnergy;
  final int chestsOpened;
  final Map<String, int> inventory;            // seedId -> số lượng tồn kho
  final Set<String> unlockedVariantIds;        // ID các biến thể đã từng thu hoạch (Sổ tay)
  final Map<String, int> taskProgress;         // Nhiệm vụ: taskId -> tiến độ hiện tại
  final int level;
  final int exp;

  const GardenProfileModel({
    this.coins = 500,
    this.chestEnergy = 0,
    this.maxChestEnergy = 300,
    this.chestsOpened = 0,
    this.inventory = const {'radish': 20},     // Tặng sẵn 20 hạt củ cải khi bắt đầu
    this.unlockedVariantIds = const {},
    this.taskProgress = const {'plant_pumpkin': 0},
    this.level = 1,
    this.exp = 0,
  });

  bool get isChestReady => chestEnergy >= maxChestEnergy;

  GardenProfileModel copyWith({
    int? coins,
    int? chestEnergy,
    int? maxChestEnergy,
    int? chestsOpened,
    Map<String, int>? inventory,
    Set<String>? unlockedVariantIds,
    Map<String, int>? taskProgress,
    int? level,
    int? exp,
  }) {
    return GardenProfileModel(
      coins: coins ?? this.coins,
      chestEnergy: chestEnergy ?? this.chestEnergy,
      maxChestEnergy: maxChestEnergy ?? this.maxChestEnergy,
      chestsOpened: chestsOpened ?? this.chestsOpened,
      inventory: inventory ?? Map.from(this.inventory),
      unlockedVariantIds: unlockedVariantIds ?? Set.from(this.unlockedVariantIds),
      taskProgress: taskProgress ?? Map.from(this.taskProgress),
      level: level ?? this.level,
      exp: exp ?? this.exp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coins': coins,
      'chestEnergy': chestEnergy,
      'maxChestEnergy': maxChestEnergy,
      'chestsOpened': chestsOpened,
      'inventory': inventory,
      'unlockedVariantIds': unlockedVariantIds.toList(),
      'taskProgress': taskProgress,
      'level': level,
      'exp': exp,
    };
  }

  factory GardenProfileModel.fromJson(Map<String, dynamic> json) {
    return GardenProfileModel(
      coins: json['coins'] as int? ?? 500,
      chestEnergy: json['chestEnergy'] as int? ?? 0,
      maxChestEnergy: json['maxChestEnergy'] as int? ?? 300,
      chestsOpened: json['chestsOpened'] as int? ?? 0,
      inventory: (json['inventory'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {'radish': 20},
      unlockedVariantIds: (json['unlockedVariantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      taskProgress: (json['taskProgress'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {},
      level: json['level'] as int? ?? 1,
      exp: json['exp'] as int? ?? 0,
    );
  }
}
