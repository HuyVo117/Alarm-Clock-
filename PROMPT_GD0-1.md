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




## giai đoạn thiết kế tính năng trồng cây 
Để ChatGPT có thể lên bản thiết kế hệ thống/UI chuẩn xác và Claude có thể viết code (React/React Native/Flutter...) mượt mà ngay từ lần đầu, bạn cần cung cấp cho chúng một **Tài liệu Đặc tả Kỹ thuật & Gameplay (PRD/Prompt)** chi tiết dựa trên cơ chế trong video.

Dưới đây là bản phân tích chi tiết các thành phần từ video, được cấu trúc thành các mục chuẩn bị và Prompt mẫu để bạn copy-paste trực tiếp cho AI:

---

## 1. Các mục cần chuẩn bị trước khi đưa vào AI

Để quá trình tạo hình ảnh (UI) và viết code không bị thiếu sót, bạn cần xác định rõ 4 nhóm yếu tố sau:

* **Cơ chế kết nối với Báo thức (Core Hook):** Người dùng dậy đúng giờ sẽ nhận được gì? (Ví dụ: Nhận lượt "Tưới nước", nhận "Hạt giống đặc biệt", hoặc nhận "Xu nông trại" để mua hạt giống).


* **Bố cục giao diện (UI Layout):** Màn hình ngang hay dọc? (Trong video là màn hình ngang với góc nhìn Isometric 2.5D, nhưng nếu tích hợp vào app báo thức trên điện thoại, bạn có thể giữ góc nhìn Isometric trên khung màn hình dọc hoặc ngang tùy ý).


* **Tài nguyên hình ảnh (Assets cần dùng):**
* Ô đất (trống, mới gieo mầm, đang lớn, chờ thu hoạch).


* Gói hạt giống và nông sản (nhiều màu sắc/độ hiếm khác nhau của cùng 1 loại cây, ví dụ: Củ cải trắng, củ cải đỏ thẫm, củ cải vàng kim).


* Icon thao tác: Bình tưới nước, giỏ thu hoạch, rương kho báu, xu nông trại.




* **Tính năng Bạn bè (Social):** Danh sách bạn bè hiển thị ở đâu? Khi sang thăm nhà bạn bè thì làm được gì? (Tưới nước hộ để nhận điểm năng lượng, hoặc xem bảng xếp hạng).

---

## 2. Bản mô tả chi tiết hệ thống (Dùng để nạp bối cảnh cho cả ChatGPT & Claude)

Bạn hãy copy toàn bộ nội dung trong khung dưới đây gửi cho ChatGPT (để lên thiết kế chi tiết/wireframe) và Claude (để viết code):

### Bối cảnh dự án (Project Overview)

Xây dựng một mini-game **"Nông Trại Thức Giấc" (Wake-up Farm)** tích hợp bên trong một ứng dụng Báo thức. Người dùng hoàn thành nhiệm vụ báo thức mỗi sáng để nhận tài nguyên (Xu, Hạt giống, Lượt tưới nước), sau đó đem trồng trên mảnh đất của mình, tương tác với bạn bè và tích lũy điểm mở Rương kho báu nhận thưởng.

### Phân tích Bố cục Giao diện (UI/UX Layout từ Video)

1. **Khu vực Trung tâm (Bản đồ Nông trại Isometric 4x4):**
* Một hòn đảo nổi xanh mướt với lưới **16 ô đất (4x4)** nằm nghiêng theo góc nhìn Isometric (2.5D).


* Một vài ô góc trên có thể đặt linh vật trang trí hoặc cây thần kỳ cố định.


* Khi chọn một ô đất, ô đó sáng viền vàng.




2. **Thanh Header & HUD (Góc trên & hai bên):**
* **Góc trên trái:** Avatar người dùng, tên khu vực ("Trang trại").


* **Bên trái:** Các nút hành động nhanh xuất hiện theo ngữ cảnh: Nút **"Tưới nước"** và nút **"Thu hoạch (N vị trí)"**.


* **Góc trên phải:** Hiển thị số lượng **Xu nông trại** hiện có (ví dụ: 15185 xu), nút **Cửa hàng**, và thanh tiến độ **Rương thần kỳ** (ví dụ: 234/300 điểm năng lượng, có hiệu ứng tia sét bay vào mỗi khi thao tác trên ruộng).




3. **Khu vực Footer & Ngăn kéo Hạt giống (Bottom Bar):**
* **Góc dưới trái:** Bảng theo dõi nhiệm vụ nhanh (ví dụ: *"Bí ngô được trồng (0/16) lần"*).


* **Góc dưới phải:** Các nút điều hướng chính gồm: Sổ tay bộ sưu tập cây trồng (ví dụ: 73/135), Nút sang thăm nhà **Bạn bè** (icon ngôi nhà có hình mặt người), Nút về trang trại của mình, và Nút **Gieo hạt**.


* **Menu chọn hạt giống (trượt từ dưới lên khi bấm Gieo hạt):** Có 3 tab phân loại (*Tất cả, Trung bình, Đặc biệt*). Danh sách các túi hạt giống xếp ngang, hiển thị hình ảnh nông sản, số lượng tồn kho (ví dụ: x437), và nhãn *EXP*.





### Luồng Hoạt động Cốt lõi (Core Gameplay Loop)

1. **Mua hạt giống (Shop Modal):**
* Bấm vào "Cửa hàng" mở ra popup "Mua các gói hạt giống" chia lưới 4 cột.


* Khi chọn 1 hạt giống (ví dụ: Ngô hoặc Củ cải trắng), panel bên phải hiển thị chi tiết: Đơn giá (có loại miễn phí 0 xu như Củ cải trắng để cày rương, có loại tốn xu), Số lượng màu sắc biến thể (ví dụ: 3 hoặc 8 loại màu khác nhau), Lợi ích đạt được, Thu nhập tiềm năng, Thời gian trưởng thành (ví dụ: 8 giây hoặc 3 giờ 31 phút).


