import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_theme.dart';
import '../data/media_service.dart';
import '../domain/alarm_sound.dart';

/// Màn hình chọn âm thanh báo thức chuẩn giao diện iOS.
/// Cho phép chọn âm thanh có sẵn, nghe thử trực tiếp và chọn file nhạc từ máy.
class SoundPickerScreen extends StatefulWidget {
  final String? initialSoundPath;

  const SoundPickerScreen({
    super.key,
    this.initialSoundPath,
  });

  @override
  State<SoundPickerScreen> createState() => _SoundPickerScreenState();
}

class _SoundPickerScreenState extends State<SoundPickerScreen> {
  late String? _selectedPath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final MediaService _mediaService = MediaService();
  String? _customSoundPath;

  @override
  void initState() {
    super.initState();
    _selectedPath = widget.initialSoundPath;

    // Nếu path ban đầu là file ngoài máy (không thuộc built-in)
    if (_selectedPath != null &&
        !AlarmSound.builtInSounds.any((s) => s.path == _selectedPath)) {
      _customSoundPath = _selectedPath;
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPreview(String? path) async {
    try {
      await _audioPlayer.stop();

      if (path == null) {
        // Mặc định hệ thống: phát thử alarm.mp3 mẫu
        await _audioPlayer.setAsset('assets/audio/alarm.mp3');
      } else if (path.startsWith('assets/')) {
        await _audioPlayer.setAsset(path);
      } else {
        final file = File(path);
        if (await file.exists()) {
          await _audioPlayer.setFilePath(path);
        } else {
          return;
        }
      }

      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('[SoundPickerScreen] Lỗi phát preview: $e');
    }
  }

  Future<void> _selectSound(String? path) async {
    setState(() {
      _selectedPath = path;
    });
    await _playPreview(path);
  }

  Future<void> _pickFromDevice() async {
    final path = await _mediaService.pickAndSaveAudio();
    if (path != null && mounted) {
      setState(() {
        _customSoundPath = path;
        _selectedPath = path;
      });
      await _playPreview(path);
    }
  }

  void _onDone() {
    _audioPlayer.stop();
    Navigator.of(context).pop(SoundSelection(_selectedPath));
  }

  void _onCancel() {
    _audioPlayer.stop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.surfaceDark.withValues(alpha: 0.9),
        middle: const Text(
          'Âm thanh',
          style: TextStyle(color: AppTheme.labelPrimary),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _onCancel,
          child: const Text(
            'Hủy',
            style: TextStyle(color: AppTheme.accentOrange),
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _onDone,
          child: const Text(
            'Lưu',
            style: TextStyle(
              color: AppTheme.accentOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 12),

            // Mục chọn file từ máy
            CupertinoListSection.insetGrouped(
              backgroundColor: AppTheme.backgroundBlack,
              header: const Text(
                'NHẠC CHUÔNG TÙY CHỈNH',
                style: TextStyle(
                  color: AppTheme.labelSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: [
                CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  leading: const Icon(
                    CupertinoIcons.music_note_list,
                    color: AppTheme.accentOrange,
                  ),
                  title: const Text(
                    'Chọn file âm thanh từ máy...',
                    style: TextStyle(color: AppTheme.labelPrimary),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _pickFromDevice,
                ),
                if (_customSoundPath != null)
                  CupertinoListTile(
                    backgroundColor: AppTheme.surfaceDark,
                    title: Text(
                      AlarmSound.getDisplayName(_customSoundPath),
                      style: const TextStyle(color: AppTheme.labelPrimary),
                    ),
                    trailing: _selectedPath == _customSoundPath
                        ? const Icon(
                            CupertinoIcons.checkmark,
                            color: AppTheme.accentOrange,
                            size: 20,
                          )
                        : null,
                    onTap: () => _selectSound(_customSoundPath),
                  ),
              ],
            ),

            // Danh sách nhạc chuông có sẵn
            CupertinoListSection.insetGrouped(
              backgroundColor: AppTheme.backgroundBlack,
              header: const Text(
                'NHẠC CHUÔNG CÓ SẴN',
                style: TextStyle(
                  color: AppTheme.labelSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: AlarmSound.builtInSounds.map((sound) {
                final isSelected = _selectedPath == sound.path;
                return CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  title: Text(
                    sound.title,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.accentOrange
                          : AppTheme.labelPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          CupertinoIcons.checkmark,
                          color: AppTheme.accentOrange,
                          size: 20,
                        )
                      : null,
                  onTap: () => _selectSound(sound.path),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
