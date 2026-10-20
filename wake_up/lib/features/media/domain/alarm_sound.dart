import 'package:path/path.dart' as p;

/// Model đại diện cho một tùy chọn âm thanh báo thức.
class AlarmSound {
  final String id;
  final String title;
  final String? path; // null = chuông mặc định của hệ thống
  final bool isAsset;

  const AlarmSound({
    required this.id,
    required this.title,
    this.path,
    this.isAsset = true,
  });

  /// Danh sách các âm thanh mặc định có sẵn trong app
  static const List<AlarmSound> builtInSounds = [
    AlarmSound(
      id: 'default',
      title: 'Mặc định hệ thống',
      path: null,
      isAsset: false,
    ),
    AlarmSound(
      id: 'classic',
      title: 'Cổ điển (Classic)',
      path: 'assets/audio/alarm.mp3',
      isAsset: true,
    ),
    AlarmSound(
      id: 'radar',
      title: 'Radar (Nhịp điệu dồn dập)',
      path: 'assets/audio/radar.wav',
      isAsset: true,
    ),
    AlarmSound(
      id: 'chime',
      title: 'Chuông ngân (Dịu êm)',
      path: 'assets/audio/chime.wav',
      isAsset: true,
    ),
    AlarmSound(
      id: 'digital',
      title: 'Đồng hồ điện tử (Digital Beep)',
      path: 'assets/audio/digital_beep.wav',
      isAsset: true,
    ),
  ];

  /// Trả về tên hiển thị tương ứng với [path]
  static String getDisplayName(String? path) {
    if (path == null) {
      return 'Mặc định hệ thống';
    }
    for (final s in builtInSounds) {
      if (s.path == path) {
        return s.title;
      }
    }
    // File tùy chỉnh
    final fileName = p.basename(path);
    // Bỏ tiền tố timestamp nếu có
    final cleanName = fileName.replaceFirst(RegExp(r'^sound_\d+_'), '');
    return cleanName.isNotEmpty ? cleanName : 'Âm thanh tùy chỉnh';
  }
}

/// Kết quả trả về khi người dùng chọn xong âm thanh
class SoundSelection {
  final String? soundPath;
  const SoundSelection(this.soundPath);
}
