# Quyết định kỹ thuật dự án Wake Up

## 1. Múi giờ và Lưu trữ cho Đồng hồ Thế giới (World Clock)
- **Quyết định**: Sử dụng package `timezone: ^0.11.2` (đã nằm trong danh sách PLAN.md) và lưu trữ danh sách thành phố bằng file JSON cục bộ (`LocalWorldClockRepository`).
- **Lý do**: Tránh nâng `schemaVersion` và migration bảng mới trong SQLite/Drift; dữ liệu World Clock nhẹ (<50 mục), `timezone` cung cấp cơ sở dữ liệu IANA chuẩn xác kèm tự động xử lý DST.
