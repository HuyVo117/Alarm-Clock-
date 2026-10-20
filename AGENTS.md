# Quy tắc cho agent (đặt ở gốc repo)

> Nếu Antigravity có thư mục rules riêng, có thể sao chép nội dung này vào đó. Nội dung này vẫn có tác dụng khi đặt ở gốc repo.

## Bối cảnh
Dự án Flutter "Wake Up": app báo thức giao diện kiểu iPhone. Kế hoạch đầy đủ nằm ở `docs/PLAN.md`. Luôn đọc file đó trước khi bắt đầu một giai đoạn.

## Quy trình làm việc
1. Trước khi viết code cho một giai đoạn, **đưa ra kế hoạch triển khai và dừng lại chờ tôi duyệt**.
2. Chỉ làm đúng phạm vi giai đoạn được giao. Không làm trước các giai đoạn sau.
3. Mỗi giai đoạn kết thúc bằng: `flutter analyze` sạch, unit test của logic thuần chạy qua, và danh sách bước tôi cần test tay trên máy thật.
4. Nói rõ những gì bạn **không thể** tự xác minh (ví dụ: báo thức kêu khi tắt màn hình, hành vi trên iOS thật).

## Kiến trúc và quy ước
- Cấu trúc feature-first: `lib/features/<tên>/{data,domain,presentation}`, phần dùng chung ở `lib/core`.
- State management: Riverpod. Điều hướng: go_router. Database: drift.
- Logic nghiệp vụ (tính giờ ngủ, sinh câu toán, tính điểm, tính lần kêu tiếp theo theo múi giờ) phải là Dart thuần, không phụ thuộc UI hoặc plugin, và có unit test.
- Mọi truy cập nền tảng (báo thức, camera, âm lượng) đi qua interface trừu tượng, ví dụ `AlarmScheduler`, để dễ test và thay thế.
- Đặt tên file `snake_case`, class `PascalCase`. Chuỗi hiển thị cho người dùng để ở tiếng Việt, tách ra file localization, không hard-code rải rác.
- UI dùng Cupertino widgets, dark theme, màu nhấn cam, bám giao diện app Đồng hồ của iPhone.

## Quy tắc về package
- **Không thêm package ngoài danh sách trong `docs/PLAN.md` mà chưa hỏi tôi.**
- Trước khi thêm package, kiểm tra trên pub.dev: còn được bảo trì không, bản mới nhất, có hỗ trợ cả Android và iOS không.
- **Không dùng `ffmpeg_kit_flutter`** (đã discontinued).

## Quy tắc về nội dung
- Dữ liệu hành vi báo thức chỉ là **ước tính**. Không viết chữ nào trong UI hoặc code comment khẳng định người dùng "đã ngủ" hay "đã thức dậy" như một sự thật. Dùng cách diễn đạt như "ước tính", "dựa trên hành vi báo thức".
- Ảnh, embedding, và dữ liệu hành vi chỉ lưu cục bộ. Không gửi lên server.
- Chế độ đánh thức sâu **luôn có lối thoát khẩn cấp**.

## Điều tuyệt đối không làm
- Không xóa hoặc ghi đè file `docs/PLAN.md`.
- Không bỏ qua bước xin duyệt kế hoạch.
- Không tự giả định hành vi nền tảng. Nếu không chắc về hành vi của Android hoặc iOS, hãy nêu rõ và hỏi.
