# Prompt khởi động Giai đoạn 0 và 1

> Dán nguyên phần trong khung dưới đây vào agent của Antigravity. Trước đó, đảm bảo `docs/PLAN.md` và `AGENTS.md` đã nằm trong repo.

---

```
Hãy đọc docs/PLAN.md và AGENTS.md ở gốc repo, sau đó thực hiện Giai đoạn 0 và Giai đoạn 1.

CHƯA VIẾT CODE. Việc đầu tiên: đưa ra kế hoạch triển khai chi tiết (danh sách
file sẽ tạo, package sẽ thêm kèm phiên bản đã kiểm tra trên pub.dev, thứ tự
thực hiện, và những điểm bạn chưa chắc chắn), rồi dừng lại chờ tôi duyệt.

=== GIAI ĐOẠN 0: Khởi tạo ===
- Tạo dự án Flutter (Android + iOS), tên "wake_up", bundle id do tôi cung cấp sau.
- Dựng cấu trúc thư mục feature-first như trong PLAN.md mục 7.
- Thêm: riverpod, go_router, drift (cùng các gói build_runner cần thiết).
- Theme: dark, nền đen, màu nhấn cam, chữ số lớn mảnh, bám giao diện app
  Đồng hồ của iPhone, dùng Cupertino widgets.
- Thanh tab dưới 5 mục: Thế giới, Báo thức, Giờ ngủ, Khu vườn, Thống kê.
  Các tab ngoài "Báo thức" chỉ cần màn hình trống có tiêu đề.
- Thiết lập database drift với bảng Alarm theo mô hình ở PLAN.md mục 6
  (các trường chưa dùng ở GĐ1 có thể để nullable).
- Thiết lập localization tiếng Việt.

=== GIAI ĐOẠN 1: Báo thức cốt lõi ===
Chức năng:
- Danh sách báo thức: bật/tắt bằng công tắc, vuốt để xóa, nút Sửa, giống iPhone.
- Màn Thêm/Sửa báo thức: CupertinoDatePicker, lặp theo thứ, nhãn, báo lại
  (số phút + số lần tối đa). Trường "chế độ đánh thức" có thể hiển thị nhưng
  chỉ hỗ trợ "Thường" ở giai đoạn này.
- Lên lịch báo thức thật qua interface AlarmScheduler:
    + Android: dùng gói `alarm` (hoặc phương án tốt hơn nếu bạn tìm thấy,
      hãy nêu lý do), có foreground service, quyền exact alarm, full-screen
      intent, tự đặt lại sau reboot.
    + iOS 26+: dùng flutter_alarmkit. Trên iOS < 26 hiển thị thông báo
      "chưa hỗ trợ" thay vì crash.
- Cơ chế tự tính và đặt lại lần kêu kế tiếp sau mỗi lần reo (báo thức lặp),
  sau reboot, và khi múi giờ hoặc giờ hệ thống thay đổi.
- Màn hình khi báo thức reo: giờ lớn, nhãn, nút Dừng và nút Báo lại.
- Luồng xin quyền: thông báo, exact alarm, full-screen intent, hướng dẫn tắt
  tối ưu pin trên Android.

Unit test bắt buộc (Dart thuần, không phụ thuộc plugin):
- Hàm tính thời điểm kêu kế tiếp: báo thức một lần, lặp nhiều thứ, qua nửa đêm,
  qua ranh giới tháng/năm.
- Logic báo lại: đếm số lần, dừng khi hết lượt.

Tiêu chí hoàn thành GĐ1:
- flutter analyze sạch, unit test qua.
- Danh sách bước tôi cần test tay trên máy thật, tối thiểu gồm:
  tắt màn hình rồi chờ chuông; khởi động lại máy; bật Không làm phiền;
  đổi múi giờ hệ thống; thoát hẳn app trước giờ báo.
- Liệt kê rõ phần nào bạn KHÔNG thể tự xác minh.

Ràng buộc:
- Không thêm package ngoài danh sách trong PLAN.md mà chưa hỏi.
- Không làm trước video, chế độ sâu, giờ ngủ, khu vườn.
- Nếu không chắc về hành vi nền tảng, hãy nêu rõ và hỏi, đừng đoán.
```

---

## Sau khi agent hoàn thành GĐ 0–1

1. Tự test tay trên máy thật theo checklist agent đưa ra. Đây là bước bắt buộc, vì báo thức chỉ test đáng tin trên thiết bị thật.
2. Nếu ổn, giao tiếp Giai đoạn 2 (âm thanh + video + trim/crop) bằng cùng cách: yêu cầu kế hoạch trước, duyệt rồi mới cho viết code.
