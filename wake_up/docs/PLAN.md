# Kế hoạch dự án: App báo thức "Wake Up" (Flutter)

> Đặt file này tại `docs/PLAN.md` trong repo. Agent phải đọc file này trước khi làm bất kỳ giai đoạn nào.

## 1. Mục tiêu sản phẩm

Ứng dụng báo thức Flutter (Android + iOS), giao diện giống app Đồng hồ của iPhone, với:

- Âm thanh và video tùy chỉnh làm nhạc chuông, có cắt đoạn (trim) và cắt khung hình (crop) theo ý người dùng.
- Hai chế độ đánh thức: **Thường** (báo thức bình thường) và **Sâu** (phải hoàn thành thử thách mới tắt được chuông).
- Gợi ý giờ đi ngủ, lịch ngủ, nhắc ngủ, cảnh báo ngủ quá ngắn.
- Khu vườn ảo và chuỗi ngày thức dậy (gamification).
- Báo thức theo múi giờ thành phố khác, tự xử lý giờ mùa hè.
- Theo dõi hành vi báo thức (dữ liệu ước tính, không khẳng định người dùng đã ngủ/thức).

## 2. Ba quyết định kiến trúc nền tảng

### 2.1. Báo thức iOS và Android khác nhau

- **iOS 26+:** dùng AlarmKit qua plugin `flutter_alarmkit` (kêu được cả khi bật Không làm phiền hoặc app bị tắt, hỗ trợ âm tùy chỉnh). Yêu cầu Flutter 3.38+, Xcode 26+. Trên iOS < 26 các lệnh AlarmKit ném `PlatformException` mã `UNSUPPORTED_VERSION`.
- **iOS < 26:** chỉ có chuỗi local notification (âm ngắn, không toàn màn hình). **Quyết định cần chốt:** hỗ trợ bản này hay đặt iOS 26 là tối thiểu. Mặc định đề xuất: iOS 26 là tối thiểu cho MVP.
- **Android:** cần exact alarm, foreground service, full-screen intent, receiver sau reboot, hướng dẫn tắt tối ưu pin. Gói `alarm` là điểm xuất phát; phải kiểm tra tương thích với Android mới nhất.
- Build iOS cần máy Mac với Xcode.

### 2.2. Video không phát được trên màn hình khóa iOS

Video chỉ phát khi người dùng chạm báo thức để mở app. Trên Android có thể làm màn hình báo thức toàn màn hình có video. **Âm thanh luôn là lớp đảm bảo; video là lớp thêm.**

### 2.3. Chế độ sâu không thể chặn tuyệt đối trên iOS

Người dùng vẫn bấm được nút Dừng của hệ thống. Giải pháp: **chuỗi báo thức dự phòng**. Khi chuông reo, app tự đặt thêm các chuông lặp (ví dụ mỗi 2 phút). Chỉ khi hoàn thành thử thách trong app thì chuỗi mới bị hủy. Dùng cho cả Android làm lớp bảo hiểm.

**Bắt buộc có lối thoát khẩn cấp** (giữ nút 10 giây hoặc tự mở khóa sau 15 phút) vì lý do an toàn.

## 3. Tech stack

| Mảng | Gói gợi ý |
|---|---|
| State / DI | Riverpod |
| Điều hướng | go_router |
| Dữ liệu local | drift (SQLite) |
| UI kiểu iOS | Cupertino widgets, dark theme, màu nhấn cam |
| Báo thức | `alarm` (Android), `flutter_alarmkit` (iOS 26+), `flutter_local_notifications` (dự phòng) |
| Video / âm thanh | `video_player`, `just_audio`, `file_picker`, `image_picker` |
| Cắt video | `video_trimmer` (bản mới dùng trình cắt native, không phụ thuộc FFmpeg) |
| Camera | `camera`, `google_mlkit_face_detection` |
| Nhận diện vật thể | `google_mlkit_image_labeling` (MVP) hoặc `tflite_flutter` (so khớp embedding) |
| QR | `mobile_scanner` |
| Cảm biến | `sensors_plus` |
| Âm lượng | `volume_controller` (iOS bị giới hạn) |
| Múi giờ | `timezone`, `flutter_timezone` |
| Biểu đồ | `fl_chart` |
| Backend (GĐ sau) | Firebase hoặc Supabase |

**Lưu ý:** `ffmpeg_kit_flutter` đã bị đánh dấu discontinued, **không dùng**. Mọi phiên bản gói phải kiểm tra lại trên pub.dev trước khi thêm vào `pubspec.yaml`.

