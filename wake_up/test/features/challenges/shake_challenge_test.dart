import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/challenges/domain/shake_challenge.dart';

void main() {
  group('ShakeChallenge Unit Tests', () {
    test('1. AccelerometerEvent calculates correct vector magnitude', () {
      const event = AccelerometerEvent(3.0, 4.0, 0.0);
      expect(event.magnitude, 5.0);

      const event3d = AccelerometerEvent(2.0, 3.0, 6.0);
      expect(event3d.magnitude, 7.0);
    });

    test('2. ShakeChallenge increments count when magnitude exceeds threshold',
        () async {
      final challenge = ShakeChallenge(
        targetCount: 5,
        shakeThreshold: 15.0,
        debounceDurationMs: 50,
      );
      await challenge.start();

      expect(challenge.shakeCount, 0);
      expect(challenge.isCompleted, isFalse);

      // Event above threshold (magnitude = 20.0)
      challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);
      expect(challenge.shakeCount, 1);
      expect(challenge.progress, closeTo(0.2, 0.01));
    });

    test('3. ShakeChallenge ignores events below threshold', () async {
      final challenge = ShakeChallenge(
        targetCount: 5,
        shakeThreshold: 15.0,
        debounceDurationMs: 50,
      );
      await challenge.start();

      // Event below threshold (magnitude = 9.8)
      challenge.handleAccelerometerEvent(0.0, 9.8, 0.0);
      expect(challenge.shakeCount, 0);
      expect(challenge.progress, 0.0);
    });

    test('4. ShakeChallenge debounces consecutive rapid shakes', () async {
      final challenge = ShakeChallenge(
        targetCount: 5,
        shakeThreshold: 15.0,
        debounceDurationMs: 100,
      );
      await challenge.start();

      challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);
      expect(challenge.shakeCount, 1);

      // Rapid shake immediately within 100ms debounce
      challenge.handleAccelerometerEvent(25.0, 0.0, 0.0);
      expect(challenge.shakeCount, 1);

      // After debounce duration
      await Future.delayed(const Duration(milliseconds: 120));
      challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);
      expect(challenge.shakeCount, 2);
    });

    test('5. ShakeChallenge completes when target count is reached', () async {
      final challenge = ShakeChallenge(
        targetCount: 3,
        shakeThreshold: 15.0,
        debounceDurationMs: 10,
      );
      await challenge.start();

      for (int i = 0; i < 3; i++) {
        challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);
        await Future.delayed(const Duration(milliseconds: 15));
      }

      expect(challenge.shakeCount, 3);
      expect(challenge.isCompleted, isTrue);
      expect(challenge.progress, 1.0);
      expect(await challenge.verify(null), isTrue);

      // Extra shake after completion does not increase count
      challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);
      expect(challenge.shakeCount, 3);
    });

    test('6. ShakeChallenge reset resets count to 0', () async {
      final challenge = ShakeChallenge(
        targetCount: 5,
        shakeThreshold: 15.0,
        debounceDurationMs: 10,
      );
      await challenge.start();

      challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);
      expect(challenge.shakeCount, 1);

      challenge.reset();
      expect(challenge.shakeCount, 0);
      expect(challenge.isCompleted, isFalse);
    });

    test('7. ShakeChallenge shakeCountStream emits updates', () async {
      final challenge = ShakeChallenge(
        targetCount: 3,
        shakeThreshold: 15.0,
        debounceDurationMs: 10,
      );

      final counts = <int>[];
      final sub = challenge.shakeCountStream.listen(counts.add);

      await challenge.start();
      challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);

      await Future.delayed(const Duration(milliseconds: 20));
      challenge.handleAccelerometerEvent(20.0, 0.0, 0.0);

      await Future.delayed(const Duration(milliseconds: 20));
      await sub.cancel();
      challenge.dispose();

      expect(counts, containsAllInOrder([0, 1, 2]));
    });
  });
}
