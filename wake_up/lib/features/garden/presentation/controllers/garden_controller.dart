import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/garden_repository.dart';
import '../../data/seeds_catalog.dart';
import '../../domain/logic/mutation_engine.dart';
import '../../domain/models/chest_reward_model.dart';
import '../../domain/models/garden_profile_model.dart';
import '../../domain/models/plot_model.dart';

/// Trạng thái toàn diện của Mini-game Nông Trại Thức Giấc.
class GardenState {
  final List<PlotModel> plots;
  final GardenProfileModel profile;
  final int? selectedPlotIndex;
  final String selectedSeedId;
  final String? notificationBanner;
  final ChestRewardModel? lastChestReward;
  final bool isLoading;

  const GardenState({
    required this.plots,
    required this.profile,
    this.selectedPlotIndex,
    this.selectedSeedId = 'radish',
    this.notificationBanner,
    this.lastChestReward,
    this.isLoading = false,
  });

  /// Đếm số ô đất đang có nông sản chín sẵn sàng thu hoạch.
  int get readyToHarvestCount {
    return plots.where((p) => p.isReadyForHarvest()).length;
  }

  /// Đếm số ô đất đang phát triển cần tưới nước.
  int get growingPlotsCount {
    return plots.where((p) => p.state == PlotState.growing || p.state == PlotState.sprout).length;
  }

