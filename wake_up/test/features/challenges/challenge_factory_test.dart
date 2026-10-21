import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/challenges/domain/challenge_config.dart';
import 'package:wake_up/features/challenges/domain/challenge_factory.dart';
import 'package:wake_up/features/challenges/domain/math_challenge.dart';
import 'package:wake_up/features/challenges/domain/photo_challenge.dart';
import 'package:wake_up/features/challenges/domain/qr_challenge.dart';
import 'package:wake_up/features/challenges/domain/selfie_challenge.dart';
import 'package:wake_up/features/challenges/domain/shake_challenge.dart';

void main() {
  group('ChallengeFactory Unit Tests', () {
    test('1. ChallengeFactory creates MathChallenge with params', () {
      const config = ChallengeConfig(
        type: 'math',
        params: {'difficulty': 3, 'questionCount': 5},
      );
      final challenge = ChallengeFactory.create(config);
      expect(challenge, isA<MathChallenge>());
      expect((challenge as MathChallenge).difficulty, 3);
      expect(challenge.questionCount, 5);
      expect(challenge.type, 'math');
    });

    test('2. ChallengeFactory creates ShakeChallenge with params', () {
      const config = ChallengeConfig(
        type: 'shake',
        params: {'targetCount': 45, 'shakeThreshold': 18.5},
      );
      final challenge = ChallengeFactory.create(config);
      expect(challenge, isA<ShakeChallenge>());
      expect((challenge as ShakeChallenge).targetCount, 45);
      expect(challenge.shakeThreshold, 18.5);
      expect(challenge.type, 'shake');
    });

    test('3. ChallengeFactory creates QrChallenge with registeredHashes', () {
      const config = ChallengeConfig(
        type: 'qr',
        params: {
          'qrHashes': ['hash1', 'hash2']
        },
      );
      final challenge = ChallengeFactory.create(config);
      expect(challenge, isA<QrChallenge>());
      expect((challenge as QrChallenge).registeredHashes, ['hash1', 'hash2']);
      expect(challenge.type, 'qr');
    });

    test('4. ChallengeFactory creates SelfieChallenge with params', () {
      const config = ChallengeConfig(
        type: 'selfie',
        params: {'requireEyesOpen': false, 'holdDurationSeconds': 3},
      );
      final challenge = ChallengeFactory.create(config);
      expect(challenge, isA<SelfieChallenge>());
      expect((challenge as SelfieChallenge).requireEyesOpen, isFalse);
      expect(challenge.holdDurationSeconds, 3);
      expect(challenge.type, 'selfie');
    });

    test('5. ChallengeFactory creates PhotoChallenge with params', () {
      const config = ChallengeConfig(
        type: 'photo',
        params: {
          'referencePhotoPath': '/test/path.jpg',
          'similarityThreshold': 0.75,
        },
      );
      final challenge = ChallengeFactory.create(config);
      expect(challenge, isA<PhotoChallenge>());
      expect((challenge as PhotoChallenge).referencePhotoPath, '/test/path.jpg');
      expect(challenge.similarityThreshold, 0.75);
      expect(challenge.type, 'photo');
    });

    test('6. ChallengeFactory throws ArgumentError for unknown type', () {
      const config = ChallengeConfig(type: 'unknown');
      expect(() => ChallengeFactory.create(config), throwsArgumentError);
    });

    test('7. ChallengeFactory createAll creates list of challenges', () {
      final configs = [
        const ChallengeConfig(type: 'math'),
        const ChallengeConfig(type: 'shake'),
        const ChallengeConfig(type: 'selfie'),
        const ChallengeConfig(type: 'photo'),
      ];
      final challenges = ChallengeFactory.createAll(configs);
      expect(challenges.length, 4);
      expect(challenges[0], isA<MathChallenge>());
      expect(challenges[1], isA<ShakeChallenge>());
      expect(challenges[2], isA<SelfieChallenge>());
      expect(challenges[3], isA<PhotoChallenge>());
    });
  });
}
