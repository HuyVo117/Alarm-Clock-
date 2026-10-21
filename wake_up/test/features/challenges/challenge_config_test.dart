import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/challenges/domain/challenge_config.dart';

void main() {
  group('ChallengeConfig Unit Tests', () {
    test('1. ChallengeConfig defaultFor generates valid configs', () {
      final math = ChallengeConfig.defaultFor('math');
      expect(math.type, 'math');
      expect(math.params['difficulty'], 1);
      expect(math.params['questionCount'], 3);

      final shake = ChallengeConfig.defaultFor('shake');
      expect(shake.type, 'shake');
      expect(shake.params['targetCount'], 30);

      final qr = ChallengeConfig.defaultFor('qr');
      expect(qr.type, 'qr');
      expect(qr.params['qrHashes'], isEmpty);
    });

    test('2. ChallengeConfig defaultFor throws on unknown type', () {
      expect(
        () => ChallengeConfig.defaultFor('unknown_type'),
        throwsArgumentError,
      );
    });

    test('3. ChallengeConfig JSON serialize/deserialize round-trip', () {
      final configs = [
        const ChallengeConfig(
          type: 'math',
          params: {'difficulty': 2, 'questionCount': 5},
        ),
        const ChallengeConfig(
          type: 'shake',
          params: {'targetCount': 50, 'shakeThreshold': 18.0},
        ),
      ];

      final jsonString = ChallengeConfig.toJsonString(configs);
      expect(jsonString, isNotNull);

      final parsed = ChallengeConfig.fromJsonString(jsonString);
      expect(parsed.length, 2);
      expect(parsed[0].type, 'math');
      expect(parsed[0].params['difficulty'], 2);
      expect(parsed[0].params['questionCount'], 5);
      expect(parsed[1].type, 'shake');
      expect(parsed[1].params['targetCount'], 50);
      expect(parsed[1].params['shakeThreshold'], 18.0);
    });

    test('4. ChallengeConfig fromJsonString null or empty returns empty list', () {
      expect(ChallengeConfig.fromJsonString(null), isEmpty);
      expect(ChallengeConfig.fromJsonString(''), isEmpty);
      expect(ChallengeConfig.fromJsonString('invalid json {['), isEmpty);
    });

    test('5. ChallengeConfig toJsonString empty returns null', () {
      expect(ChallengeConfig.toJsonString([]), isNull);
    });

    test('6. ChallengeConfig copyWith updates parameters properly', () {
      const config = ChallengeConfig(type: 'math', params: {'difficulty': 1});
      final updated = config.copyWith(params: {'difficulty': 3});
      expect(updated.type, 'math');
      expect(updated.params['difficulty'], 3);
    });
  });
}
