import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/challenges/domain/selfie_challenge.dart';

void main() {
  group('SelfieChallenge Unit Tests', () {
    test('1. Initial state is correct and incomplete', () {
      final challenge = SelfieChallenge(holdDurationSeconds: 2);
      expect(challenge.type, equals('selfie'));
      expect(challenge.isCompleted, isFalse);
      expect(challenge.currentHoldSeconds, equals(0.0));
      expect(challenge.progress, equals(0.0));
      expect(challenge.isFaceDetected, isFalse);
    });

    test('2. Verify returns false when no face detected', () async {
      final challenge = SelfieChallenge(holdDurationSeconds: 2);
      final result = await challenge.verify(SelfieInput.noFace);

      expect(result, isFalse);
      expect(challenge.isCompleted, isFalse);
      expect(challenge.isFaceDetected, isFalse);
      expect(challenge.statusMessage, contains('Đưa khuôn mặt vào khung'));
    });

    test('3. Verify rejects face tilted too far sideways (eulerY > 25)', () async {
      final challenge = SelfieChallenge(holdDurationSeconds: 2);
      const inputTilted = SelfieInput(
        hasFace: true,
        headEulerAngleY: 30.0,
        leftEyeOpenProbability: 0.9,
        rightEyeOpenProbability: 0.9,
      );

      final result = await challenge.verify(inputTilted);
      expect(result, isFalse);
      expect(challenge.isCompleted, isFalse);
      expect(challenge.statusMessage, contains('nhìn thẳng'));
    });

    test('4. Verify rejects when eyes are closed if requireEyesOpen is true', () async {
      final challenge = SelfieChallenge(
        holdDurationSeconds: 2,
        requireEyesOpen: true,
      );
      const inputEyesClosed = SelfieInput(
        hasFace: true,
        headEulerAngleY: 5.0,
        leftEyeOpenProbability: 0.1, // nhắm mắt
        rightEyeOpenProbability: 0.8,
      );

      final result = await challenge.verify(inputEyesClosed);
      expect(result, isFalse);
      expect(challenge.isCompleted, isFalse);
      expect(challenge.areEyesOpen, isFalse);
      expect(challenge.statusMessage, contains('mở to hai mắt'));
    });

    test('5. Accumulates hold duration and completes when target is reached', () async {
      final challenge = SelfieChallenge(
        holdDurationSeconds: 2,
        requireEyesOpen: true,
      );
      const validStep = SelfieInput(
        hasFace: true,
        headEulerAngleY: 0.0,
        leftEyeOpenProbability: 0.9,
        rightEyeOpenProbability: 0.9,
        elapsedSeconds: 1.0,
      );

      // Bước 1: 1.0 giây
      final step1 = await challenge.verify(validStep);
      expect(step1, isFalse);
      expect(challenge.isCompleted, isFalse);
      expect(challenge.currentHoldSeconds, equals(1.0));
      expect(challenge.progress, equals(0.5));
      expect(challenge.isFaceDetected, isTrue);
      expect(challenge.areEyesOpen, isTrue);

      // Bước 2: Thêm 1.0 giây -> Đủ 2.0 giây
      final step2 = await challenge.verify(validStep);
      expect(step2, isTrue);
      expect(challenge.isCompleted, isTrue);
      expect(challenge.currentHoldSeconds, equals(2.0));
      expect(challenge.progress, equals(1.0));
      expect(challenge.statusMessage, contains('Tuyệt vời'));
    });

    test('6. Resets hold timer if face disappears before completing', () async {
      final challenge = SelfieChallenge(holdDurationSeconds: 2);
      const validStep = SelfieInput(
        hasFace: true,
        leftEyeOpenProbability: 0.9,
        rightEyeOpenProbability: 0.9,
        elapsedSeconds: 1.0,
      );

      await challenge.verify(validStep);
      expect(challenge.currentHoldSeconds, equals(1.0));

      // Mất mặt
      await challenge.verify(SelfieInput.noFace);
      expect(challenge.currentHoldSeconds, equals(0.0));
      expect(challenge.progress, equals(0.0));
      expect(challenge.isCompleted, isFalse);
    });

    test('7. Reset restores initial state', () async {
      final challenge = SelfieChallenge(holdDurationSeconds: 2);
      const validStep = SelfieInput(
        hasFace: true,
        leftEyeOpenProbability: 0.9,
        rightEyeOpenProbability: 0.9,
        elapsedSeconds: 2.0,
      );
      await challenge.verify(validStep);
      expect(challenge.isCompleted, isTrue);

      challenge.reset();
      expect(challenge.isCompleted, isFalse);
      expect(challenge.currentHoldSeconds, equals(0.0));
      expect(challenge.isFaceDetected, isFalse);
    });
  });
}
