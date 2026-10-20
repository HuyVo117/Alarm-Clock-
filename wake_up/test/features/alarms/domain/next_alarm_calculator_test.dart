import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/alarms/domain/next_alarm_calculator.dart';

void main() {
  group('NextAlarmCalculator', () {
    group('nextOneTimeAlarm', () {
      test('trả về alarmTime nếu chưa qua', () {
        final now = DateTime(2026, 10, 20, 8, 0);
        final alarmTime = DateTime(2026, 10, 20, 9, 0);

        final result = NextAlarmCalculator.nextOneTimeAlarm(
          alarmTime: alarmTime,
          now: now,
        );

        expect(result, alarmTime);
      });

      test('trả về null nếu đã qua', () {
        final now = DateTime(2026, 10, 20, 10, 0);
        final alarmTime = DateTime(2026, 10, 20, 9, 0);

        final result = NextAlarmCalculator.nextOneTimeAlarm(
          alarmTime: alarmTime,
          now: now,
        );

        expect(result, isNull);
      });

      test('trả về null nếu đúng lúc hiện tại', () {
        final now = DateTime(2026, 10, 20, 9, 0);
        final alarmTime = DateTime(2026, 10, 20, 9, 0);

        final result = NextAlarmCalculator.nextOneTimeAlarm(
          alarmTime: alarmTime,
          now: now,
        );

        // Không phải isAfter → trả về null
        expect(result, isNull);
      });
    });

    group('nextRepeatingAlarm', () {
      test('báo thức lặp hôm nay chưa qua giờ', () {
        // 20/10/2026 là Thứ 3 (Tuesday = 2)
        final now = DateTime(2026, 10, 20, 6, 0);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 7,
          minute: 30,
          repeatDays: [DateTime.tuesday],
          now: now,
        );

        expect(result, DateTime(2026, 10, 20, 7, 30));
      });

      test('báo thức lặp hôm nay đã qua giờ → tuần sau', () {
        // 20/10/2026 là Thứ 3 (Tuesday = 2)
        final now = DateTime(2026, 10, 20, 8, 0);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 7,
          minute: 30,
          repeatDays: [DateTime.tuesday],
          now: now,
        );

        // Tuần sau Thứ 3: 27/10/2026
        expect(result, DateTime(2026, 10, 27, 7, 30));
      });

      test('nhiều ngày lặp, chọn ngày gần nhất', () {
        // 20/10/2026 là Thứ 3, giờ đã qua
        final now = DateTime(2026, 10, 20, 20, 0);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 7,
          minute: 0,
          repeatDays: [DateTime.tuesday, DateTime.thursday, DateTime.saturday],
          now: now,
        );

        // Thứ 5 gần nhất: 22/10/2026
        expect(result, DateTime(2026, 10, 22, 7, 0));
      });

      test('lặp mỗi ngày', () {
        final now = DateTime(2026, 10, 20, 20, 0);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 7,
          minute: 0,
          repeatDays: [1, 2, 3, 4, 5, 6, 7],
          now: now,
        );

        // Ngày mai
        expect(result, DateTime(2026, 10, 21, 7, 0));
      });

      test('qua nửa đêm (báo thức 0:30)', () {
        final now = DateTime(2026, 10, 20, 23, 59);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 0,
          minute: 30,
          repeatDays: [DateTime.wednesday], // 21/10/2026 = Thứ 4
          now: now,
        );

        expect(result, DateTime(2026, 10, 21, 0, 30));
      });

      test('qua ranh giới tháng', () {
        // 31/10/2026 là Thứ 7 (Saturday = 6)
        final now = DateTime(2026, 10, 31, 20, 0);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 7,
          minute: 0,
          repeatDays: [DateTime.sunday], // CN = 01/11/2026
          now: now,
        );

        expect(result, DateTime(2026, 11, 1, 7, 0));
      });

      test('qua ranh giới năm', () {
        // 31/12/2026 là Thứ 5 (Thursday = 4)
        final now = DateTime(2026, 12, 31, 20, 0);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 8,
          minute: 0,
          repeatDays: [DateTime.friday], // Thứ 6 = 01/01/2027
          now: now,
        );

        expect(result, DateTime(2027, 1, 1, 8, 0));
      });

      test('cuối tuần (thứ 7 + CN)', () {
        // 20/10/2026 là Thứ 3
        final now = DateTime(2026, 10, 20, 8, 0);

        final result = NextAlarmCalculator.nextRepeatingAlarm(
          hour: 9,
          minute: 0,
          repeatDays: [DateTime.saturday, DateTime.sunday],
          now: now,
        );

        // Thứ 7 gần nhất: 24/10/2026
        expect(result, DateTime(2026, 10, 24, 9, 0));
      });
    });

    group('nextAlarm (tích hợp)', () {
      test('báo thức một lần', () {
        final now = DateTime(2026, 10, 20, 8, 0);
        final alarmTime = DateTime(2026, 10, 20, 9, 0);

        final result = NextAlarmCalculator.nextAlarm(
          alarmTime: alarmTime,
          repeatDays: [],
          now: now,
        );

        expect(result, alarmTime);
      });

      test('báo thức lặp', () {
        final now = DateTime(2026, 10, 20, 8, 0);
        final alarmTime = DateTime(2026, 10, 20, 7, 30);

        final result = NextAlarmCalculator.nextAlarm(
          alarmTime: alarmTime,
          repeatDays: [DateTime.tuesday], // Hôm nay
          now: now,
        );

        // Đã qua giờ hôm nay → tuần sau
        expect(result, DateTime(2026, 10, 27, 7, 30));
      });
    });
  });
}
