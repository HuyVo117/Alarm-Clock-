import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/world_clock/domain/world_clock_service.dart';

void main() {
  late WorldClockService service;

  setUpAll(() {
    WorldClockService.initialize();
  });

  setUp(() {
    service = WorldClockService();
  });

  group('WorldClockService', () {
    test('initialization loads timezone database', () {
      expect(WorldClockService.isInitialized, isTrue);
      expect(service.getLocation('Asia/Ho_Chi_Minh'), isNotNull);
      expect(service.getLocation('Asia/Tokyo'), isNotNull);
      expect(service.getLocation('Europe/London'), isNotNull);
      expect(service.getLocation('America/New_York'), isNotNull);
    });

    test('invalid timezone returns null and does not throw', () {
      expect(service.getLocation('Invalid/Timezone_Name'), isNull);
      final now = service.nowIn('Invalid/Timezone_Name');
      expect(now, isNotNull);
    });

    test('calculates correct time and UTC offset for known timezones at fixed UTC time', () {
      // 2026-10-21 03:00:00 UTC
      final baseUtc = DateTime.utc(2026, 10, 21, 3, 0, 0);

      // Asia/Ho_Chi_Minh is UTC+7 -> 10:00:00
      final vnTime = service.nowIn('Asia/Ho_Chi_Minh', baseUtc);
      expect(vnTime.hour, 10);
      expect(vnTime.minute, 0);
      expect(service.getUtcOffsetString('Asia/Ho_Chi_Minh', baseUtc), 'UTC+07:00');

      // Asia/Tokyo is UTC+9 -> 12:00:00
      final tokyoTime = service.nowIn('Asia/Tokyo', baseUtc);
      expect(tokyoTime.hour, 12);
      expect(tokyoTime.minute, 0);
      expect(service.getUtcOffsetString('Asia/Tokyo', baseUtc), 'UTC+09:00');
    });

    test('isDaytime detects day and night correctly (06:00 to 17:59 is daytime)', () {
      // 03:00 UTC:
      // - Vietnam: 10:00 (Daytime: 10 >= 6 && 10 < 18) -> true
      // - Tokyo: 12:00 (Daytime) -> true
      // - New York (UTC-4 in Oct/EDT): 23:00 previous day (Night: 23 >= 18) -> false
      final baseUtc = DateTime.utc(2026, 10, 21, 3, 0, 0);

      expect(service.isDaytime('Asia/Ho_Chi_Minh', baseUtc), isTrue);
      expect(service.isDaytime('Asia/Tokyo', baseUtc), isTrue);
      expect(service.isDaytime('America/New_York', baseUtc), isFalse);
    });

    test('getRelativeDescription produces readable difference', () {
      // 2026-10-21 05:00:00 UTC
      // Note: Device local may vary, but relative text format is guaranteed
      final baseUtc = DateTime.utc(2026, 10, 21, 5, 0, 0);

      final desc = service.getRelativeDescription(
        'Asia/Tokyo',
        baseUtc: baseUtc,
        todayText: 'Hôm nay',
        tomorrowText: 'Ngày mai',
        yesterdayText: 'Hôm qua',
        sameTimeText: 'cùng giờ',
        hoursAheadSuffix: 'giờ',
        hoursBehindSuffix: 'giờ',
      );

      expect(desc, isNotEmpty);
      expect(
        desc.contains('Hôm nay') || desc.contains('Ngày mai') || desc.contains('Hôm qua'),
        isTrue,
      );
    });
  });
}
