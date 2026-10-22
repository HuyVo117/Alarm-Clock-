# 📋 BÁO CÁO THẨM ĐỊNH & HƯỚNG DẪN KIỂM THỬ TRẢI NGHIỆM NGƯỜI DÙNG (UX/UI TESTING REPORT)

> **Mục tiêu**: Giúp Tester và Product Owner kiểm tra toàn diện tính khả dụng, độ thẩm mỹ, sự tiện lợi khi thao tác bằng một tay và tính logic của luồng người dùng (User Flow) trên các tính năng vừa phát triển.

---

## 🎯 1. TỔNG QUAN HỆ THỐNG GIAO DIỆN

Ứng dụng **Wake Up** được thiết kế theo triết lý **Apple Human Interface Guidelines (Cupertino iOS Dark Theme)** kết hợp màu nhấn cam `#FF9500` và nền đen sâu `#000000`, chia thành 5 tab điều hướng chính:
1. **Thế giới (World Clock)**: Quản lý giờ đa thành phố quốc tế và chênh lệch múi giờ.
2. **Báo thức (Alarms)**: Bộ chọn giờ 3 cột One UI, video nền tùy chỉnh và Chế độ thử thách sâu.
3. **Giờ ngủ (Bedtime)**: Lịch ngủ và chu kỳ 90 phút.
4. **Khu vườn (Wake-up Farm)**: Mini-game đảo nổi Isometric 2.5D, đột biến màu sắc nông sản, shop hạt giống, rương thần kỳ và bạn bè.
5. **Thống kê (Analytics)**: Theo dõi xu hướng thức dậy.

---

## 🌾 2. KỊCH BẢN KIỂM THỬ UX/UI: TAB "KHU VƯỜN" (NÔNG TRẠI THỨC GIẤC)

### 2.1. Đồ họa & Cảm nhận Trực quan (Visual Aesthetics)
- [ ] **Góc nhìn 2.5D Isometric**: Hòn đảo xanh nổi bồng bềnh ở giữa màn hình với vách đá 3D đổ bóng. Kiểm tra xem đảo có nằm cân đối trên màn hình điện thoại hay không.
- [ ] **16 ô đất cày xới (4x4)**:
  - Ô đất trống có màu nâu ấm với các đường rãnh luống đất nông nghiệp.
  - Chạm vào 1 ô đất: ô đó phát sáng viền vàng neon (`#FFD700`) nổi bật.
- [ ] **Các trạng thái sinh trưởng của cây**:
  - `Đất trống`: Dấu chấm mờ gợi ý gieo hạt.
  - `Mầm mới nhú (Sprout)`: Icon mầm cây xanh nhú lên.
  - `Đang lớn (Growing)`: Cây lớn dần kèm đồng hồ đếm ngược giây màu xanh lá (`15s`, `45s`, `120s`).
  - `Chín (Mature)`: Phát sáng hào quang tròn theo màu sắc đột biến, hiện tên màu và icon quả chín.

---

### 2.2. Trải nghiệm Vòng lặp Gameplay (Core Loop UX)

#### 🧪 Test Case 2.2.1: Gieo hạt từ Khay trượt đáy (Bottom Drawer)
1. Bấm nút **"Gieo hạt"** ở góc dưới phải.
2. **Quan sát UX**: Khay hạt giống trượt mượt mà từ đáy lên, nền tối mờ kính bóng mờ (`Blur/Cupertino`).
3. Chuyển đổi tab **"Tất cả"** | **"Cơ bản"** | **"Đặc biệt"** xem phản hồi có nhanh nhạy không.
4. Cuộn ngang danh sách túi hạt giống (Củ cải `x20`, Bắp ngô, Bí ngô). Thẻ hạt giống đang chọn có viền cam và nhãn số lượng `x...` rõ ràng.
5. Bấm nút **"Gieo vào tất cả ô trống"**:
   - Kiểm tra: Toàn bộ 16 ô đất lập tức mọc mầm cây, túi hạt giống tự động trừ số lượng chính xác, banner thông báo màu cam xuất hiện ở trên.

