import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/alarms/domain/alarm_model.dart';

void main() {
  group('AlarmModel soundPath support', () {
    test('AlarmModel preserves soundPath through copyWith', () {
      final now = DateTime.now();
      final alarm = AlarmModel(
        id: 1,
        time: now,
        label: 'Dậy đi',
        soundPath: 'assets/audio/radar.wav',
      );

      expect(alarm.soundPath, 'assets/audio/radar.wav');

      final updated = alarm.copyWith(soundPath: 'assets/audio/chime.wav');
      expect(updated.soundPath, 'assets/audio/chime.wav');
      expect(updated.label, 'Dậy đi');

      final cleared = alarm.copyWith(soundPath: null);
      // copyWith without new value keeps previous
      expect(cleared.soundPath, 'assets/audio/radar.wav');
    });

    test('AlarmModel can be created with null soundPath (system default)', () {
      final now = DateTime.now();
      final alarm = AlarmModel(
        id: 2,
        time: now,
        soundPath: null,
      );

      expect(alarm.soundPath, isNull);
    });
  });
}