  GardenState copyWith({
    List<PlotModel>? plots,
    GardenProfileModel? profile,
    int? selectedPlotIndex,
    bool clearSelectedPlot = false,
    String? selectedSeedId,
    String? notificationBanner,
    bool clearNotification = false,
    ChestRewardModel? lastChestReward,
    bool clearChestReward = false,
    bool? isLoading,
  }) {
    return GardenState(
      plots: plots ?? this.plots,
      profile: profile ?? this.profile,
      selectedPlotIndex: clearSelectedPlot ? null : (selectedPlotIndex ?? this.selectedPlotIndex),
      selectedSeedId: selectedSeedId ?? this.selectedSeedId,
      notificationBanner: clearNotification ? null : (notificationBanner ?? this.notificationBanner),
      lastChestReward: clearChestReward ? null : (lastChestReward ?? this.lastChestReward),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider của Repository
final gardenRepositoryProvider = Provider<GardenRepository>((ref) {
  return LocalGardenRepository();
});

/// Notifier điều khiển Nông Trại Thức Giấc kế thừa Riverpod Notifier chuẩn
class GardenNotifier extends Notifier<GardenState> {
  GardenRepository get _repository => ref.read(gardenRepositoryProvider);
  Timer? _ticker;

  @override
  GardenState build() {
    ref.onDispose(() {
      _ticker?.cancel();
    });

    Future.microtask(() => _init());

    return GardenState(
      plots: List.generate(16, (i) => PlotModel(index: i)),
      profile: const GardenProfileModel(),
      isLoading: true,
    );
  }

  Future<void> _init() async {
    final profile = await _repository.loadProfile();
    final plots = await _repository.loadPlots();

    state = state.copyWith(
      profile: profile,
      plots: plots,
      isLoading: false,
    );

    // Kiểm tra ngay các cây đã chín trong thời gian tắt app
    _checkMaturePlots();

    // Bắt đầu ticker đếm ngược mỗi giây
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkMaturePlots();
    });
  }

  void _checkMaturePlots() {
    final now = DateTime.now();
    bool hasChanges = false;
    final updatedPlots = List<PlotModel>.from(state.plots);

    for (int i = 0; i < updatedPlots.length; i++) {
      final plot = updatedPlots[i];
      if ((plot.state == PlotState.growing || plot.state == PlotState.sprout) &&
          plot.remainingSeconds(now) <= 0) {
        // Cây đã chín! Kích hoạt cơ chế Gacha đột biến màu sắc
        final seed = SeedsCatalog.findById(plot.seedId ?? 'radish') ?? SeedsCatalog.radish;
        final mutation = MutationEngine.determineMutation(seed);

        updatedPlots[i] = plot.copyWith(
          state: PlotState.mature,
          mutationVariantId: mutation.id,
        );
        hasChanges = true;
      }
    }

    if (hasChanges) {
      state = state.copyWith(plots: updatedPlots);
      _repository.savePlots(updatedPlots);
    }
  }

  /// Chọn một ô đất trên bản đồ Isometric.
  void selectPlot(int index) {
    if (state.selectedPlotIndex == index) {
      state = state.copyWith(clearSelectedPlot: true);
    } else {
      state = state.copyWith(selectedPlotIndex: index);
    }
  }

  /// Chọn hạt giống đang cầm trên tay.
  void selectSeed(String seedId) {
    state = state.copyWith(selectedSeedId: seedId);
  }

  /// Gieo hạt giống đã chọn vào ô đất cụ thể.
  bool plantSeed(int plotIndex) {
    if (plotIndex < 0 || plotIndex >= state.plots.length) return false;
    final plot = state.plots[plotIndex];
    if (plot.state != PlotState.empty) return false;

    final seedId = state.selectedSeedId;
    final seed = SeedsCatalog.findById(seedId);
    if (seed == null) return false;

    // Kiểm tra túi đồ
    final currentCount = state.profile.inventory[seedId] ?? 0;
    if (currentCount <= 0) {
      showBanner('Hết hạt giống ${seed.name}! Hãy vào Cửa hàng để nhận thêm.');
      return false;
    }

    // Trừ hạt giống
    final newInventory = Map<String, int>.from(state.profile.inventory);
    newInventory[seedId] = currentCount - 1;

    final updatedPlots = List<PlotModel>.from(state.plots);
    updatedPlots[plotIndex] = PlotModel(
      index: plotIndex,
      state: PlotState.sprout,
      seedId: seedId,
      plantedAt: DateTime.now(),
      growDurationSeconds: seed.growSeconds,
    );

    // Cập nhật nhiệm vụ trồng cây nếu có
    final updatedTasks = Map<String, int>.from(state.profile.taskProgress);
    if (seedId == 'pumpkin') {
      updatedTasks['plant_pumpkin'] = (updatedTasks['plant_pumpkin'] ?? 0) + 1;
    }

    final newProfile = state.profile.copyWith(
      inventory: newInventory,
      taskProgress: updatedTasks,
    );

    state = state.copyWith(
      plots: updatedPlots,
      profile: newProfile,
      clearSelectedPlot: true,
    );

    _repository.savePlots(updatedPlots);
    _repository.saveProfile(newProfile);
    return true;
  }

  /// Gieo hạt giống hàng loạt vào tất cả các ô đất còn trống.
  void plantAll(String seedId) {
    final seed = SeedsCatalog.findById(seedId);
    if (seed == null) return;

    int currentCount = state.profile.inventory[seedId] ?? 0;
    if (currentCount <= 0) {
      showBanner('Hết hạt giống ${seed.name}! Hãy mua thêm trong Cửa hàng.');
      return;
    }

    final updatedPlots = List<PlotModel>.from(state.plots);
    int plantedCount = 0;

    for (int i = 0; i < updatedPlots.length && currentCount > 0; i++) {
      if (updatedPlots[i].state == PlotState.empty) {
        updatedPlots[i] = PlotModel(
          index: i,
          state: PlotState.sprout,
          seedId: seedId,
          plantedAt: DateTime.now(),
          growDurationSeconds: seed.growSeconds,
        );
        currentCount--;
        plantedCount++;
      }
    }

    if (plantedCount > 0) {
      final newInventory = Map<String, int>.from(state.profile.inventory);
      newInventory[seedId] = currentCount;

      final newProfile = state.profile.copyWith(inventory: newInventory);
      state = state.copyWith(
        plots: updatedPlots,
        profile: newProfile,
      );
      _repository.savePlots(updatedPlots);
      _repository.saveProfile(newProfile);
      showBanner('Đã gieo thành công $plantedCount ô ${seed.name}!');
    }
  }

  /// Tưới nước 1 ô đất: giảm thời gian đếm ngược & cộng năng lượng rương.
  void waterPlot(int plotIndex) {
    if (plotIndex < 0 || plotIndex >= state.plots.length) return;
    final plot = state.plots[plotIndex];
    if (plot.state != PlotState.growing && plot.state != PlotState.sprout) return;

    final reduction = MutationEngine.calculateWaterReduction();
    final updatedPlots = List<PlotModel>.from(state.plots);
    updatedPlots[plotIndex] = plot.copyWith(
      reducedSeconds: plot.reducedSeconds + reduction,
    );

    // Cộng năng lượng Rương thần kỳ (+5 điểm)
    final newEnergy = (state.profile.chestEnergy + 5).clamp(0, state.profile.maxChestEnergy);
    final newProfile = state.profile.copyWith(chestEnergy: newEnergy);

    state = state.copyWith(
      plots: updatedPlots,
      profile: newProfile,
    );

    _repository.savePlots(updatedPlots);
    _repository.saveProfile(newProfile);
    _checkMaturePlots();
  }

  /// Nút Tưới nước bên trái: tưới toàn bộ các ô đang trồng.
  void waterAll() {
    int count = 0;
    final updatedPlots = List<PlotModel>.from(state.plots);

    for (int i = 0; i < updatedPlots.length; i++) {
      final plot = updatedPlots[i];
      if (plot.state == PlotState.growing || plot.state == PlotState.sprout) {
        final reduction = MutationEngine.calculateWaterReduction();
        updatedPlots[i] = plot.copyWith(
          reducedSeconds: plot.reducedSeconds + reduction,
        );
        count++;
      }
    }

    if (count > 0) {
      final addedEnergy = count * 6;
      final newEnergy = (state.profile.chestEnergy + addedEnergy).clamp(0, state.profile.maxChestEnergy);
      final newProfile = state.profile.copyWith(chestEnergy: newEnergy);

      state = state.copyWith(
        plots: updatedPlots,
        profile: newProfile,
      );
      _repository.savePlots(updatedPlots);
      _repository.saveProfile(newProfile);
      _checkMaturePlots();
      showBanner('Đã tưới nước $count ô đất (-5s mỗi ô, +$addedEnergy Năng lượng Rương)!');
    }
  }

  /// Thu hoạch một ô đất đã chín.
  void harvestPlot(int plotIndex) {
    if (plotIndex < 0 || plotIndex >= state.plots.length) return;
    final plot = state.plots[plotIndex];
    if (!plot.isReadyForHarvest()) return;

    final variant = SeedsCatalog.findVariantById(plot.mutationVariantId ?? '');
    final rewardCoins = variant?.rewardCoins ?? 15;
    final rewardEnergy = variant?.rewardEnergy ?? 8;
    final exp = variant?.exp ?? 10;

    final updatedPlots = List<PlotModel>.from(state.plots);
    updatedPlots[plotIndex] = PlotModel(index: plotIndex); // Trở về đất trống

    // Cập nhật profile
    final unlocked = Set<String>.from(state.profile.unlockedVariantIds);
    if (variant != null) {
      unlocked.add(variant.id);
    }

    final newEnergy = (state.profile.chestEnergy + rewardEnergy).clamp(0, state.profile.maxChestEnergy);
    final newCoins = state.profile.coins + rewardCoins;
    final newExp = state.profile.exp + exp;

    final newProfile = state.profile.copyWith(
      coins: newCoins,
      chestEnergy: newEnergy,
      exp: newExp,
      unlockedVariantIds: unlocked,
    );

    state = state.copyWith(
      plots: updatedPlots,
      profile: newProfile,
    );

    _repository.savePlots(updatedPlots);
    _repository.saveProfile(newProfile);

    showBanner('Thu hoạch: ${variant?.name ?? 'Nông sản'} (+$rewardCoins Xu, +$rewardEnergy Năng lượng)!');
  }

  /// Nút Thu hoạch tất cả bên trái: thu hoạch toàn bộ cây chín cùng lúc.
  void harvestAll() {
    int totalCoins = 0;
    int totalEnergy = 0;
    int count = 0;
    final updatedPlots = List<PlotModel>.from(state.plots);
    final unlocked = Set<String>.from(state.profile.unlockedVariantIds);

    for (int i = 0; i < updatedPlots.length; i++) {
      final plot = updatedPlots[i];
      if (plot.isReadyForHarvest()) {
        final variant = SeedsCatalog.findVariantById(plot.mutationVariantId ?? '');
        totalCoins += variant?.rewardCoins ?? 15;
        totalEnergy += variant?.rewardEnergy ?? 8;
        if (variant != null) unlocked.add(variant.id);
        updatedPlots[i] = PlotModel(index: i);
        count++;
      }
    }

    if (count > 0) {
      final newEnergy = (state.profile.chestEnergy + totalEnergy).clamp(0, state.profile.maxChestEnergy);
      final newCoins = state.profile.coins + totalCoins;

      final newProfile = state.profile.copyWith(
        coins: newCoins,
        chestEnergy: newEnergy,
        unlockedVariantIds: unlocked,
      );

      state = state.copyWith(
        plots: updatedPlots,
        profile: newProfile,
      );

      _repository.savePlots(updatedPlots);
      _repository.saveProfile(newProfile);
      showBanner('Thu hoạch $count ô thành công: +$totalCoins Xu, +$totalEnergy Năng lượng Rương!');
    }
  }

  /// Mua hạt giống trong Cửa hàng (Shop).
  bool buySeed(String seedId, int quantity) {
    final seed = SeedsCatalog.findById(seedId);
    if (seed == null || quantity <= 0) return false;

    final totalCost = seed.price * quantity;
    if (state.profile.coins < totalCost) {
      showBanner('Không đủ Xu nông trại để mua $quantity gói ${seed.name}!');
      return false;
    }

    final newCoins = state.profile.coins - totalCost;
    final newInventory = Map<String, int>.from(state.profile.inventory);
    newInventory[seedId] = (newInventory[seedId] ?? 0) + quantity;

    final newProfile = state.profile.copyWith(
      coins: newCoins,
      inventory: newInventory,
    );

    state = state.copyWith(profile: newProfile);
    _repository.saveProfile(newProfile);
    showBanner('Đã mua thành công $quantity gói ${seed.name}!');
    return true;
  }

  /// Mở Rương Thần Kỳ khi thanh năng lượng đạt tối đa.
  ChestRewardModel? openChest() {
    if (!state.profile.isChestReady) {
      showBanner('Chưa đủ năng lượng rương (${state.profile.chestEnergy}/${state.profile.maxChestEnergy})!');
      return null;
    }

    final reward = MutationEngine.generateChestReward(ChestType.normal);

    final newCoins = state.profile.coins + reward.coins;
    final newInventory = Map<String, int>.from(state.profile.inventory);
    reward.bonusSeeds.forEach((seedId, count) {
      newInventory[seedId] = (newInventory[seedId] ?? 0) + count;
    });

    final newProfile = state.profile.copyWith(
      coins: newCoins,
      chestEnergy: 0, // Reset năng lượng
      chestsOpened: state.profile.chestsOpened + 1,
      inventory: newInventory,
    );

    state = state.copyWith(
      profile: newProfile,
      lastChestReward: reward,
    );

    _repository.saveProfile(newProfile);
    return reward;
  }

  /// Thưởng tài nguyên khi người dùng tắt báo thức đúng giờ buổi sáng.
  void awardMorningAlarmBonus() {
    final newCoins = state.profile.coins + 80;
    final newInventory = Map<String, int>.from(state.profile.inventory);
    newInventory['radish'] = (newInventory['radish'] ?? 0) + 10;
    newInventory['corn'] = (newInventory['corn'] ?? 0) + 3;

    final newEnergy = (state.profile.chestEnergy + 50).clamp(0, state.profile.maxChestEnergy);
    final newProfile = state.profile.copyWith(
      coins: newCoins,
      chestEnergy: newEnergy,
      inventory: newInventory,
    );

    state = state.copyWith(profile: newProfile);
    _repository.saveProfile(newProfile);
    showBanner('☀️ Dậy đúng giờ: Nhận ngay +80 Xu, +50 Năng lượng & 13 Hạt giống!');
  }

  /// Hiển thị thông báo banner nhanh ở góc trên.
  void showBanner(String message) {
    state = state.copyWith(notificationBanner: message);
  }

  void clearBanner() {
    state = state.copyWith(clearNotification: true);
  }
}

/// Provider chính thức cung cấp GardenNotifier
final gardenProvider = NotifierProvider<GardenNotifier, GardenState>(GardenNotifier.new);
