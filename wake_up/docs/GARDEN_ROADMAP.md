# 🌾 KẾ HOẠCH TRIỂN KHAI CHO GEMINI CODE: NÔNG TRẠI THỨC GIẤC (WAKE-UP FARM)

> **Mục tiêu**: Xây dựng hoàn chỉnh mini-game "Nông Trại Thức Giấc" (Isometric 2.5D Farm) tích hợp bên trong ứng dụng Báo thức Wake Up (Tab Khu vườn / Garden).
> **Nguyên tắc**: 
> 1. Feature-first architecture: `lib/features/garden/{domain, data, presentation}`
> 2. Logic thuần Dart không dính UI, có Unit Tests đạt 100% pass.
> 3. Đồ họa Isometric vẽ bằng Canvas (`CustomPainter`) kết hợp Animated Widgets, siêu nhẹ và 60fps.
> 4. Lưu trữ trạng thái bằng JSON Local Storage (`garden_storage.json`).

---

## 📋 DANH SÁCH TASK CHI TIẾT THEO TỪNG BƯỚC

### 📍 GIAI ĐOẠN 1: Domain Models & Pure Dart Logic (Kèm Unit Tests)

#### Task 1.1: Tạo Domain Models
- **File**: `lib/features/garden/domain/models/plot_model.dart`
  - Enum `PlotState` (`empty`, `sprout`, `growing`, `mature`, `harvested`)
  - Class `PlotModel`: `index`, `state`, `seedId`, `plantedAt`, `growDurationSeconds`, `reducedSeconds`, `mutationVariantId`
  - Các helper: `isReadyForHarvest`, `remainingSeconds(DateTime now)`, `copyWith`, `toJson`, `fromJson`
- **File**: `lib/features/garden/domain/models/seed_model.dart`
  - Class `SeedModel`: `id`, `name`, `icon`, `price`, `growSeconds`, `category` (all, normal, special), `variants`
- **File**: `lib/features/garden/domain/models/crop_variant_model.dart`
  - Enum `CropRarity` (`common`, `rare`, `legendary`)
  - Class `CropVariantModel`: `id`, `name`, `colorHex`, `rarity`, `dropRate`, `rewardCoins`, `rewardEnergy`
- **File**: `lib/features/garden/domain/models/garden_profile_model.dart`
  - Class `GardenProfileModel`: `coins`, `chestEnergy`, `maxChestEnergy`, `unlockedCropIds`, `inventory` (`Map<String, int>`), `tasks`
- **File**: `lib/features/garden/domain/models/chest_reward_model.dart`
  - Class `ChestRewardModel`: `coins`, `chestEnergy`, `bonusSeeds`, `description`

#### Task 1.2: Thuật toán Tọa độ Isometric 2.5D
- **File**: `lib/features/garden/domain/logic/isometric_math.dart`
  - `gridToScreen(int col, int row, double tileWidth, double tileHeight, Offset origin)`
  - `screenToGrid(Offset screenPos, double tileWidth, double tileHeight, Offset origin, int gridSize)`
  - `getDiamondPath(Offset center, double tileWidth, double tileHeight)`
- **Test**: `test/features/garden/isometric_math_test.dart` (test chiếu thuận và nghịch đảo)

#### Task 1.3: Thuật toán Gacha Đột biến & Tính thưởng
- **File**: `lib/features/garden/domain/logic/mutation_engine.dart`
  - `determineMutation(SeedModel seed, [Random? random])`: Xác suất ngẫu nhiên rơi vào Common (70%), Rare (25%), Legendary (5%).
- **File**: `lib/features/garden/domain/logic/garden_calculator.dart`
  - `calculateWaterReduction(int remainingSeconds, int baseReduction)`
  - `calculateHarvestReward(CropVariantModel variant)`
- **Test**: `test/features/garden/mutation_engine_test.dart` & `test/features/garden/garden_calculator_test.dart`

---

### 📍 GIAI ĐOẠN 2: Data Catalog & Local Storage

#### Task 2.1: Danh mục Hạt giống & Biến thể Nông sản
- **File**: `lib/features/garden/data/seeds_catalog.dart`
  - Củ cải trắng (`radish`): Giá 0 xu (miễn phí để cày rương), thời gian 15 giây (hoặc chỉnh được), 3 biến thể (Trắng, Đỏ thẫm, Vàng kim).
  - Ngô ngọt (`corn`): Giá 50 xu, thời gian 60 giây, 3 biến thể (Vàng tươi, Đỏ tím, Hổ phách kim).
  - Bí ngô thần kỳ (`pumpkin`): Giá 120 xu, thời gian 180 giây, biến thể hiếm.
- **File**: `lib/features/garden/data/crops_catalog.dart`
  - Tổng hợp 12+ biến thể màu sắc, tỷ lệ drop và điểm thưởng.

