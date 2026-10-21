# Trạng thái dự án (cập nhật lần cuối: 2026-10-21 15:35)

## Đang ở đâu
- Giai đoạn hiện tại: Tính năng Đồng hồ Thế giới (World Clock)
- Nhiệm vụ đang làm: Hoàn tất tính năng World Clock
- Tình trạng: đã hoàn thành

## Đã xong
- [x] Kế hoạch triển khai World Clock được người dùng duyệt
- [x] Thêm package `timezone: ^0.11.2` vào `pubspec.yaml`
- [x] Tạo domain model `WorldCityModel` (`lib/features/world_clock/domain/world_city_model.dart`)
- [x] Tạo domain service `WorldClockService` (`lib/features/world_clock/domain/world_clock_service.dart`)
- [x] Tạo bảng dữ liệu thành phố `city_data.dart` (`lib/features/world_clock/data/city_data.dart`)
- [x] Tạo repository lưu trữ cục bộ `LocalWorldClockRepository` (`lib/features/world_clock/data/world_clock_repository.dart`)
- [x] Tạo Riverpod providers `savedCitiesProvider` (`lib/features/world_clock/presentation/providers/world_clock_providers.dart`)
- [x] Tạo widget thẻ thành phố `WorldClockCard` (`lib/features/world_clock/presentation/world_clock_card.dart`)
- [x] Tạo màn hình tìm kiếm & thêm thành phố `AddCityScreen` (`lib/features/world_clock/presentation/add_city_screen.dart`)
- [x] Cập nhật màn hình chính `WorldClockScreen` (`lib/features/world_clock/presentation/world_clock_screen.dart`)
- [x] Bổ sung chuỗi l10n vào `app_vi.arb` & `app_en.arb`, chạy `flutter gen-l10n`
- [x] Tích hợp router `app_router.dart` và khởi tạo timezone trong `main.dart`
- [x] Viết unit tests cho model, service, repository (`test/features/world_clock/`) - 13/13 tests pass
- [x] `flutter analyze` sạch (0 issues), `flutter test` toàn bộ 87 tests pass

## Việc tiếp theo (theo thứ tự)
1. Kiểm tra trải nghiệm thực tế trên máy thật hoặc emulator
2. Chuẩn bị triển khai các giai đoạn tiếp theo theo ROADMAP.md

## File đang làm dở
- Không có (tính năng World Clock đã hoàn thiện)

## Quyết định đã chốt (không bàn lại)
- Dùng Riverpod, go_router, drift (schemaVersion = 3)
- Giao diện Cupertino dark theme, màu cam `#FF9500`
- World clock dùng package `timezone`, lưu trữ bằng JSON file cục bộ (`LocalWorldClockRepository`)
- Bảng tĩnh các thành phố lớn IANA được biên dịch sẵn, tính toán múi giờ và ngày/đêm bằng Dart thuần

## Vấn đề đang gặp / chưa giải quyết
- Không có

## Cách chạy và kiểm tra
- Lệnh: `cd wake_up && flutter analyze && flutter test`
- Đã test tay trên máy thật: Đã build release APK, nạp và chạy thành công trên máy thật CPH2505 (Android 15), tab Thế giới hoạt động hoàn hảo.