### Crop/trim không phá hủy

"Crop" có hai nghĩa: cắt đoạn (trim) và cắt khung hình (crop). Mặc định chỉ lưu `startMs`, `endMs`, `cropRect` trong DB, rồi áp dụng lúc phát (`seekTo`, lặp đoạn, `FittedBox` + `Transform`). Chỉ xuất file thật bằng `video_trimmer` khi người dùng yêu cầu.

## 4. Giao diện kiểu iPhone

Thanh tab dưới: **Thế giới · Báo thức · Giờ ngủ · Khu vườn · Thống kê**.

- Nền đen, chữ số lớn mảnh, màu nhấn cam.
- Danh sách báo thức có công tắc, vuốt để xóa, nút "Sửa" ở góc.
- Chọn giờ bằng `CupertinoDatePicker` dạng cuộn.
- Màn "Thêm báo thức": Lặp lại, Nhãn, Âm thanh/Video, **Chế độ đánh thức (Thường/Sâu)**, Báo lại.
- Màn báo thức đang reo: giờ lớn, nền video, nút Dừng (chế độ thường) hoặc "Bắt đầu thử thách" (chế độ sâu).

## 5. Module chức năng

### 5.1. Báo thức cốt lõi
- Một lần hoặc lặp theo thứ; báo lại (số phút, số lần tối đa); tăng âm lượng dần.
- OS thường chỉ lên lịch một lần kêu tại một thời điểm tuyệt đối, nên cần cơ chế **tự đặt lại lần kêu kế tiếp** sau mỗi lần reo, sau reboot, khi múi giờ hoặc giờ hệ thống đổi.
- Thiết kế interface `AlarmScheduler` với hai cài đặt riêng cho Android và iOS.

### 5.2. Chế độ sâu (challenge engine)
Interface chung `Challenge` gồm `start()`, `verify()`, `reset()`. Một báo thức gắn được một hoặc nhiều thử thách theo thứ tự.

| Thử thách | Cách làm | Lưu ý |
|---|---|---|
| 3 câu toán | Sinh ngẫu nhiên, 3 mức khó, sai thì sinh câu mới | Thoát app thì chuông vẫn reo |
| Quét QR | Lúc cài đặt quét và lưu mã băm | Hỗ trợ nhiều mã cho một báo thức |
| Lắc điện thoại | Gia tốc kế, ngưỡng + debounce | Số lần lắc tùy chỉnh |
| Sắp xếp chữ cái | Kho từ Việt/Anh cục bộ, kéo thả ô chữ | Tính cả dấu tiếng Việt |
| Chụp vật đã đăng ký | Ảnh tham chiếu lúc cài đặt; so khớp embedding (cosine similarity) | Ngưỡng chỉnh được, có bước thử trước |
| Selfie trước gương | Camera trước + ML Kit phát hiện khuôn mặt | Không xác minh được "gương", chỉ xác minh có khuôn mặt |

Chỉnh âm lượng khi làm thử thách: Android làm được, iOS bị hạn chế.

### 5.3. Giờ đi ngủ
- `giờ ngủ = giờ dậy − (số chu kỳ × 90 phút) − thời gian chuẩn bị` (mặc định 15 phút).
- Lịch ngủ theo từng ngày; nhắc đi ngủ; thống kê giờ ngủ dự kiến.
- Cảnh báo khi quá ngắn (ngưỡng mặc định 6 giờ, chỉnh được).

### 5.4. Khu vườn ảo
- Điểm mỗi lần dậy đúng giờ: điểm cơ bản + thưởng chế độ sâu + thưởng chuỗi ngày − trừ theo số lần báo lại.
- Cây có nhiều giai đoạn; bỏ lỡ một ngày thì **ngừng phát triển** (không chết).
- Vật phẩm "đóng băng chuỗi"; mở khóa cây, thú cưng, vật phẩm bằng điểm; thành tích.
- Bảng xếp hạng bạn bè ở giai đoạn sau (cần backend).

### 5.5. Báo thức theo thành phố khác
- Lưu `IANA timezone` (ví dụ `Asia/Tokyo`) + giờ địa phương, quy ra thời điểm tuyệt đối.
- Hiển thị chênh lệch múi giờ so với giờ máy.
- Tự cập nhật DST nhờ `timezone`; **tính lại các lần kêu sắp tới** mỗi khi mở app hoặc múi giờ đổi.
- Chế độ "lịch họp quốc tế": chọn giờ họp, xem giờ ở nhiều thành phố.

