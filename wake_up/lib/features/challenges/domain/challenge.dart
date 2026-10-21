/// Interface chung cho mọi thử thách đánh thức trong chế độ sâu.
///
/// Mỗi loại thử thách (toán, lắc, QR, ...) implement interface này.
/// Logic phải là Dart thuần, không phụ thuộc UI hoặc plugin.
abstract class Challenge {
  /// Loại thử thách: 'math', 'shake', 'qr'
  String get type;

  /// Cấu hình thử thách hiện tại (để serialize nếu cần)
  Map<String, dynamic> get config;

  /// Thử thách đã hoàn thành chưa
  bool get isCompleted;

  /// Tiến trình hiện tại (0.0 → 1.0)
  double get progress;

  /// Khởi tạo thử thách (sinh câu hỏi, setup sensor stream, etc.)
  Future<void> start();

  /// Kiểm tra đáp án / điều kiện hoàn thành.
  /// Trả về true nếu đã hoàn thành toàn bộ thử thách.
  Future<bool> verify(dynamic answer);

  /// Reset về trạng thái ban đầu (sinh câu mới, reset counter).
  void reset();

  /// Giải phóng tài nguyên (sensor subscription, camera, etc.)
  void dispose();
}
