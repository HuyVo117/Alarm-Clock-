import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/challenges/domain/qr_challenge.dart';

void main() {
  group('QrChallenge Unit Tests', () {
    test('1. hashQrCode produces deterministic SHA-256 hash', () {
      const code1 = 'WAKEUP_ALARM_QR_BATHROOM';
      final hash1a = QrChallenge.hashQrCode(code1);
      final hash1b = QrChallenge.hashQrCode(code1);

      expect(hash1a, equals(hash1b));
      expect(hash1a.length, 64); // SHA-256 hex string has 64 characters

      const code2 = 'WAKEUP_ALARM_QR_KITCHEN';
      final hash2 = QrChallenge.hashQrCode(code2);
      expect(hash1a, isNot(equals(hash2)));
    });

    test('2. QrChallenge verify returns true for registered QR code', () async {
      const registeredRaw = 'https://example.com/alarm-code';
      final registeredHash = QrChallenge.hashQrCode(registeredRaw);

      final challenge = QrChallenge(registeredHashes: [registeredHash]);
      await challenge.start();

      expect(challenge.isCompleted, isFalse);
      expect(challenge.progress, 0.0);

      final result = await challenge.verify(registeredRaw);
      expect(result, isTrue);
      expect(challenge.isCompleted, isTrue);
      expect(challenge.progress, 1.0);
      expect(challenge.lastScannedHash, equals(registeredHash));
    });

    test('3. QrChallenge verify returns false for unregistered QR code',
        () async {
      const registeredRaw = 'https://example.com/registered';
      final registeredHash = QrChallenge.hashQrCode(registeredRaw);

      final challenge = QrChallenge(registeredHashes: [registeredHash]);
      await challenge.start();

      final result = await challenge.verify('https://example.com/unregistered');
      expect(result, isFalse);
      expect(challenge.isCompleted, isFalse);
      expect(challenge.progress, 0.0);
    });

    test('4. QrChallenge supports multiple registered hashes', () async {
      const codeA = 'CODE_A';
      const codeB = 'CODE_B';
      final hashA = QrChallenge.hashQrCode(codeA);
      final hashB = QrChallenge.hashQrCode(codeB);

      final challenge = QrChallenge(registeredHashes: [hashA, hashB]);
      await challenge.start();

      // Either code A or code B succeeds
      expect(await challenge.verify(codeB), isTrue);
      expect(challenge.isCompleted, isTrue);
    });

    test('5. QrChallenge verify handles empty or non-string input gracefully',
        () async {
      final challenge = QrChallenge(registeredHashes: ['dummy_hash']);
      await challenge.start();

      expect(await challenge.verify(''), isFalse);
      expect(await challenge.verify(null), isFalse);
      expect(await challenge.verify(12345), isFalse);
      expect(challenge.isCompleted, isFalse);
    });

    test('6. QrChallenge reset clears completed status and lastScannedHash',
        () async {
      const code = 'TEST_CODE';
      final hash = QrChallenge.hashQrCode(code);
      final challenge = QrChallenge(registeredHashes: [hash]);
      await challenge.start();

      await challenge.verify(code);
      expect(challenge.isCompleted, isTrue);
      expect(challenge.lastScannedHash, isNotNull);

      challenge.reset();
      expect(challenge.isCompleted, isFalse);
      expect(challenge.lastScannedHash, isNull);
    });
  });
}
