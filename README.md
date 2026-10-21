# ⏰ Wake Up — Ứng dụng Báo Thức Phong Cách iPhone

Ứng dụng báo thức cao cấp trên nền tảng Flutter, mang phong cách giao diện Apple Clock (iOS Dark Theme) với màu nhấn cam, hệ thống tính toán chu kỳ chính xác, hỗ trợ **video nền tùy chỉnh khi chuông reo** và các chế độ đánh thức sâu.

---

## 📱 Tính năng chính

### 1. Báo thức cốt lõi (Core Alarms)
- **Giao diện chuẩn iOS kết hợp One UI**: Nền đen sâu (`#000000`), chữ số mảnh lớn, nút điều khiển màu cam (`#FF9500`).
- **Bộ chọn giờ Samsung Clock (One UI Time Picker)**:
  - Bố cục 3 cột trực quan, dễ thao tác: **Buổi (SA/CH) | Giờ (1-12) | Phút (00-59)**.
  - Vạch highlight trung tâm với số to nổi bật, cuộn vô hạn mượt mà kèm phản hồi xúc giác (**Haptic Feedback**).
  - Tích hợp banner đếm ngược thời gian trực quan: *"Báo thức sẽ reo sau X giờ Y phút"* ngay bên trên bộ chọn giờ.
- **Lặp lại thông minh**: Đặt báo thức 1 lần hoặc lặp theo các thứ trong tuần (các ngày trong tuần, cuối tuần, hàng ngày...).
- **Tính toán lần kêu kế tiếp**: Thuật toán Dart thuần tính thời điểm reo chính xác, tự bù qua nửa đêm, cuối tháng, cuối năm.
- **Hệ thống Báo lại (Snooze)**: Giới hạn số lần báo lại, khoảng thời gian giãn cách linh hoạt (mặc định 5 phút).

### 2. Tùy chỉnh Âm thanh Báo thức (Sound Settings & Ringtone Picker)
- **Giao diện chọn âm thanh iOS Clock (`SoundPickerScreen`)**:
  - Tích hợp mục **Âm thanh** ngay trong màn hình chỉnh sửa báo thức với tên âm thanh hiện tại và mũi tên điều hướng.
  - **Nghe thử trực tiếp (`Live Audio Preview`)**: Chạm vào bất kỳ nhạc chuông nào để nghe thử ngay lập tức qua `just_audio`.
  - **Kho nhạc chuông có sẵn đa dạng**: *Mặc định hệ thống*, *Cổ điển (Classic)*, *Radar*, *Chuông ngân (Gentle Chime)*, *Đồng hồ điện tử (Digital Beep)*.
  - **Chọn file âm thanh từ máy**: Hỗ trợ nạp các định dạng `.mp3`, `.wav`, `.m4a`, `.flac`, `.ogg`, `.aac` từ bộ nhớ máy qua `FilePicker` và sao chép an toàn vào sandbox nội bộ của ứng dụng.

### 3. Video nền báo thức (Video Alarm Background)
- Cho phép người dùng **chọn bất kỳ video nào từ thư viện máy** làm màn hình nền khi chuông reo.
- Tự động sao chép video vào vùng lưu trữ an toàn của ứng dụng để tránh bị mất file gốc.
- Khi báo thức kêu, video tự động phát toàn màn hình lặp lại (`looping`) kèm lớp phủ gradient bóng mờ giúp giờ và nút bấm luôn sắc nét.

### 4. Thử thách thức dậy (Wake-Up Challenges — Giai đoạn 3 & Nâng cấp Camera)
Chống ngủ nướng chủ động bằng các nhiệm vụ ép não bộ và cơ thể phải tỉnh táo trước khi chuông được phép tắt:
- **Thử thách Selfie trước gương (Mirror Selfie Challenge)**:
  - Tích hợp camera trước với khung oval gương soi phong cách Apple Camera, viền đổi màu thời gian thực theo trạng thái nhận diện.
  - Sử dụng **Google ML Kit Face Detection** (100% On-device, bảo mật tuyệt đối, hoạt động offline):
    - Kiểm tra góc quay mặt thẳng (`eulerY <= 25°`).
    - Kiểm tra mở cả hai mắt (`eyeOpenProbability >= 0.4`).
    - Yêu cầu giữ yên khuôn mặt từ 2 đến 5 giây kèm thanh tiến trình Cupertino mượt mà.
  - Tích hợp nút trợ sáng màn hình (Screen Flash Light) khi thức dậy trong phòng tối và nút chụp thủ công.