* Có thanh trượt (`-` / `+`) để mua số lượng lớn (tối đa 99 gói/lần).




2. **Gieo hạt (Planting):**
* Mở khay hạt giống ở đáy màn hình, chọn túi hạt và bấm/kéo liên tiếp vào các ô đất trống.


* Hiệu ứng: Túi hạt bay vào ô đất, trừ số lượng (`-1`), mầm cây nhỏ nhú lên ngay lập tức.




3. **Chăm sóc & Tưới nước (Watering):**
* Các ô đất đang trồng sẽ hiện icon **Bình tưới nước** nhỏ ở góc ô.


* Người chơi bấm trực tiếp vào từng ô hoặc bấm nút "Tưới nước" bên trái để tưới hàng loạt.


* **Hiệu ứng:** Bình tưới nghiêng đổ nước, giảm thời gian chờ (hiện thông báo `-4 giây`, `-7 giây`), đồng thời sinh ra các **tia sét năng lượng màu xanh** bay thẳng vào biểu tượng Rương thần kỳ ở góc phải màn hình để cộng điểm (ví dụ nhảy từ 234/300 lên 258/300).




4. **Đột biến màu sắc & Thu hoạch (Mutation & Harvesting):**
* Khi hết thời gian đếm ngược, cây phát sáng (hiệu ứng cột sáng vàng/tím) và biến thành nông sản trưởng thành.


* **Cơ chế Gacha nông sản:** Cùng một hạt giống Củ cải trồng xuống, khi chín sẽ ngẫu nhiên ra các màu sắc/độ hiếm khác nhau trên các ô đất (Củ cải trắng thường, Củ cải đỏ thẫm, Củ cải vàng kim).


* Hiện icon **Giỏ thu hoạch** trên từng ô hoặc bấm nút **"Thu hoạch (N vị trí)"** bên trái để thu hoạch toàn bộ cùng lúc.


* Thu hoạch xong sẽ hiện banner thông báo ở trên (ví dụ: *"Nhận Củ cải trắng x3"*, *"Nhận Củ cải vàng kim x3"*), cộng Xu và cộng thêm điểm Năng lượng thần kỳ vào Rương.




5. **Mở Rương Thần Kỳ (Reward Chest System):**
* Khi thanh năng lượng ở góc phải đầy (ví dụ đạt 300/300 hoặc 550/550), người chơi bấm vào rương để mở popup **"Thần kỳ"**.


* Hiển thị các mốc rương (Rương thường, Rương hiếm, Rương cực hiếm) với tỷ lệ rơi đồ (ví dụ: *75% cơ hội nhận xu nông trại, vật phẩm thông thường và 25% cơ hội nhận hạt giống đặc biệt*).


* Có nút **"Mở tất cả"** để nhận thưởng nhanh.




6. **Tính năng Tương tác Bạn bè (Social & Co-op):**
* Bấm vào icon Bạn bè ở góc dưới để xem danh sách bạn bè cùng đặt báo thức.
* Cho phép ghé thăm nông trại của bạn bè, xem bộ sưu tập cây đột biến của họ và bấm "Tưới nước giúp" để cả hai cùng nhận Năng lượng thần kỳ mở rương và Xu vàng.



---

## 3. Câu lệnh (Prompt) giao việc cụ thể cho từng AI

Sau khi gửi bản mô tả trên, bạn chỉ cần thêm câu lệnh dưới đây tùy theo công cụ bạn đang mở:

* **Nếu gửi cho ChatGPT (Để lên cấu trúc dữ liệu, luồng màn hình & prompt vẽ UI):**
> *"Dựa trên bản đặc tả hệ thống Nông Trại Thức Giấc ở trên, hãy đóng vai trò là Game Designer và UI/UX Architect. Hãy giúp tôi:
> 1. Thiết kế sơ đồ trạng thái (State Machine) của một ô đất (Plot) từ lúc trống đến lúc thu hoạch.
> 2. Thiết kế bảng cấu trúc dữ liệu (Database Schema / JSON state) cho: Người dùng, Ô đất, Kho hạt giống, Cửa hàng, Tiến độ Rương thần kỳ và Tương tác bạn bè.
> 3. Viết mô tả wireframe chi tiết cho từng thành phần trên màn hình để tôi chuyển giao cho Claude code giao diện."*
> 
> 


* **Nếu gửi cho Claude (Để viết code hoàn chỉnh):**
> *"Dựa trên bản đặc tả hệ thống Nông Trại Thức Giấc ở trên, hãy đóng vai trò là Senior Frontend Developer. Hãy viết code hoàn chỉnh cho mini-game này bằng [Điền công nghệ bạn muốn dùng, ví dụ: React + Tailwind CSS + Framer Motion].
> Yêu cầu:
> 1. Dựng lưới 16 ô đất (4x4) theo góc nhìn Isometric (dùng CSS transform/perspective hoặc SVG/Canvas).
> 2. Thực hiện đầy đủ luồng: Mua hạt giống trong Shop (có loại 0 đồng) -> Chọn hạt ở Bottom Drawer -> Click/quét qua các ô đất để gieo hạt hàng loạt -> Bấm Tưới nước (giảm thời gian đếm ngược + hiệu ứng cộng điểm vào Rương góc phải) -> Cây chín ngẫu nhiên ra 3 màu (Trắng, Đỏ, Vàng) -> Bấm Thu hoạch tất cả để nhận Xu.
> 3. Có Modal mở Rương thần kỳ khi tích đủ điểm năng lượng và Modal thăm trang trại bạn bè."*
> 
> 