#### 🧪 Test Case 2.2.2: Tưới nước & Hiệu ứng Tia sét Năng lượng
1. Bấm trực tiếp vào một ô đất đang có cây đếm ngược:
   - Thời gian đếm ngược ngay lập tức giảm trừ từ `-4s` đến `-7s`.
   - Năng lượng Rương Thần Kỳ ở góc trên tăng thêm `+5` điểm.
2. Bấm nút **"Tưới nước"** màu xanh dương bên trái:
   - Toàn bộ các ô đất đang trồng đều được giảm thời gian đồng loạt.
   - Thanh tiến độ Rương nhảy số và banner báo cáo tổng năng lượng nhận được.

#### 🧪 Test Case 2.2.3: Cơ chế Gacha Đột biến Màu sắc & Thu hoạch
1. Chờ cây Củ cải đếm ngược về `0s`:
   - Quan sát xem cây có biến đổi màu ngẫu nhiên không:
     - ⚪ **Trắng ngà (Common - 70%)**: quả thường.
     - 🔴 **Đỏ thẫm (Rare - 25%)**: quả hiếm.
     - 🟡 **Hoàng kim (Legendary - 5%)**: hào quang phát sáng vàng rực.
2. Bấm vào từng ô để thu hoạch riêng lẻ, hoặc bấm nút **"Thu hoạch"** màu cam bên trái:
   - Xu nông trại nhảy cộng dồn ở góc trên phải.
   - Năng lượng Rương cộng thêm tương ứng theo phẩm cấp quả.
   - Ô đất sau thu hoạch trở về trạng thái đất trống sẵn sàng cho vụ mùa mới.

#### 🧪 Test Case 2.2.4: Cửa hàng Mua hạt giống (Shop Modal)
1. Bấm nút **"Shop"** màu cam trên Header HUD.
2. Chọn hạt giống (ví dụ Bắp ngô hoặc Củ cải 0 xu miễn phí).
3. Kiểm tra thanh chọn số lượng: bấm nút `+` / `-` tăng giảm từ 1 đến 99 gói.
4. Bấm **"Mua ngay"**: Kiểm tra trừ Xu chính xác và cộng thêm vào túi đồ.

#### 🧪 Test Case 2.2.5: Mở Rương Thần Kỳ (Reward Chest)
1. Khi thanh năng lượng đạt `300/300`:
   - Icon Rương chuyển sang màu xanh lá và sáng viền vàng.
2. Bấm vào Rương:
   - Hộp thoại rương thần kỳ mở ra với hiệu ứng quà tặng (Xu vàng + gói hạt giống quý).
   - Bấm **"Mở tất cả & Nhận thưởng"**: Xu và hạt giống cộng vào tài khoản, năng lượng rương reset về `0` để tích lũy vòng mới.

#### 🧪 Test Case 2.2.6: Sổ tay Bộ sưu tập & Ghé thăm Bạn bè
- **Sổ tay (Icon 📖)**: Mở danh mục nông sản, kiểm tra xem những màu đã thu hoạch có hiện rõ đầy đủ chỉ số hay không, màu chưa mở hiển thị dạng `❓ Chưa mở`.
- **Bạn bè (Icon 👥)**: Mở danh sách bạn bè mẫu (Hoàng Anh, Mai Lan, Thanh Tùng). Bấm nút **"Tưới giúp 💧"**: kiểm tra nút đổi thành "Đã tưới" và nhận ngay phần thưởng co-op (+25 Xu, +15 Năng lượng).

---

## 🌍 3. KỊCH BẢN KIỂM THỬ UX/UI: TAB "THẾ GIỚI" (WORLD CLOCK)

### 3.1. Điểm cần thẩm định UX
- [ ] **Thẻ thành phố (WorldClockCard)**:
  - Giờ điện tử lớn hiển thị rõ nét, cập nhật nhảy giây theo thời gian thực.
  - Dòng chênh lệch: hiển thị rõ "Hôm nay, +0 giờ" hoặc "Ngày mai, +7 giờ" kèm chỉ báo `Ngày` (mặt trời) hoặc `Đêm` (mặt trăng).