- **Thử thách Chụp ảnh rời giường (Photo Comparison Challenge)**:
  - Buộc người dùng phải rời khỏi giường đến vị trí cố định (bồn rửa mặt trong nhà vệ sinh, bàn học/làm việc, cây cảnh...) chụp ảnh đối chiếu để tắt chuông.
  - Cho phép đăng ký ảnh mẫu tham chiếu (`PhotoSetupScreen`) và chụp ảnh đối chiếu (`PhotoChallengeScreen`) với ảnh thu nhỏ Picture-in-Picture.
  - Thuật toán thị giác máy tính Dart thuần: phân tích 32-bin histogram màu sắc & độ sáng (ITU-R BT.601) kết hợp Cosine Similarity độ chính xác cao.
- **Thử thách giải toán (Math Challenge)**:
  - Bắt buộc giải các câu hỏi toán học từ 1 đến 10 câu với 3 mức độ khó (Dễ: 10-99 cộng trừ; Vừa: có nhân chia; Khó: hỗn hợp phép tính).
  - Bàn phím số iOS tùy biến với hiệu ứng xúc giác, phản hồi trạng thái tức thì ("Đúng!" màu xanh, "Sai!" rung cảnh báo), tự động chuyển câu hỏi tiếp theo.
- **Thử thách lắc điện thoại (Shake Challenge)**:
  - Yêu cầu người dùng vận động cơ bắp bằng cách lắc máy đủ số lần đặt trước (10 - 100 lần).
  - Sử dụng cảm biến gia tốc `sensors_plus` kèm thuật toán chống gian lận (debounce lắc quá nhanh) và thanh tiến trình hiển thị trực quan.
- **Thử thách quét mã QR / Barcode (QR Challenge)**:
  - Tích hợp camera thời gian thực qua `mobile_scanner`.
  - Buộc người dùng quét đúng mã vạch / mã QR đã lưu trong nhà.
- **Tích hợp liền mạch & Lối thoát khẩn cấp (Emergency Exit)**:
  - Tùy chỉnh thử thách trực tiếp trong màn hình tạo/sửa báo thức.
  - Khi chuông reo, nút "Tắt báo thức" chuyển sang kích hoạt thử thách; vượt qua toàn bộ thử thách chuông mới tự động tắt.
  - **Lối thoát an toàn**: Luôn có nút giữ 10 giây kèm vòng tròn đếm ngược để tắt chuông trong trường hợp khẩn cấp theo đúng quy định an toàn.

### 5. Đồng hồ Thế giới (World Clock)
- **Giao diện chuẩn iOS Dark Theme**: Danh sách các thành phố đã lưu hiển thị giờ điện tử lớn, chênh lệch múi giờ (Hôm nay, +X giờ / -X giờ) và chỉ báo Ngày / Đêm.
- **Hơn 120 thành phố toàn cầu**: Tích hợp danh mục thành phố quốc tế phong phú kèm mã múi giờ IANA chuẩn xác, tự động tính toán giờ mùa hè (DST - Daylight Saving Time).
- **Tìm kiếm thông minh**: Tìm kiếm nhanh theo tên thành phố hoặc quốc gia, hỗ trợ tiếng Việt không dấu.
- **Quản lý danh sách**: Hỗ trợ chế độ Sửa, xóa nhanh bằng vuốt (Swipe to Delete), kéo thả sắp xếp thứ tự và lưu trữ cục bộ an toàn.

### 6. Khả năng đánh thức mạnh mẽ (Reliability on Device)
- **Tự động bật sáng màn hình khóa**: Sử dụng `setShowWhenLocked(true)` và `setTurnScreenOn(true)` cùng dịch vụ Foreground Service và Full-Screen Intent để đánh thức điện thoại ngay cả khi tắt màn hình.
- **Quản lý quyền chặt chẽ**: Tự động xin cấp quyền gửi thông báo, quyền lên lịch báo thức chính xác (`SCHEDULE_EXACT_ALARM`), quyền sử dụng Camera (`CAMERA` cho Selfie và Photo Challenge) và quyền bỏ qua tối ưu hóa pin để không bị hệ điều hành tắt ngầm.
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
│   ├── challenges/            # Thử thách thức dậy (Giai đoạn 3)
│   │   ├── data/              # Quản lý sự kiện cảm biến và camera scanner
│   │   ├── domain/            # Pure Dart logic (MathChallenge, ShakeChallenge, QrChallenge, Factory)
│   │   └── presentation/      # MathChallengeScreen, ShakeChallengeScreen, QrChallengeScreen
│   ├── media/
│   │   ├── data/              # MediaService (chọn & lưu video/âm thanh tùy chỉnh)
│   │   ├── domain/            # AlarmSound (model âm thanh có sẵn, helper phân giải tên)
│   │   └── presentation/      # SoundPickerScreen (trình chọn & nghe thử nhạc chuông iOS)
│   ├── world_clock/           # Tab Đồng hồ thế giới (v0.7.0)
│   │   ├── data/              # Danh mục thành phố IANA và LocalWorldClockRepository
│   │   ├── domain/            # WorldCityModel, TimezoneCalculator (Dart thuần)
│   │   └── presentation/      # WorldClockScreen, CitySearchScreen, WorldClockCard
│   ├── bedtime/               # Tab Giờ ngủ
│   ├── garden/                # Tab Nông trại thức giấc (Đang triển khai)
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

