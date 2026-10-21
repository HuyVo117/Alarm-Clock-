import 'dart:math';

import 'challenge.dart';

/// Vector đặc trưng ảnh dựa trên histogram màu sắc và độ sáng.
/// Pure Dart, chạy cực nhanh và không phụ thuộc plugin.
class ImageFeatureVector {
  /// Mảng 32 bin: 8 bin R, 8 bin G, 8 bin B, 8 bin Độ sáng (Luminance).
  final List<double> bins;

  const ImageFeatureVector(this.bins);

  /// Trích xuất vector đặc trưng từ mảng pixel RGBA (mỗi pixel gồm 4 byte: R, G, B, A).
  factory ImageFeatureVector.fromRgbaBytes(List<int> rgbaBytes) {
    if (rgbaBytes.isEmpty) {
      return ImageFeatureVector(List.filled(32, 0.0));
    }

    final rawCounts = List<double>.filled(32, 0.0);
    int totalPixels = 0;

    // Duyệt qua từng pixel (bước nhảy 4 byte)
    for (int i = 0; i + 3 < rgbaBytes.length; i += 4) {
      final r = rgbaBytes[i];
      final g = rgbaBytes[i + 1];
      final b = rgbaBytes[i + 2];
      final a = rgbaBytes[i + 3];

      // Bỏ qua pixel trong suốt
      if (a < 50) continue;

      // Phân vào 8 bin cho mỗi kênh màu (0..255 -> 0..7)
      final rBin = (r * 8 ~/ 256).clamp(0, 7);
      final gBin = 8 + (g * 8 ~/ 256).clamp(0, 7);
      final bBin = 16 + (b * 8 ~/ 256).clamp(0, 7);

      // Độ sáng theo tiêu chuẩn ITU-R BT.601
      final luma = (0.299 * r + 0.587 * g + 0.114 * b).round();
      final lumaBin = 24 + (luma * 8 ~/ 256).clamp(0, 7);

      rawCounts[rBin] += 1.0;
      rawCounts[gBin] += 1.0;
      rawCounts[bBin] += 1.0;
      rawCounts[lumaBin] += 1.0;

      totalPixels++;
    }

    if (totalPixels == 0) {
      return ImageFeatureVector(List.filled(32, 0.0));
    }

    // Chuẩn hóa vector (tổng = 1)
    final normalized = rawCounts.map((c) => c / (totalPixels * 4)).toList();
    return ImageFeatureVector(normalized);
  }

  /// Tính độ tương đồng Cosine Similarity giữa 2 vector đặc trưng (0.0 đến 1.0).
  double cosineSimilarity(ImageFeatureVector other) {
    if (bins.length != other.bins.length) return 0.0;

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < bins.length; i++) {
      final a = bins[i];
      final b = other.bins[i];
      dotProduct += a * b;
      normA += a * a;
      normB += b * b;
    }

    if (normA <= 0.0 || normB <= 0.0) return 0.0;

    final similarity = dotProduct / (sqrt(normA) * sqrt(normB));
    return similarity.clamp(0.0, 1.0);
  }
}

/// Thử thách Chụp ảnh rời giường / trước gương tham chiếu (Photo Challenge).
///
/// Người dùng chụp ảnh 1 vị trí cố định (bàn học, bồn rửa mặt, góc phòng, gương)
/// lúc cài đặt. Khi chuông reo, phải bước đến vị trí đó và chụp lại ảnh đối chiếu.
class PhotoChallenge implements Challenge {
  /// Đường dẫn file ảnh tham chiếu đã chụp lúc cài đặt.
  final String referencePhotoPath;

  /// Ngưỡng tương đồng tối thiểu để coi là khớp (mặc định 0.65 = 65%).
  final double similarityThreshold;

  /// Vector đặc trưng của ảnh tham chiếu (có thể inject trực tiếp).
  ImageFeatureVector? referenceFeatures;

  bool _isCompleted = false;
  double _lastSimilarity = 0.0;
  String _statusMessage = '';

  PhotoChallenge({
    required this.referencePhotoPath,
    this.similarityThreshold = 0.65,
    this.referenceFeatures,
  });

  @override
  String get type => 'photo';

  @override
  Map<String, dynamic> get config => {
        'referencePhotoPath': referencePhotoPath,
        'similarityThreshold': similarityThreshold,
      };

  @override
  bool get isCompleted => _isCompleted;

  @override
  double get progress => _isCompleted ? 1.0 : (_lastSimilarity / similarityThreshold).clamp(0.0, 1.0);

  /// Điểm tương đồng của lần chụp gần nhất (0.0 đến 1.0).
  double get lastSimilarity => _lastSimilarity;

  /// Thông điệp kết quả hiển thị cho người dùng.
  String get statusMessage => _statusMessage;

  @override
  Future<void> start() async {
    reset();
  }

  @override
  Future<bool> verify(dynamic answer) async {
    if (_isCompleted) return true;

    ImageFeatureVector? currentFeatures;
    if (answer is ImageFeatureVector) {
      currentFeatures = answer;
    } else if (answer is List<int>) {
      currentFeatures = ImageFeatureVector.fromRgbaBytes(answer);
    } else {
      _statusMessage = 'Dữ liệu ảnh không hợp lệ';
      return false;
    }

    if (referenceFeatures == null) {
      _statusMessage = 'Chưa nạp đặc trưng ảnh mẫu';
      return false;
    }

    final score = referenceFeatures!.cosineSimilarity(currentFeatures);
    _lastSimilarity = score;

    final percent = (score * 100).toStringAsFixed(0);

    if (score >= similarityThreshold) {
      _isCompleted = true;
      _statusMessage = 'Đã khớp $percent%! Báo thức đã tắt.';
      return true;
    } else {
      _statusMessage = 'Độ khớp chỉ đạt $percent% (cần ${(similarityThreshold * 100).toInt()}%). Hãy chụp đúng góc hoặc bật đèn sáng hơn.';
      return false;
    }
  }

  @override
  void reset() {
    _isCompleted = false;
    _lastSimilarity = 0.0;
    _statusMessage = 'Hãy chụp ảnh góc phòng/vị trí mẫu để tắt báo thức';
  }

  @override
  void dispose() {
    // Không giữ tài nguyên platform
  }
}
