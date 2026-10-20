# 📋 Nhật Ký Phát Hành (CHANGELOG)

Tất cả các thay đổi và tiến độ phát triển qua từng giai đoạn của dự án **Wake Up** được ghi chép tại đây.

---

## [0.4.1] - 2026-10-21 — Sửa lỗi lưu báo thức, Hỗ trợ nhạc video & Tối ưu video nền

### 🐛 Sửa lỗi quan trọng (Bug Fix)
- **Khắc phục triệt để lỗi không lưu được báo thức trên bản Release**:
  - Phát hiện nguyên nhân: R8 Code Shrinker trong chế độ Release làm mất phương thức reflection `SharedPreferencesApiRegistrar.getAll` của gói `shared_preferences_android` dẫn đến lỗi `NoSuchMethodError` khi lưu báo thức.
  - Thiết lập cấu hình Gradle `isMinifyEnabled = false`, `isShrinkResources = false` và bổ sung file quy tắc `proguard-rules.pro` giữ nguyên toàn bộ các lớp plugin.
  - Bổ sung khối bắt lỗi `try-catch` khi lên lịch báo thức trong `_saveAlarm` đảm bảo giao diện luôn phản hồi mượt mà.

### ✨ Cải tiến tính năng
- **Tùy chọn "Không có âm thanh (Dùng nhạc từ video)"**:
  - Bổ sung tùy chọn `none` vào danh sách nhạc chuông.
  - Khi chọn tính năng này, hệ thống sẽ sử dụng file âm thanh im lặng (`silent.wav`) cho native alarm, đồng thời tự động bật âm lượng video nền lên 100% (`setVolume(1.0)`). Người dùng có thể thưởng thức trọn vẹn âm thanh gốc của video mà không bị chuông báo thức đè lên.
  - Tự động tắt tiếng video nền (`setVolume(0.0)`) khi người dùng chọn nhạc chuông độc lập để tránh xung đột âm thanh.
- **Làm sáng và rõ nét video nền báo thức**:
  - Giảm đáng kể độ đậm của lớp phủ gradient tối (từ `0.5 - 0.8` xuống chỉ còn `0.1 - 0.3`) giúp video nền luôn hiển thị rực rỡ, sắc nét và rõ ràng.
  - Bổ sung hiệu ứng đổ bóng chữ (`Text Drop Shadows`) cho giờ hiển thị, buổi (SA/CH) và nhãn báo thức, đảm bảo thông tin luôn nổi bật và dễ đọc trên mọi khung hình video sáng hoặc tối.

---

## [0.4.0] - 2026-10-20 — Tùy chỉnh Âm thanh Báo thức & Trình phát Nhạc chuông

### ✨ Tính năng mới
- **Trình chọn âm thanh báo thức chuẩn giao diện iOS (`SoundPickerScreen`)**:
  - Cho phép người dùng tùy chọn nhạc chuông cho từng báo thức riêng biệt trong màn hình `AlarmEditScreen`.
  - Hiển thị mục **Âm thanh** với tên nhạc chuông đang chọn và mũi tên mở danh sách theo đúng trải nghiệm Apple Clock.
  - **Nghe thử trực tiếp (`Live Audio Preview`)**: Tích hợp `just_audio` để phát ngay âm thanh nghe thử khi chạm vào bất kỳ lựa chọn nào, có dấu tick cam đánh dấu mục đã chọn.
- **Kho âm thanh có sẵn đa dạng (`assets/audio/`)**:
  - *Mặc định hệ thống* (System Default Alarm Sound).
  - *Cổ điển (Classic)*: Chuông báo thức truyền thống dồn dập.
  - *Radar*: Nhịp điệu radar thôi thúc quen thuộc.
  - *Chuông ngân (Gentle Chime)*: Hợp âm chuông ngân dịu nhẹ cho buổi sáng thư thái.
  - *Đồng hồ điện tử (Digital Beep)*: Tiếng tít tít kép nhịp đôi phong cách điện tử cổ điển.
- **Chọn nhạc chuông tùy chỉnh từ máy**:
  - Tích hợp `FilePicker` cho phép người dùng nạp file nhạc từ thiết bị (`.mp3`, `.wav`, `.m4a`, `.flac`, `.ogg`, `.aac`).
  - Tự động sao chép an toàn vào thư mục nội bộ ứng dụng (`app_flutter/custom_media`) đảm bảo báo thức kêu đúng nhạc ngay cả khi file tải về bị di chuyển hay xóa.
- **Nâng cấp Cơ sở dữ liệu Drift Schema v3**:
  - Thêm cột `soundPath` vào bảng `Alarms` (`schemaVersion => 3`) kèm kịch bản `MigrationStrategy` an toàn tuyệt đối.
  - `AlarmModel` và `AlarmRepository` đồng bộ hóa đầy đủ trường `soundPath`.
- **Tích hợp sâu vào hệ thống đánh thức**:
  - `AndroidAlarmScheduler` truyền đường dẫn `soundPath` trực tiếp vào dịch vụ chuông báo nền tảng.
  - `AlarmRingingScreen` bảo lưu nhạc chuông đã chọn khi bấm Báo lại (`_snooze`) hoặc tự lên lịch vòng lặp tiếp theo (`_stop`).

### 🧪 Kiểm thử & Chất lượng mã nguồn
- Bổ sung unit test `alarm_sound_test.dart` và `alarm_model_test.dart`.
- Đạt 28/28 unit test pass 100%.
- Kiểm tra `flutter analyze` sạch hoàn toàn (0 issue).

