# ⏰ Wake Up — Ứng dụng Báo Thức Phong Cách iPhone

Ứng dụng báo thức cao cấp trên nền tảng Flutter, mang phong cách giao diện Apple Clock (iOS Dark Theme) với màu nhấn cam, hệ thống tính toán chu kỳ chính xác, hỗ trợ **video nền tùy chỉnh khi chuông reo** và các chế độ đánh thức sâu.

---

## 📱 Tính năng chính

### 1. Báo thức cốt lõi (Core Alarms)
- **Giao diện chuẩn iOS**: Nền đen sâu (`#000000`), chữ số mảnh lớn, nút điều khiển màu cam (`#FF9500`).
- **Cupertino Time Picker**: Con lăn chọn giờ phút mượt mà dạng bánh xe trượt.
- **Lặp lại thông minh**: Đặt báo thức 1 lần hoặc lặp theo các thứ trong tuần (các ngày trong tuần, cuối tuần, hàng ngày...).
- **Tính toán lần kêu kế tiếp**: Thuật toán Dart thuần tính thời điểm reo chính xác, tự bù qua nửa đêm, cuối tháng, cuối năm.
- **Hệ thống Báo lại (Snooze)**: Giới hạn số lần báo lại, khoảng thời gian giãn cách linh hoạt (mặc định 5 phút).

### 2. Video nền báo thức (Video Alarm Background - Mới)
- Cho phép người dùng **chọn bất kỳ video nào từ thư viện máy** làm màn hình nền khi chuông reo.
- Tự động sao chép video vào vùng lưu trữ an toàn của ứng dụng để tránh bị mất file gốc.
- Khi báo thức kêu, video tự động phát toàn màn hình lặp lại (`looping`) kèm lớp phủ gradient bóng mờ giúp giờ và nút bấm luôn sắc nét.

### 3. Khả năng đánh thức mạnh mẽ (Reliability on Device)
- **Tự động bật sáng màn hình khóa**: Sử dụng `setShowWhenLocked(true)` và `setTurnScreenOn(true)` cùng dịch vụ Foreground Service và Full-Screen Intent để đánh thức điện thoại ngay cả khi tắt màn hình.
- **Quản lý quyền chặt chẽ**: Tự động xin cấp quyền gửi thông báo, quyền lên lịch báo thức chính xác (`SCHEDULE_EXACT_ALARM`) và quyền bỏ qua tối ưu hóa pin để không bị hệ điều hành (ColorOS, MIUI, OneUI...) tắt ngầm.
- **Tự động phục hồi sau khởi động lại máy**: Hỗ trợ `RECEIVE_BOOT_COMPLETED` để tự lên lịch lại toàn bộ báo thức sau khi khởi động lại thiết bị.

---

## 🛠️ Kiến trúc kỹ thuật (Feature-First)

```
lib/
├── app.dart                   # Root widget, CupertinoApp.router, ring stream listener
├── main.dart                  # Điểm khởi chạy, WidgetsBinding & Alarm.init()
├── core/
│   ├── database/              # Drift SQLite (AppDatabase, Alarms table, migrations)
│   ├── l10n/                  # Đa ngôn ngữ (Tiếng Việt mặc định, Tiếng Anh)
│   ├── platform/              # Abstract platform interfaces (AlarmScheduler)
│   ├── router/                # GoRouter (StatefulShellRoute, bottom CupertinoTabBar)
│   └── theme/                 # AppTheme (Dark theme, typography, colors)
├── features/
│   ├── alarms/
│   │   ├── data/              # Drift AlarmRepository, AndroidAlarmScheduler, IosAlarmScheduler
│   │   ├── domain/            # Pure Dart logic (NextAlarmCalculator, SnoozeLogic, AlarmModel)
│   │   └── presentation/      # AlarmListScreen, AlarmEditScreen, AlarmRingingScreen
│   ├── media/
│   │   └── data/              # MediaService (chọn và lưu video tùy chỉnh)
│   ├── bedtime/               # Tab Giờ ngủ
│   ├── world_clock/           # Tab Đồng hồ thế giới
│   ├── garden/                # Tab Khu vườn ngủ ngon
│   └── analytics/             # Tab Thống kê hành vi
```

---

## 🚀 Hướng dẫn cài đặt & Chạy ứng dụng

### Yêu cầu môi trường:
- Flutter SDK $\ge$ 3.13.0
- Dart SDK $\ge$ 3.0.0
- Android SDK 34+ (cho Android)
- Thiết bị Android hoặc iOS kết nối máy tính

### Các bước chạy:
1. Clone dự án và truy cập thư mục:
   ```bash
   cd wake_up
   ```
2. Cài đặt các gói phụ thuộc:
   ```bash
   flutter pub get
   ```
3. Sinh mã nguồn cho Database Drift:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Kiểm tra phân tích tĩnh và chạy Unit Test:
   ```bash
   flutter analyze
   flutter test
   ```
5. Chạy trên điện thoại:
   ```bash
   flutter run
   ```

---

## 🧪 Kiểm thử (Testing)
Dự án áp dụng quy tắc kiểm thử nghiêm ngặt: toàn bộ logic nghiệp vụ (tính ngày kế tiếp, logic báo lại, chuyển đổi múi giờ) là **Dart thuần**, không dính dáng UI hay plugin để bảo đảm 100% kiểm thử tự động:
- `next_alarm_calculator_test.dart`: 13 kịch bản kiểm thử ranh giới thời gian.
- `snooze_logic_test.dart`: 8 kịch bản kiểm thử giới hạn số lần báo lại.
- `widget_test.dart`: Kiểm thử khởi chạy ứng dụng.