#### Task 2.2: Repository Lưu trữ JSON Cục bộ
- **File**: `lib/features/garden/data/garden_repository.dart`
  - Interface `GardenRepository`: `loadProfile()`, `saveProfile()`, `loadPlots()`, `savePlots()`
  - Triển khai `LocalGardenRepository` ghi đọc file `garden_storage.json`.

---

### 📍 GIAI ĐOẠN 3: Đồ họa Bản đồ Isometric 4x4 & Vòng lặp Nông trại

#### Task 3.1: Riverpod Controller
- **File**: `lib/features/garden/presentation/controllers/garden_controller.dart`
  - Quản lý state `GardenState`: `profile`, `plots` (16 ô), `selectedPlotIndex`, `isWatering`, `isHarvesting`.
  - Các hàm: `selectPlot()`, `plantSeed(int plotIndex, String seedId)`, `plantAll(String seedId)`, `waterPlot(int plotIndex)`, `waterAll()`, `harvestPlot(int plotIndex)`, `harvestAll()`, `openChest()`.

#### Task 3.2: CustomPainter Bản đồ Đảo nổi Isometric
- **File**: `lib/features/garden/presentation/painters/isometric_island_painter.dart`
  - Vẽ nền đảo nổi xanh mướt, viền nổi 3D Isometric.
  - Vẽ lưới 16 ô đất cày xới hình thoi (4x4).
  - Vẽ hiệu ứng viền vàng phát sáng khi một ô đất được chọn.
  - Vẽ cây trồng theo trạng thái: Mầm xanh nhú -> Đang lớn đếm ngược -> Chín phát sáng cột hào quang.

#### Task 3.3: Hiệu ứng Tia sét Xanh Nạp Rương
- **File**: `lib/features/garden/presentation/painters/lightning_particle_painter.dart`
  - Tạo luồng hạt tia sét xanh bay từ vị trí ô đất lên biểu tượng Rương ở góc trên phải.

#### Task 3.4: HUD Header & Quick Actions
- **File**: `lib/features/garden/presentation/widgets/farm_header_hud.dart`: Avatar, Tên nông trại, Số xu, Thanh năng lượng Rương (`234/300`).
- **File**: `lib/features/garden/presentation/widgets/farm_quick_actions.dart`: Nút "Tưới nước" bên trái, Nút "Thu hoạch (N vị trí)".

#### Task 3.5: Khay Hạt giống Trượt từ đáy (Seed Drawer)
- **File**: `lib/features/garden/presentation/widgets/seed_drawer_sheet.dart`
  - 3 tab phân loại: Tất cả, Cơ bản, Đặc biệt.
  - Danh sách túi hạt cuộn ngang, hiện số lượng x437, icon, thời gian.

---

### 📍 GIAI ĐOẠN 4: Modal Cửa Hàng, Rương Thần Kỳ, Sổ Tay & Bạn Bè

#### Task 4.1: Cửa hàng Hạt giống (Shop Modal)
- **File**: `lib/features/garden/presentation/widgets/farm_shop_modal.dart`
  - Lưới các loại hạt giống (có loại 0 xu).
  - Panel chi tiết bên phải (đơn giá, màu sắc biến thể, thời gian lớn).
  - Thanh trượt `-` / `+` mua tối đa 99 gói.

#### Task 4.2: Popup Mở Rương Thần Kỳ (Chest Modal)
- **File**: `lib/features/garden/presentation/widgets/chest_reward_modal.dart`
  - Mở khi thanh năng lượng đạt 100%.
  - Hiệu ứng rương bừng sáng, nút "Mở tất cả" nhận Xu và Hạt giống quý.

#### Task 4.3: Sổ tay Bộ sưu tập Nông sản (Handbook Modal)
- **File**: `lib/features/garden/presentation/widgets/crop_handbook_modal.dart`
  - Thống kê tiến độ (ví dụ 12/48 biến thể).
  - Hiển thị các loại củ quả màu thường, hiếm, vàng kim (các quả chưa mở là bóng đen silhouette).

#### Task 4.4: Ghé thăm Nông trại Bạn bè (Social Co-op Modal)
- **File**: `lib/features/garden/presentation/widgets/friend_farm_modal.dart`
  - Danh sách bạn bè cùng đặt báo thức.
  - Ghé thăm nông trại bạn bè, bấm "Tưới nước hộ" để cả 2 cùng nhận thưởng.

#### Task 4.5: Màn hình chính Tab Khu vườn
- **File**: `lib/features/garden/presentation/garden_screen.dart`
  - Tích hợp tất cả các thành phần trên vào giao diện chính hoàn chỉnh.
  - Kết nối sự kiện tắt báo thức buổi sáng: tặng Xu và lượt tưới.