---

## [0.3.0] - 2026-10-20 — Giai đoạn 2: Báo thức Video & Kích hoạt thiết bị thật

### ✨ Tính năng mới
- **Hỗ trợ Video nền báo thức (Video Alarm Background)**:
  - Cho phép người dùng chọn video từ thư viện thiết bị trong màn hình thêm/sửa báo thức (`AlarmEditScreen`).
  - Tích hợp `MediaService` sao chép an toàn video vào vùng lưu trữ ứng dụng (`app_flutter/custom_media`).
  - Nâng cấp màn hình chuông reo (`AlarmRingingScreen`) tự động phát video full-screen lặp vô tận (`setLooping(true)`) làm nền sống động kèm hiệu ứng mờ tối giúp hiển thị thời gian rõ ràng.
- **Kích hoạt đánh thức màn hình khóa (Lockscreen Wake)**:
  - Cập nhật native `MainActivity.kt` với `setShowWhenLocked(true)` và `setTurnScreenOn(true)`.
  - Bổ sung cấu hình `AndroidManifest.xml` với `showWhenLocked`, `turnScreenOn`, `showOnLockScreen` và service `NotificationOnKillService`.
- **Tự động bắt sự kiện chuông kêu**:
  - Đăng ký lắng nghe `Alarm.ringing` tại tầng root (`WakeUpApp`) để tự động mở ngay màn hình báo thức reo khi chuông bắt đầu kêu.
- **Kết nối Báo thức với hệ điều hành**:
  - Tích hợp đầy đủ `AndroidAlarmScheduler` khi tạo mới, chỉnh sửa, bật/tắt công tắc và xóa báo thức.
  - Tự động xin cấp quyền thông báo (`POST_NOTIFICATIONS`), báo thức chính xác (`SCHEDULE_EXACT_ALARM`) và bỏ qua tối ưu hóa pin (`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`).
- **Bộ chọn giờ phong cách One UI / Samsung Clock (`SamsungTimePicker`)**:
  - Thiết kế 3 cột trực quan: **SA/CH | Giờ | Phút** với thanh highlight trung tâm và số hiển thị lớn.
  - Hỗ trợ cuộn vòng vô hạn mượt mà kèm rung phản hồi xúc giác (`HapticFeedback.selectionClick()`).
  - Banner đếm ngược thời gian động: thông báo trực tiếp khoảng thời gian còn lại trước khi chuông kêu.
- **Nâng cấp Cơ sở dữ liệu Drift**:
  - Nâng cấp schema phiên bản 2 (`schemaVersion => 2`) với cột `mediaPath` và kịch bản `MigrationStrategy`.

### 🐛 Sửa lỗi & Tối ưu
- Sửa lỗi assertion `Multiple widgets used the same GlobalKey` do `CupertinoTabScaffold` bọc `StatefulNavigationShell`, chuyển sang cấu trúc phân tầng `CupertinoPageScaffold` + `Column` + `CupertinoTabBar`.
- Kích hoạt `coreLibraryDesugaring` (`desugar_jdk_libs:2.1.4`) và `multiDexEnabled` trong `build.gradle.kts`.
- Bổ sung file âm thanh chuông mặc định `assets/audio/alarm.mp3`.
- Đạt 100% sạch lỗi `flutter analyze` và 22/22 unit tests pass.

---

## [0.2.0] - 2026-10-20 — Giai đoạn 1: Báo thức cốt lõi & Quản lý CRUD

### ✨ Tính năng mới
- **Logic tính toán thời gian thuần Dart**:
  - `NextAlarmCalculator`: Tính toán thời gian kêu tiếp theo cho báo thức 1 lần và lặp theo thứ trong tuần, tự động xử lý ranh giới nửa đêm, chuyển tháng và chuyển năm.
  - `SnoozeLogic`: Quản lý số lần và thời điểm báo lại, hỗ trợ đặt lại bộ đếm khi hoàn tất.
- **Quản lý danh sách báo thức (CRUD)**:
  - Màn hình `AlarmListScreen` phong cách iOS Clock với banner đếm ngược thời gian tới báo thức gần nhất (`alarmIn`).
  - Màn hình thêm/sửa `AlarmEditScreen` với `CupertinoDatePicker` dạng con lăn cuộn.
  - Hỗ trợ vuốt sang trái để xóa báo thức, bật/tắt nhanh bằng công tắc Cupertino.
- **Tầng dữ liệu Drift SQLite**:
  - Tạo bảng `Alarms` và lớp `AlarmRepository` với các thao tác `watchAllAlarms`, `insertAlarm`, `updateAlarm`, `toggleAlarm`, `deleteAlarm`.
- **Unit Tests**:
  - Viết 21 unit tests chuyên biệt cho `NextAlarmCalculator` và `SnoozeLogic`.

---

## [0.1.0] - 2026-10-20 — Giai đoạn 0: Khởi tạo dự án & Nền tảng giao diện

### ✨ Tính năng mới
- Khởi tạo dự án Flutter chuẩn feature-first.
- Thiết lập hệ thống Theme iOS Dark Mode: nền đen sâu (`#000000`), chữ cam (`#FF9500`), font hệ thống mảnh.
- Tích hợp `GoRouter` với 5 tab điều hướng chính: *Thế giới, Báo thức, Giờ ngủ, Khu vườn, Thống kê*.
- Cấu hình đa ngôn ngữ Localization (`intl`) với tiếng Việt làm ngôn ngữ mặc định.
