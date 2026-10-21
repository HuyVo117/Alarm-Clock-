# Trạng thái dự án (cập nhật lần cuối: 2026-10-21 18:00)

## Đang ở đâu
- Giai đoạn hiện tại: GĐ 8: Nông Trại Thức Giấc (Wake-up Farm)
- Nhiệm vụ đang làm: Hoàn tất trọn bộ tính năng Nông Trại Thức Giấc (Isometric 2.5D, Gacha đột biến màu sắc, Shop, Rương thần kỳ, Sổ tay, Bạn bè)
- Tình trạng: đã hoàn thành

## Đã xong
- [x] Push bản Release v0.7.0 và tag lên GitHub repository thành công
- [x] Lập kế hoạch chi tiết và lộ trình triển khai Nông Trại Thức Giấc (`docs/GARDEN_ROADMAP.md`)
- [x] Xây dựng Domain Models: `PlotModel`, `SeedModel`, `CropVariantModel`, `ChestRewardModel`, `GardenProfileModel`
- [x] Xây dựng Module Toán học Isometric 2.5D: `IsometricMath` (chuyển đổi lưới 4x4 <-> màn hình, phát hiện chạm)
- [x] Xây dựng Bộ máy Đột biến màu sắc & Thưởng rương: `MutationEngine`
- [x] Xây dựng Data Catalog: `SeedsCatalog` (Củ cải 0đ, Bắp ngọt, Bí ngô thần kỳ)
- [x] Xây dựng Local Storage: `LocalGardenRepository` (`garden_state.json`)
- [x] Xây dựng State Management: `GardenNotifier` kế thừa chuẩn Riverpod `Notifier<GardenState>`
- [x] Vẽ đồ họa CustomPainter: `IsometricIslandPainter` (hòn đảo nổi 3D, 16 ô đất cày xới, viền phát sáng, cây trồng)
- [x] Xây dựng HUD & Điều khiển: `FarmHeaderHud`, `FarmQuickActions`, `FarmBottomBar`, `SeedDrawerSheet`
- [x] Xây dựng Modals: `FarmShopModal` (bộ chọn số lượng 1-99), `ChestRewardModal`, `CropHandbookModal`, `FriendFarmModal`
- [x] Tích hợp màn hình chính `GardenScreen` vào Tab Khu vườn
- [x] Viết Unit Tests đầy đủ: 18 unit tests cho Nông trại (tổng 105/105 unit tests toàn dự án pass 100%)
- [x] `flutter analyze` sạch không có lỗi (0 issues)

## Việc tiếp theo (theo thứ tự)
1. Kết nối với sự kiện hoàn thành thức dậy của Báo thức để tự động gọi `awardMorningAlarmBonus`
2. Đóng gói release APK và test trải nghiệm trên thiết bị thật

## File đang làm dở
- Không có (tính năng Nông Trại Thức Giấc đã hoàn thiện đầy đủ)

## Quyết định đã chốt (không bàn lại)
- Dùng Riverpod, go_router, drift (schemaVersion = 3)
- Giao diện Cupertino dark theme, màu cam `#FF9500`
- Mini-game Nông Trại dùng Flutter Canvas CustomPainter + Toán Isometric 2.5D không phụ thuộc game engine ngoài
- Lưu trữ Nông trại bằng JSON cục bộ (`garden_state.json`) an toàn, độc lập, dễ test

## Vấn đề đang gặp / chưa giải quyết
- Không có

## Cách chạy và kiểm tra
- Lệnh: `cd wake_up && flutter analyze && flutter test`
- Đã test tay trên máy thật: Đã build release APK, nạp và chạy thành công trên máy thật CPH2505 (Android 15), tab Thế giới hoạt động hoàn hảo.
