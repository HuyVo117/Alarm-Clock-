import 'challenge.dart';

/// Dữ liệu đầu vào cho việc thẩm định khuôn mặt Selfie.
/// Pure Dart model, không phụ thuộc vào Flutter framework hay plugin.
class SelfieInput {
  /// Có phát hiện khuôn mặt trong ảnh/khung hình hay không.
  final bool hasFace;

  /// Xác suất mắt trái đang mở (0.0 đến 1.0) từ ML Kit.
  final double? leftEyeOpenProbability;

  /// Xác suất mắt phải đang mở (0.0 đến 1.0) từ ML Kit.
  final double? rightEyeOpenProbability;

  /// Góc quay đầu theo phương ngang (Euler Y: âm là quay trái, dương là quay phải).
  final double? headEulerAngleY;

  /// Góc nghiêng đầu (Euler Z).
  final double? headEulerAngleZ;

  /// Khoảng thời gian đã trôi qua kể từ lần kiểm tra trước (giây).
  final double elapsedSeconds;

  const SelfieInput({
    required this.hasFace,
    this.leftEyeOpenProbability,
    this.rightEyeOpenProbability,
    this.headEulerAngleY,
    this.headEulerAngleZ,
    this.elapsedSeconds = 0.5,
  });

  /// Trường hợp không có khuôn mặt.
  static const SelfieInput noFace = SelfieInput(hasFace: false);
}

/// Thử thách Selfie trước gương (Face / Selfie Challenge).
///
/// Yêu cầu người dùng hướng khuôn mặt vào camera trước, mở to hai mắt
/// và nhìn thẳng trong một khoảng thời gian nhất định (mặc định 2 giây)
/// để chứng minh đã tỉnh táo hoàn toàn.
class SelfieChallenge implements Challenge {
  /// Có bắt buộc hai mắt phải mở hay không.
  final bool requireEyesOpen;

  /// Thời gian cần giữ khuôn mặt ổn định trong khung (giây).
  final int holdDurationSeconds;

  /// Ngưỡng xác suất để coi mắt là đang mở (mặc định 0.4).
  final double minEyeOpenProbability;

  bool _isCompleted = false;
  double _currentHoldSeconds = 0.0;
  bool _isFaceDetected = false;
  bool _areEyesOpen = false;
  String _statusMessage = '';

  SelfieChallenge({
    this.requireEyesOpen = true,
    this.holdDurationSeconds = 2,
    this.minEyeOpenProbability = 0.4,
  });

  @override
  String get type => 'selfie';

  @override
  Map<String, dynamic> get config => {
        'requireEyesOpen': requireEyesOpen,
        'holdDurationSeconds': holdDurationSeconds,
        'minEyeOpenProbability': minEyeOpenProbability,
      };

  @override
  bool get isCompleted => _isCompleted;

  @override
  double get progress => holdDurationSeconds > 0
      ? (_currentHoldSeconds / holdDurationSeconds).clamp(0.0, 1.0)
      : 1.0;

  /// Thời gian người dùng đã giữ mặt chuẩn trong khung (giây).
  double get currentHoldSeconds => _currentHoldSeconds;

  /// Trạng thái hiện tại có đang phát hiện mặt không.
  bool get isFaceDetected => _isFaceDetected;

  /// Trạng thái hai mắt hiện tại có đang mở không.
  bool get areEyesOpen => _areEyesOpen;

  /// Thông điệp hướng dẫn tương ứng với trạng thái hiện tại.
  String get statusMessage => _statusMessage;

  @override
  Future<void> start() async {
    reset();
  }

  @override
  Future<bool> verify(dynamic answer) async {
    if (_isCompleted) return true;

    if (answer is! SelfieInput) {
      _statusMessage = 'Dữ liệu không hợp lệ';
      return false;
    }

    // 1. Kiểm tra có khuôn mặt không
    if (!answer.hasFace) {
      _isFaceDetected = false;
      _areEyesOpen = false;
      _currentHoldSeconds = 0.0;
      _statusMessage = 'Đưa khuôn mặt vào khung soi gương';
      return false;
    }

    _isFaceDetected = true;

    // 2. Kiểm tra góc nhìn thẳng (không quay mặt sang ngang quá 25 độ)
    final eulerY = answer.headEulerAngleY?.abs() ?? 0.0;
    if (eulerY > 25.0) {
      _currentHoldSeconds = 0.0;
      _statusMessage = 'Hãy nhìn thẳng vào camera';
      return false;
    }

    // 3. Kiểm tra trạng thái mở mắt
    if (requireEyesOpen) {
      final leftOpen = (answer.leftEyeOpenProbability ?? 1.0) >= minEyeOpenProbability;
      final rightOpen = (answer.rightEyeOpenProbability ?? 1.0) >= minEyeOpenProbability;

      if (!leftOpen || !rightOpen) {
        _areEyesOpen = false;
        _currentHoldSeconds = 0.0;
        _statusMessage = 'Hãy mở to hai mắt';
        return false;
      }
      _areEyesOpen = true;
    } else {
      _areEyesOpen = true;
    }

    // 4. Nếu đạt tất cả tiêu chí, cộng dồn thời gian giữ tư thế
    _currentHoldSeconds += answer.elapsedSeconds;
    final remaining = (holdDurationSeconds - _currentHoldSeconds).clamp(0.0, holdDurationSeconds.toDouble());

    if (_currentHoldSeconds >= holdDurationSeconds) {
      _isCompleted = true;
      _statusMessage = 'Tuyệt vời! Đã tỉnh táo!';
      return true;
    } else {
      _statusMessage = 'Giữ nguyên trong ${remaining.toStringAsFixed(1)}s...';
      return false;
    }
  }

  @override
  void reset() {
    _isCompleted = false;
    _currentHoldSeconds = 0.0;
    _isFaceDetected = false;
    _areEyesOpen = false;
    _statusMessage = 'Đưa khuôn mặt vào khung soi gương';
  }

  @override
  void dispose() {
    // Không giữ tài nguyên platform
  }
}
