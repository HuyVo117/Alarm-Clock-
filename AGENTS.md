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

## Quy tắc tiết kiệm ngữ cảnh và bàn giao (BẮT BUỘC)

Dự án này được làm qua nhiều phiên, nhiều tài khoản khác nhau. Quota có thể
hết bất cứ lúc nào, nên trạng thái phải luôn nằm trong file, không nằm trong chat.

### Khi bắt đầu phiên mới
1. Chỉ đọc `docs/STATE.md` và `AGENTS.md`. KHÔNG đọc toàn bộ repo, KHÔNG đọc
   `PLAN.md` trừ khi STATE.md bảo cần đọc một mục cụ thể.
2. Chỉ mở những file được liệt kê trong mục "File đang làm dở" của STATE.md.
3. Nếu thông tin trong STATE.md chưa đủ, hỏi tôi, đừng quét toàn bộ dự án.

### Trong khi làm việc
- Sau MỖI nhiệm vụ nhỏ hoàn thành (một màn hình, một hàm, một bug), cập nhật
  `docs/STATE.md` ngay, rồi `git commit` với message mô tả rõ. Không dồn lại cuối phiên.
- Làm từng nhiệm vụ nhỏ, đừng ôm nhiều việc một lượt.
- Khi tìm hiểu mã, dùng tìm kiếm có mục tiêu (grep theo tên hàm/class), không đọc cả thư mục.
- Không in lại nội dung file dài trong câu trả lời; chỉ nêu đường dẫn và phần đã đổi.
- Quyết định kỹ thuật quan trọng (chọn package, đổi kiến trúc) ghi vào
  `docs/DECISIONS.md` kèm một dòng lý do.

### Khi tôi gõ "handoff"
Ngay lập tức: cập nhật STATE.md đầy đủ, commit mọi thay đổi, rồi trả lời đúng
một câu ngắn xác nhận. Không giải thích thêm.
2. Tạo file docs/STATE.md (agent sẽ giữ cập nhật)
markdown
# Trạng thái dự án (cập nhật lần cuối: <ngày giờ>)

## Đang ở đâu
- Giai đoạn hiện tại: GĐ <số> (<tên>)
- Nhiệm vụ đang làm: <một câu>
- Tình trạng: <chưa bắt đầu / đang làm / bị chặn>

## Đã xong
- [x] <việc 1, kèm file chính>
- [x] <việc 2>

## Việc tiếp theo (theo thứ tự)
1. <việc cụ thể, nêu rõ file cần sửa>
2. <việc tiếp>

## File đang làm dở
- `wake_up/lib/...` : <đang làm gì, còn thiếu gì>

## Quyết định đã chốt (không bàn lại)
- <ví dụ: dùng Riverpod, drift; iOS 26 là tối thiểu>

## Vấn đề đang gặp / chưa giải quyết
- <lỗi, câu hỏi chờ tôi trả lời>

## Cách chạy và kiểm tra
- Lệnh: `cd wake_up && flutter analyze && flutter test`
- Đã test tay trên máy thật: <có/chưa, những gì>
3. Prompt mở phiên mới (sau khi chuyển tài khoản)
Đọc docs/STATE.md và AGENTS.md, không đọc gì thêm. Tóm tắt trong 3 dòng bạn
hiểu dự án đang ở đâu, rồi làm "Việc tiếp theo" số 1. Làm xong thì cập nhật
STATE.md và commit.