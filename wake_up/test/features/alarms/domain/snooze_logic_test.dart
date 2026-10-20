import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/alarms/domain/snooze_logic.dart';

void main() {
  group('SnoozeLogic', () {
    test('khởi tạo với đếm = 0', () {
      final snooze = SnoozeLogic(intervalMinutes: 5, maxCount: 3);
      expect(snooze.currentCount, 0);
      expect(snooze.canSnooze, isTrue);
      expect(snooze.remainingCount, 3);
    });

    test('snooze trả về thời điểm đúng', () {
      final snooze = SnoozeLogic(intervalMinutes: 5, maxCount: 3);
      final now = DateTime(2026, 10, 20, 7, 0);

      final result = snooze.snooze(now);

      expect(result, DateTime(2026, 10, 20, 7, 5));
      expect(snooze.currentCount, 1);
      expect(snooze.remainingCount, 2);
    });

    test('snooze nhiều lần với interval khác nhau', () {
      final snooze = SnoozeLogic(intervalMinutes: 9, maxCount: 3);
      final now = DateTime(2026, 10, 20, 7, 0);

      final first = snooze.snooze(now);
      expect(first, DateTime(2026, 10, 20, 7, 9));

      final second = snooze.snooze(first!);
      expect(second, DateTime(2026, 10, 20, 7, 18));

      final third = snooze.snooze(second!);
      expect(third, DateTime(2026, 10, 20, 7, 27));
    });

    test('hết lượt snooze trả về null', () {
      final snooze = SnoozeLogic(intervalMinutes: 5, maxCount: 2);
      final now = DateTime(2026, 10, 20, 7, 0);

      snooze.snooze(now); // lần 1
      snooze.snooze(now); // lần 2

      expect(snooze.canSnooze, isFalse);
      expect(snooze.remainingCount, 0);

      final result = snooze.snooze(now); // lần 3 → null
      expect(result, isNull);
      expect(snooze.currentCount, 2); // Không tăng thêm
    });

    test('reset đặt lại bộ đếm', () {
      final snooze = SnoozeLogic(intervalMinutes: 5, maxCount: 3);
      final now = DateTime(2026, 10, 20, 7, 0);

      snooze.snooze(now);
      snooze.snooze(now);
      expect(snooze.currentCount, 2);

      snooze.reset();
      expect(snooze.currentCount, 0);
      expect(snooze.canSnooze, isTrue);
      expect(snooze.remainingCount, 3);
    });

    test('maxCount = 0 thì không snooze được', () {
      final snooze = SnoozeLogic(intervalMinutes: 5, maxCount: 0);
      final now = DateTime(2026, 10, 20, 7, 0);

      expect(snooze.canSnooze, isFalse);
      final result = snooze.snooze(now);
      expect(result, isNull);
    });

    test('snooze qua nửa đêm', () {
      final snooze = SnoozeLogic(intervalMinutes: 15, maxCount: 3);
      final now = DateTime(2026, 10, 20, 23, 50);

      final result = snooze.snooze(now);
      expect(result, DateTime(2026, 10, 21, 0, 5));
    });

    test('maxCount = 1 chỉ snooze được 1 lần', () {
      final snooze = SnoozeLogic(intervalMinutes: 5, maxCount: 1);
      final now = DateTime(2026, 10, 20, 7, 0);

      final first = snooze.snooze(now);
      expect(first, isNotNull);
      expect(snooze.canSnooze, isFalse);

      final second = snooze.snooze(now);
      expect(second, isNull);
    });
  });
}
