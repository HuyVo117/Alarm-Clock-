import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/media/domain/alarm_sound.dart';

void main() {
  group('AlarmSound domain model', () {
    test('builtInSounds contains standard sound choices', () {
      expect(AlarmSound.builtInSounds.isNotEmpty, isTrue);
      expect(AlarmSound.builtInSounds.any((s) => s.path == null), isTrue); // default
      expect(AlarmSound.builtInSounds.any((s) => s.path == 'assets/audio/alarm.mp3'), isTrue); // classic
      expect(AlarmSound.builtInSounds.any((s) => s.path == 'assets/audio/radar.wav'), isTrue); // radar
      expect(AlarmSound.builtInSounds.any((s) => s.path == 'assets/audio/chime.wav'), isTrue); // chime
      expect(AlarmSound.builtInSounds.any((s) => s.path == 'assets/audio/digital_beep.wav'), isTrue); // digital
    });

    test('getDisplayName returns correct titles for built-ins', () {
      expect(AlarmSound.getDisplayName(null), 'Mặc định hệ thống');
      expect(AlarmSound.getDisplayName('assets/audio/alarm.mp3'), 'Cổ điển (Classic)');
      expect(AlarmSound.getDisplayName('assets/audio/radar.wav'), 'Radar (Nhịp điệu dồn dập)');
      expect(AlarmSound.getDisplayName('assets/audio/chime.wav'), 'Chuông ngân (Dịu êm)');
      expect(AlarmSound.getDisplayName('assets/audio/digital_beep.wav'), 'Đồng hồ điện tử (Digital Beep)');
    });

    test('getDisplayName formats custom sound file paths nicely', () {
      expect(
        AlarmSound.getDisplayName('/data/user/0/com.wakeup.app/app_flutter/custom_media/sound_1700000000_my_song.mp3'),
        'my_song.mp3',
      );
      expect(
        AlarmSound.getDisplayName('custom_audio.wav'),
        'custom_audio.wav',
      );
    });

    test('SoundSelection wraps soundPath accurately', () {
      const selNull = SoundSelection(null);
      expect(selNull.soundPath, isNull);

      const selCustom = SoundSelection('assets/audio/radar.wav');
      expect(selCustom.soundPath, 'assets/audio/radar.wav');
    });
  });
}
