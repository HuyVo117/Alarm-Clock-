import 'dart:async';
import 'dart:math';

import 'challenge.dart';

/// Interface trừu tượng cho nguồn dữ liệu gia tốc kế.
/// Giúp mock trong unit test.
abstract class AccelerometerProvider {
  /// Stream của các event gia tốc kế (x, y, z) tính bằng m/s².
  Stream<AccelerometerEvent> get events;

  /// Giải phóng tài nguyên.
  void dispose() {}
}

/// Sự kiện gia tốc kế đơn giản.
class AccelerometerEvent {
  final double x;
  final double y;
  final double z;

  const AccelerometerEvent(this.x, this.y, this.z);

  /// Tính magnitude (độ lớn vector gia tốc).
  double get magnitude => sqrt(x * x + y * y + z * z);
}

/// Implementation mặc định dùng sensors_plus.
/// Import riêng để tách dependency với platform plugin.
class SensorsPlusAccelerometerProvider implements AccelerometerProvider {
  StreamSubscription? _subscription;
  final _controller = StreamController<AccelerometerEvent>.broadcast();

  SensorsPlusAccelerometerProvider() {
    // Import sensors_plus tại runtime, sẽ được inject từ UI layer
    // Xem shake_challenge_screen.dart
  }

  /// Tạo từ stream có sẵn (dùng khi inject từ UI)
  SensorsPlusAccelerometerProvider.fromStream(
      Stream<AccelerometerEvent> stream) {
    _subscription = stream.listen((event) {
      _controller.add(event);
    });
  }

  @override
  Stream<AccelerometerEvent> get events => _controller.stream;

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

/// Thử thách lắc điện thoại: phải lắc N lần để hoàn thành.
///
/// Sử dụng gia tốc kế để phát hiện lắc, với ngưỡng (threshold)
/// và debounce để tránh đếm trùng.
///
/// Logic thuần Dart. AccelerometerProvider được inject để dễ test.
class ShakeChallenge implements Challenge {
  final int targetCount;
  final double shakeThreshold;
  final Duration debounceDuration;
  AccelerometerProvider? accelerometerProvider;

  int _shakeCount = 0;
  DateTime? _lastShakeTime;
  StreamSubscription? _subscription;

  // Controller để UI listen số lần lắc
  final _shakeCountController = StreamController<int>.broadcast();

  ShakeChallenge({
    this.targetCount = 30,
    this.shakeThreshold = 15.0,
    int debounceDurationMs = 500,
    this.accelerometerProvider,
  }) : debounceDuration = Duration(milliseconds: debounceDurationMs);

  @override
  String get type => 'shake';

  @override
  Map<String, dynamic> get config => {
        'targetCount': targetCount,
        'shakeThreshold': shakeThreshold,
      };

  @override
  bool get isCompleted => _shakeCount >= targetCount;

  @override
  double get progress =>
      targetCount > 0 ? (_shakeCount / targetCount).clamp(0.0, 1.0) : 0.0;

  /// Số lần đã lắc hiện tại
  int get shakeCount => _shakeCount;

  /// Stream để UI listen thay đổi số lần lắc
  Stream<int> get shakeCountStream => _shakeCountController.stream;

  @override
  Future<void> start() async {
    _shakeCount = 0;
    _lastShakeTime = null;
    _shakeCountController.add(0);

    if (accelerometerProvider != null) {
      _subscription = accelerometerProvider!.events.listen(_onAccelerometerEvent);
    }
  }

  @override
  Future<bool> verify(dynamic answer) async {
    // Verify chỉ kiểm tra trạng thái completed
    return isCompleted;
  }

  @override
  void reset() {
    _shakeCount = 0;
    _lastShakeTime = null;
    _shakeCountController.add(0);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    accelerometerProvider?.dispose();
    _shakeCountController.close();
  }

  /// Xử lý sự kiện gia tốc kế từ bên ngoài.
  /// Public để có thể gọi trực tiếp trong test hoặc từ UI.
  void handleAccelerometerEvent(double x, double y, double z) {
    _onAccelerometerEvent(AccelerometerEvent(x, y, z));
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (isCompleted) return;

    final magnitude = event.magnitude;
    if (magnitude < shakeThreshold) return;

    // Debounce: bỏ qua nếu lắc quá nhanh liên tiếp
    final now = DateTime.now();
    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!) < debounceDuration) {
      return;
    }

    _lastShakeTime = now;
    _shakeCount++;
    if (!_shakeCountController.isClosed) {
      _shakeCountController.add(_shakeCount);
    }
  }
}
