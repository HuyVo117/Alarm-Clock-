import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/challenges/domain/photo_challenge.dart';

void main() {
  group('PhotoChallenge Unit Tests', () {
    test('1. ImageFeatureVector computes correct normalized histogram from RGBA bytes', () {
      // Tạo ảnh giả 2x2: pixel đỏ thuần (255, 0, 0, 255)
      final redPixels = <int>[
        255, 0, 0, 255,
        255, 0, 0, 255,
        255, 0, 0, 255,
        255, 0, 0, 255,
      ];

      final vector = ImageFeatureVector.fromRgbaBytes(redPixels);
      expect(vector.bins.length, equals(32));

      // Kênh R (bin 7: giá trị 255) phải có trọng số cao nhất
      expect(vector.bins[7], greaterThan(0.2));
      // Kênh G và B thấp nhất (bin 8 và bin 16)
      expect(vector.bins[8], greaterThan(0.2)); // G bin 0
      expect(vector.bins[16], greaterThan(0.2)); // B bin 0
    });

    test('2. Cosine similarity between identical vectors is 1.0', () {
      final sample = <int>[
        100, 150, 200, 255,
        50, 80, 120, 255,
      ];
      final v1 = ImageFeatureVector.fromRgbaBytes(sample);
      final v2 = ImageFeatureVector.fromRgbaBytes(sample);

      final similarity = v1.cosineSimilarity(v2);
      expect(similarity, closeTo(1.0, 0.001));
    });

    test('3. Cosine similarity between completely different images is lower', () {
      // Ảnh 1: Màu đỏ
      final redSample = <int>[
        255, 0, 0, 255,
        255, 0, 0, 255,
      ];
      // Ảnh 2: Màu xanh lục
      final greenSample = <int>[
        0, 255, 0, 255,
        0, 255, 0, 255,
      ];

      final vRed = ImageFeatureVector.fromRgbaBytes(redSample);
      final vGreen = ImageFeatureVector.fromRgbaBytes(greenSample);

      final similarity = vRed.cosineSimilarity(vGreen);
      expect(similarity, lessThan(0.6));
    });

    test('4. PhotoChallenge completes when similarity meets threshold', () async {
      final sample = <int>[
        120, 140, 160, 255,
        130, 150, 170, 255,
      ];
      final refVector = ImageFeatureVector.fromRgbaBytes(sample);

      final challenge = PhotoChallenge(
        referencePhotoPath: '/data/reference.jpg',
        similarityThreshold: 0.65,
        referenceFeatures: refVector,
      );

      expect(challenge.isCompleted, isFalse);

      // Verify với ảnh tương tự
      final result = await challenge.verify(refVector);
      expect(result, isTrue);
      expect(challenge.isCompleted, isTrue);
      expect(challenge.lastSimilarity, closeTo(1.0, 0.001));
      expect(challenge.statusMessage, contains('Đã khớp'));
    });

    test('5. PhotoChallenge rejects when similarity is below threshold', () async {
      final refSample = <int>[255, 0, 0, 255];
      final testSample = <int>[0, 0, 255, 255];

      final refVector = ImageFeatureVector.fromRgbaBytes(refSample);
      final testVector = ImageFeatureVector.fromRgbaBytes(testSample);

      final challenge = PhotoChallenge(
        referencePhotoPath: '/data/reference.jpg',
        similarityThreshold: 0.70,
        referenceFeatures: refVector,
      );

      final result = await challenge.verify(testVector);
      expect(result, isFalse);
      expect(challenge.isCompleted, isFalse);
      expect(challenge.statusMessage, contains('Độ khớp chỉ đạt'));
    });

    test('6. PhotoChallenge reset clears completed status', () async {
      final sample = <int>[100, 100, 100, 255];
      final v = ImageFeatureVector.fromRgbaBytes(sample);
      final challenge = PhotoChallenge(
        referencePhotoPath: '/data/ref.jpg',
        referenceFeatures: v,
      );
      await challenge.verify(v);
      expect(challenge.isCompleted, isTrue);

      challenge.reset();
      expect(challenge.isCompleted, isFalse);
      expect(challenge.lastSimilarity, equals(0.0));
    });
  });
}
