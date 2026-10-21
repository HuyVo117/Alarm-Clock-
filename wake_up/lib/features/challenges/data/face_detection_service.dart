import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../domain/selfie_challenge.dart';

/// Interface trừu tượng cho dịch vụ nhận diện khuôn mặt (để dễ mock và test).
abstract class FaceDetectionService {
  /// Phân tích ảnh chụp tại [filePath] và trích xuất thông tin khuôn mặt.
  Future<SelfieInput> detectFaceFromFile(String filePath, {double elapsedSeconds = 0.5});

  /// Giải phóng tài nguyên ML Kit.
  Future<void> dispose();
}

/// Cài đặt FaceDetectionService sử dụng Google ML Kit Face Detection.
/// Xử lý 100% on-device (offline), không truyền ảnh ra ngoài mạng.
class MlKitFaceDetectionService implements FaceDetectionService {
  final FaceDetector _faceDetector;

  MlKitFaceDetectionService()
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableClassification: true, // Cho phép tính xác suất mở mắt
            performanceMode: FaceDetectorMode.accurate,
            minFaceSize: 0.2, // Khuôn mặt chiếm ít nhất 20% khung hình
          ),
        );

  @override
  Future<SelfieInput> detectFaceFromFile(String filePath, {double elapsedSeconds = 0.5}) async {
    try {
      final inputImage = InputImage.fromFilePath(filePath);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        return const SelfieInput(hasFace: false);
      }

      // Lấy khuôn mặt lớn nhất / rõ nhất trong khung hình
      final face = faces.first;
      return SelfieInput(
        hasFace: true,
        leftEyeOpenProbability: face.leftEyeOpenProbability,
        rightEyeOpenProbability: face.rightEyeOpenProbability,
        headEulerAngleY: face.headEulerAngleY,
        headEulerAngleZ: face.headEulerAngleZ,
        elapsedSeconds: elapsedSeconds,
      );
    } catch (_) {
      return const SelfieInput(hasFace: false);
    }
  }

  @override
  Future<void> dispose() async {
    await _faceDetector.close();
  }
}