- [ ] **Thao tác xóa & chỉnh sửa**:
  - Vuốt sang trái trên bất kỳ thẻ nào để lộ nút Xóa màu đỏ.
  - Bấm nút **"Sửa"** ở góc trên trái: hiện icon tròn trừ màu đỏ để xóa hàng loạt và thanh kéo reorderable.
- [ ] **Thêm thành phố mới (Icon +)**:
  - Màn hình tìm kiếm Cupertino, thanh search bar phản hồi tức thì với tiếng Việt có dấu/không dấu (ví dụ: gõ "ha noi" ra "Hà Nội", "tokyo" ra "Tokyo").

---

## ⏰ 4. KỊCH BẢN KIỂM THỬ UX/UI: HỆ THỐNG THỬ THÁCH BÁO THỨC

### 4.1. Điểm cần thẩm định UX khi cài đặt & chuông reo
- [ ] **Bộ chọn giờ Samsung Clock**: 3 cột cuộn vô hạn (SA/CH | Giờ | Phút) mượt mà, vạch highlight trung tâm, banner đếm ngược thời gian *"Báo thức sẽ reo sau X giờ Y phút"*.
- [ ] **Cài đặt Thử thách sâu (Deep Wake-up)**:
  - Bật chế độ "Sâu" trong màn hình Sửa báo thức.
  - Chọn thử thách: Giải toán (Math), Lắc máy (Shake), Quét QR, Selfie trước gương (Face Detection), Chụp ảnh rời giường (Photo Comparison).
- [ ] **Màn hình khi chuông reo**:
  - Nút "Tắt báo thức" chuyển thành nút kích hoạt thử thách.
  - **Lối thoát khẩn cấp**: Giữ nút tròn 10 giây có vòng viền đếm ngược để thoát trong tình huống khẩn cấp.

---

## 📊 5. BẢNG TIÊU CHÍ ĐÁNH GIÁ TRẢI NGHIỆM (UX RATING MATRIX)

| Tiêu chí | Câu hỏi tự đánh giá | Đánh giá đề xuất (1 - 5 ⭐) |
|---|---|---|
| **Độ thẩm mỹ (Visuals)** | Giao diện nền đen kết hợp màu cam và nông trại 2.5D có tạo cảm giác cao cấp, đã mắt không? | ⭐⭐⭐⭐⭐ |
| **Thao tác 1 tay (One-Hand Usage)** | Các nút bấm quan trọng (Gieo hạt, Tưới nước, Thu hoạch) có nằm vừa trong tầm với của ngón tay cái không? | ⭐⭐⭐⭐⭐ |
| **Độ phản hồi (Responsiveness)** | Chạm vào ô đất, bấm gieo hạt, đếm ngược giây có phản hồi tức thì, không bị khựng giật không? | ⭐⭐⭐⭐⭐ |
| **Tính gây nghiện (Gamification)** | Cơ chế đếm ngược nhanh (15s), đột biến màu sắc ngẫu nhiên và mở rương có kích thích người dùng muốn mở app mỗi sáng không? | ⭐⭐⭐⭐⭐ |
| **Độ rõ ràng của thông tin (Clarity)** | Số xu, tiến độ rương, thời gian cây chín và các banner thông báo có dễ đọc, dễ hiểu không? | ⭐⭐⭐⭐⭐ |

---

## 💡 6. GỢI Ý CÁC ĐIỂM TESTER CÓ THỂ ĐÓNG GÓP Ý KIẾN THÊM

Sau khi test trên máy, bạn có thể đưa ra nhận xét về các khía cạnh sau:
1. **Tốc độ sinh trưởng của cây**: Thời gian cây mẫu hiện tại (15s cho Củ cải, 45s cho Ngô, 120s cho Bí ngô) đã đủ nhanh để test chưa? Khi vào giai đoạn vận hành chính thức, bạn có muốn kéo dài thời gian hơn (ví dụ vài giờ để đồng bộ với giấc ngủ đêm) không?
2. **Kích thước các ô đất trên màn hình điện thoại**: 16 ô đất chạm ngón tay có dễ trúng không, có cần phóng to hay thu nhỏ không?
3. **Mức thưởng Xu**: Tỷ lệ kiếm Xu từ nông sản và mở rương đã cân bằng với giá mua hạt giống trong Shop chưa?
