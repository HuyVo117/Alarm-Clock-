import 'dart:io';
import 'dart:ui' as ui;
import '../domain/photo_challenge.dart';

/// Dịch vụ trích xuất vector đặc trưng từ file ảnh trên thiết bị.
/// Sử dụng native engine của Flutter (dart:ui) để decode ảnh nhanh và nhẹ.
class PhotoFeatureService {
  /// Đọc file ảnh tại [filePath], resize về thumbnail 64x64 và tính vector đặc trưng.
  static Future<ImageFeatureVector?> extractFeatures(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 64,
        targetHeight: 64,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      codec.dispose();

      if (byteData == null) return null;

      final rgbaBytes = byteData.buffer.asUint8List();
      return ImageFeatureVector.fromRgbaBytes(rgbaBytes);
    } catch (_) {
      return null;
    }
  }
}