### 5.6. Theo dõi hành vi báo thức
Sự kiện lưu cục bộ: `ring_fired`, `ring_opened`, `snooze`, `challenge_started`, `challenge_completed`, `dismissed` kèm timestamp.

Số liệu rút ra: độ trễ từ lúc reo đến lúc hoàn thành nhiệm vụ; số lần báo lại; biểu đồ ngày trong tuần hay dậy muộn.

**Bắt buộc:** mọi chỗ hiển thị dùng cách nói "dữ liệu hành vi ước tính", không khẳng định người dùng đã ngủ hay đã thức.

## 6. Mô hình dữ liệu (rút gọn)

- `Alarm`: id, time, repeatDays, label, mode (normal/deep), soundId, mediaId, snoozeConfig, challenges[], timezone, enabled
- `Media`: id, type, path, startMs, endMs, cropRect
- `ChallengeConfig`: alarmId, type, params (độ khó, QR hash, embedding ảnh tham chiếu…)
- `AlarmEvent`: id, alarmId, type, timestamp
- `SleepSchedule`: weekday, wakeTime, targetHours, prepMinutes
- `GardenState`: points, streak, plants[], unlockedItems[], lastWakeDate
- `WorldClock`: id, cityName, ianaTimezone

Ảnh, embedding và dữ liệu hành vi chỉ lưu trên máy. Chỉ điểm và chuỗi ngày được đồng bộ khi có bảng xếp hạng.

## 7. Cấu trúc thư mục (feature-first)

```
lib/
  core/        (theme, router, db, utils, platform_channels)
  features/
    alarms/      (data, domain, presentation)
    media/
    challenges/  (math, qr, shake, word, object_photo, selfie)
    bedtime/
    garden/
    world_clock/
    analytics/
    settings/
  main.dart
android/   (alarm service, receivers)
ios/       (AlarmKit setup)
```

## 8. Lộ trình

| GĐ | Nội dung | Tiêu chí hoàn thành |
|---|---|---|
| 0 | Khởi tạo dự án, theme iOS-style, DB, điều hướng | App chạy, có 5 tab |
| 1 | Báo thức cốt lõi Android + iOS | Kêu đúng giờ khi tắt màn hình, sau reboot, trong Không làm phiền |
| 2 | Âm thanh + video tùy chỉnh, trim/crop | Chọn video, cắt đoạn, phát đúng lúc reo |
| 3 | Chế độ sâu + engine thử thách + toán, lắc, QR | Chuông không tắt cho đến khi hoàn thành; có lối thoát khẩn cấp |
| 4 | Thử thách còn lại (chữ, ảnh vật, selfie) | Cả 6 thử thách ổn định |
| 5 | Giờ đi ngủ | Tính giờ, nhắc, cảnh báo đúng |
| 6 | Đồng hồ thế giới + báo thức múi giờ + DST | Test chuyển đổi giờ mùa hè |
| 7 | Theo dõi hành vi + thống kê | Biểu đồ đúng với dữ liệu giả lập |
| 8 | Khu vườn + streak + thành tích | Điểm và cây thay đổi đúng quy tắc |
| 9 | Bạn bè + bảng xếp hạng (backend) | Đăng nhập, kết bạn, xếp hạng |
| 10 | Kiểm thử nhiều máy, tối ưu pin, phát hành | Qua checklist cấp quyền và OEM |

**MVP = GĐ 0 → 3.** Đây là phần rủi ro kỹ thuật cao nhất, phải chứng minh chạy được trước khi làm khu vườn và bảng xếp hạng.

## 9. Rủi ro

- **Android OEM** (Xiaomi, Oppo, Samsung…) hay giết tiến trình nền: cần màn hướng dẫn cấp quyền "tự khởi động", "không giới hạn pin".
- **Quyền Android mới** (exact alarm, full-screen intent, thông báo): quy định đổi theo từng bản Android, kiểm tra tài liệu hiện hành.
- **Test:** báo thức chỉ test đáng tin trên thiết bị thật (tắt màn hình, chờ chuông). Phần logic (toán, giờ ngủ, múi giờ/DST) viết unit test.
- **Quyền riêng tư:** ảnh và camera chỉ xử lý trên máy, ghi rõ trong chính sách.
- **Chống gian lận bảng xếp hạng:** ban đầu dựa trên sự tin cậy giữa bạn bè, hoặc tính điểm từ log sự kiện.