## 📦 Tải về Bản Phát Hành (Release APK v0.7.0)

Người dùng có thể tải trực tiếp file cài đặt APK đã đóng gói sẵn:
- **Tải file APK trực tiếp**: [📥 wake-up-v0.7.0.apk](https://github.com/HuyVo117/Alarm-Clock-/raw/main/release/wake-up-v0.7.0.apk)
- **Xem phiên bản trên GitHub**: [🏷️ Release v0.7.0](https://github.com/HuyVo117/Alarm-Clock-/releases/tag/v0.7.0)
- **Bản phát hành trước đó**: [🏷️ Release v0.6.0](https://github.com/HuyVo117/Alarm-Clock-/releases/tag/v0.6.0) | [🏷️ Release v0.5.0](https://github.com/HuyVo117/Alarm-Clock-/releases/tag/v0.5.0) | [🏷️ Release v0.4.1](https://github.com/HuyVo117/Alarm-Clock-/releases/tag/v0.4.1)

### Tự tạo file cài đặt APK từ mã nguồn:
```bash
cd wake_up
flutter build apk --release --split-per-abi
```
File APK xuất xưởng sẽ nằm tại:
```
wake_up/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### Cài đặt lên thiết bị qua ADB:
```bash
adb install -r wake_up/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

## 🧪 Kiểm thử (Testing)
Dự án áp dụng quy tắc kiểm thử nghiêm ngặt: toàn bộ logic nghiệp vụ (tính ngày kế tiếp, logic báo lại, model báo thức, danh mục âm thanh, và toàn bộ bộ sinh câu hỏi / phân tích thị giác / thẩm định thử thách / tính toán múi giờ) là **Dart thuần**, không dính dáng UI hay plugin để bảo đảm 100% kiểm thử tự động (**87/87 tests passed**):
- `timezone_calculator_test.dart`: 13 kịch bản kiểm thử tính giờ địa phương, UTC offset, DST và format ngày đêm.
- `selfie_challenge_test.dart`: 7 kịch bản kiểm thử nhận diện khuôn mặt, góc nghiêng eulerY, xác suất mở mắt, thời gian giữ yên khuôn mặt và reset.
- `photo_challenge_test.dart`: 6 kịch bản kiểm thử trích xuất 32-bin histogram L1, tính Cosine Similarity, ngưỡng khớp và reset.
- `next_alarm_calculator_test.dart`: 13 kịch bản kiểm thử ranh giới thời gian (nửa đêm, chuyển tháng, năm).
- `snooze_logic_test.dart`: 8 kịch bản kiểm thử giới hạn số lần báo lại và interval.
- `alarm_sound_test.dart`: 4 kịch bản kiểm thử danh sách âm thanh có sẵn, phân giải tên và bộ bọc `SoundSelection`.
- `alarm_model_test.dart`: 2 kịch bản kiểm thử trường `soundPath` qua `copyWith` và giá trị mặc định.
- `math_challenge_test.dart`: 7 kịch bản kiểm thử 3 cấp độ toán học, kiểm tra tính toán đúng/sai, reset thử thách.
- `shake_challenge_test.dart`: 7 kịch bản kiểm thử bộ đếm gia tốc, ngưỡng rung, chống gian lận và luồng stream.
- `qr_challenge_test.dart`: 6 kịch bản kiểm thử mã hóa băm SHA-256 an toàn, khớp mã vạch, xử lý mã không hợp lệ.
- `challenge_config_test.dart` & `challenge_factory_test.dart`: 13 kịch bản kiểm thử serialize/deserialize JSON, Factory khởi tạo theo loại thử thách (bao gồm selfie và photo).
- `widget_test.dart`: Kiểm thử khởi chạy ứng dụng.

---

## 🗺️ Lộ trình phát triển (Roadmap)
Xem chi tiết lộ trình các giai đoạn của dự án tại [ROADMAP.md](wake_up/docs/ROADMAP.md).
