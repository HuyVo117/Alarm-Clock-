import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Material;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wake_up/core/theme/app_theme.dart';
import 'package:wake_up/features/garden/domain/logic/isometric_math.dart';
import 'package:wake_up/features/garden/domain/models/plot_model.dart';
import 'controllers/garden_controller.dart';
import 'painters/isometric_island_painter.dart';
import 'widgets/chest_reward_modal.dart';
import 'widgets/crop_handbook_modal.dart';
import 'widgets/farm_bottom_bar.dart';
import 'widgets/farm_header_hud.dart';
import 'widgets/farm_quick_actions.dart';
import 'widgets/farm_shop_modal.dart';
import 'widgets/friend_farm_modal.dart';
import 'widgets/seed_drawer_sheet.dart';

/// Màn hình chính Mini-game "Nông Trại Thức Giấc" (Tab Khu Vườn).
class GardenScreen extends ConsumerStatefulWidget {
  const GardenScreen({super.key});

  @override
  ConsumerState<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends ConsumerState<GardenScreen> {
  bool _isSeedDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final gardenState = ref.watch(gardenProvider);
    final notifier = ref.read(gardenProvider.notifier);

    // Kích thước chuẩn cho lưới Isometric 4x4
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = (screenWidth * 0.42).clamp(70.0, 95.0);
    final tileHeight = tileWidth * 0.5;
    final origin = Offset(screenWidth / 2, 130);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF121214),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xCC000000),
        middle: Text(
          'Khu Vườn Thức Giấc',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // 1. Nền bầu trời nông trại ban ngày/đêm với gradient nhẹ
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 1.2,
                    colors: [
                      Color(0xFF1E2B1E), // Xanh rêu nhẹ ở tâm
                      Color(0xFF0D0D11), // Đen tối sâu ở mép
                    ],
                  ),
                ),
              ),
            ),

            // 2. Bản đồ Hòn đảo Isometric 4x4 & Vòng lặp cảm ứng
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  final tapPos = details.localPosition;
                  final grid = IsometricMath.screenToGrid(
                    screenPos: Offset(tapPos.dx, tapPos.dy - tileHeight / 2),
                    tileWidth: tileWidth,
                    tileHeight: tileHeight,
                    origin: origin,
                    gridSize: 4,
                  );

                  if (grid != null) {
                    final plotIndex = IsometricMath.gridToIndex(grid.$1, grid.$2, 4);
                    _handlePlotTap(plotIndex, gardenState, notifier);
                  }
                },
                child: CustomPaint(
                  painter: IsometricIslandPainter(
                    plots: gardenState.plots,
                    selectedPlotIndex: gardenState.selectedPlotIndex,
                    tileWidth: tileWidth,
                    tileHeight: tileHeight,
                    origin: origin,
                  ),
                ),
              ),
            ),

            // 3. Header HUD trên cùng
            Positioned(
              top: 12,
              left: 14,
              right: 14,
              child: FarmHeaderHud(
                profile: gardenState.profile,
                onOpenShop: () => _openShopModal(context, gardenState.profile.coins, notifier),
                onOpenChest: () => _handleOpenChest(context, notifier),
              ),
            ),

            // 4. Các nút thao tác nhanh bên trái
            Positioned(
              left: 14,
              top: 86,
              child: FarmQuickActions(
                readyToHarvestCount: gardenState.readyToHarvestCount,
                growingCount: gardenState.growingPlotsCount,
                onWaterAll: () => notifier.waterAll(),
                onHarvestAll: () => notifier.harvestAll(),
              ),
            ),

            // 5. Banner thông báo thành tích / thu hoạch ở góc trên
            if (gardenState.notificationBanner != null)
              Positioned(
                top: 76,
                left: 30,
                right: 30,
                child: GestureDetector(
                  onTap: () => notifier.clearBanner(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.bell_fill, color: Colors.black, size: 14),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            gardenState.notificationBanner!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 6. Thanh Footer điều hướng phía dưới
            Positioned(
              left: 14,
              right: 14,
              bottom: _isSeedDrawerOpen ? 185 : 12,
              child: FarmBottomBar(
                pumpkinPlantedCount: gardenState.profile.taskProgress['plant_pumpkin'] ?? 0,
                unlockedVariantsCount: gardenState.profile.unlockedVariantIds.length,
                isSeedDrawerOpen: _isSeedDrawerOpen,
                onToggleSeedDrawer: () {
                  setState(() => _isSeedDrawerOpen = !_isSeedDrawerOpen);
                },
                onOpenHandbook: () => _openHandbookModal(context, gardenState.profile.unlockedVariantIds),
                onOpenFriends: () => _openFriendsModal(context, notifier),
              ),
            ),

            // 7. Khay Hạt giống trượt từ đáy màn hình lên
            if (_isSeedDrawerOpen)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SeedDrawerSheet(
                  inventory: gardenState.profile.inventory,
                  selectedSeedId: gardenState.selectedSeedId,
                  onSelectSeed: (seedId) {
                    notifier.selectSeed(seedId);
                  },
                  onPlantAll: (seedId) {
                    notifier.plantAll(seedId);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Xử lý khi chạm vào một ô đất trên bản đồ Isometric.
  void _handlePlotTap(int plotIndex, GardenState state, GardenNotifier notifier) {
    if (plotIndex < 0 || plotIndex >= state.plots.length) return;
    final plot = state.plots[plotIndex];

    if (plot.isReadyForHarvest()) {
      // 1. Cây đã chín -> Thu hoạch ngay
      notifier.harvestPlot(plotIndex);
    } else if (plot.state == PlotState.growing || plot.state == PlotState.sprout) {
      // 2. Cây đang lớn -> Tưới nước
      notifier.waterPlot(plotIndex);
    } else if (plot.state == PlotState.empty) {
      // 3. Đất trống -> Gieo hạt giống đang chọn
      final success = notifier.plantSeed(plotIndex);
      if (!success && !_isSeedDrawerOpen) {
        setState(() => _isSeedDrawerOpen = true);
      }
    }
  }

  /// Mở popup Cửa hàng mua hạt giống.
  void _openShopModal(BuildContext context, int coins, GardenNotifier notifier) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => FarmShopModal(
        coins: coins,
        onBuy: (seedId, quantity) {
          notifier.buySeed(seedId, quantity);
        },
      ),
    );
  }

  /// Mở Rương Thần Kỳ khi đạt đủ năng lượng.
  void _handleOpenChest(BuildContext context, GardenNotifier notifier) {
    final reward = notifier.openChest();
    if (reward != null) {
      showCupertinoDialog(
        context: context,
        builder: (_) => Center(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ChestRewardModal(
                reward: reward,
                onClaim: () {},
              ),
            ),
          ),
        ),
      );
    }
  }

  /// Mở Sổ tay bộ sưu tập nông sản.
  void _openHandbookModal(BuildContext context, Set<String> unlockedIds) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CropHandbookModal(unlockedVariantIds: unlockedIds),
    );
  }

  /// Mở Modal ghé thăm nông trại bạn bè.
  void _openFriendsModal(BuildContext context, GardenNotifier notifier) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => FriendFarmModal(
        onWaterFriend: (name) {
          notifier.showBanner('Đã tưới nước giúp $name: Nhận +25 Xu & +15 Năng lượng! 💧');
        },
      ),
    );
  }
}
