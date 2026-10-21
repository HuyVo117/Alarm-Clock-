import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../challenges/domain/challenge_config.dart';
import '../../challenges/presentation/photo_setup_screen.dart';
import '../../media/data/media_service.dart';
import '../../media/domain/alarm_sound.dart';
import '../../media/presentation/sound_picker_screen.dart';
import '../domain/alarm_model.dart';
import '../domain/next_alarm_calculator.dart';
import 'providers/alarm_providers.dart';
import 'widgets/day_picker.dart';
import 'widgets/samsung_time_picker.dart';

/// Màn hình thêm/sửa báo thức, giống iPhone.
class AlarmEditScreen extends ConsumerStatefulWidget {
  final int? alarmId;

  const AlarmEditScreen({super.key, this.alarmId});

  @override
  ConsumerState<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends ConsumerState<AlarmEditScreen> {
  late DateTime _selectedTime;
  List<int> _repeatDays = [];
  String _label = '';
  WakeMode _mode = WakeMode.normal;
  String? _mediaPath;
  String? _soundPath;
  int _snoozeInterval = 5;
  int _snoozeMaxCount = 3;
  List<ChallengeConfig> _challenges = [];
  bool _isLoading = true;
  AlarmModel? _existingAlarm;

  bool get _isEditing => widget.alarmId != null;

  @override
  void initState() {
    super.initState();
    _selectedTime = DateTime.now().add(const Duration(minutes: 1));
    _loadAlarm();
  }

  Future<void> _loadAlarm() async {
    if (_isEditing) {
      final repo = ref.read(alarmRepositoryProvider);
      final alarm = await repo.getAlarmById(widget.alarmId!);
      if (alarm != null) {
        setState(() {
          _existingAlarm = alarm;
          _selectedTime = alarm.time;
          _repeatDays = List.from(alarm.repeatDays);
          _label = alarm.label;
          _mode = alarm.mode;
          _mediaPath = alarm.mediaPath;
          _soundPath = alarm.soundPath;
          _snoozeInterval = alarm.snoozeIntervalMinutes;
          _snoozeMaxCount = alarm.snoozeMaxCount;
          _challenges = List.from(alarm.challenges);
        });
      }
    }
    setState(() => _isLoading = false);
  }

  bool _hasChallenge(String type) => _challenges.any((c) => c.type == type);

  ChallengeConfig? _getChallenge(String type) {
    final idx = _challenges.indexWhere((c) => c.type == type);
    return idx != -1 ? _challenges[idx] : null;
  }

  void _toggleChallenge(String type, bool enable) {
    setState(() {
      if (enable) {
        if (!_hasChallenge(type)) {
          _challenges.add(ChallengeConfig.defaultFor(type));
        }
      } else {
        _challenges.removeWhere((c) => c.type == type);
      }
    });
  }

  void _updateChallengeParams(String type, Map<String, dynamic> params) {
    setState(() {
      final idx = _challenges.indexWhere((c) => c.type == type);
      if (idx != -1) {
        final old = _challenges[idx];
        _challenges[idx] = old.copyWith(params: {...old.params, ...params});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: AppTheme.accentOrange),
          ),
        ),
        middle: Text(_isEditing ? l10n.editAlarm : l10n.addAlarm),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saveAlarm,
          child: Text(
            l10n.save,
            style: const TextStyle(
              color: AppTheme.accentOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Samsung-style Time picker
            SamsungTimePicker(
              initialDateTime: _selectedTime,
              onDateTimeChanged: (dateTime) {
                setState(() => _selectedTime = dateTime);
              },
            ),

            const SizedBox(height: 16),

            // Lặp lại
            CupertinoListSection.insetGrouped(
              backgroundColor: AppTheme.backgroundBlack,
              children: [
                CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  title: Text(
                    l10n.repeat,
                    style: const TextStyle(color: AppTheme.labelPrimary),
                  ),
                  additionalInfo: Text(
                    _formatRepeatSummary(_repeatDays, l10n),
                    style: const TextStyle(color: AppTheme.labelSecondary),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _showRepeatPicker(context),
                ),

                // Nhãn
                CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  title: Text(
                    l10n.label,
                    style: const TextStyle(color: AppTheme.labelPrimary),
                  ),
                  additionalInfo: SizedBox(
                    width: 150,
                    child: CupertinoTextField(
                      controller: TextEditingController(text: _label),
                      placeholder: l10n.label,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: AppTheme.labelPrimary),
                      placeholderStyle:
                          const TextStyle(color: AppTheme.labelTertiary),
                      decoration: null,
                      onChanged: (value) => _label = value,
                    ),
                  ),
                ),

                // Âm thanh
                CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  title: Text(
                    l10n.sound,
                    style: const TextStyle(color: AppTheme.labelPrimary),
                  ),
                  additionalInfo: Text(
                    AlarmSound.getDisplayName(_soundPath),
                    style: const TextStyle(color: AppTheme.labelSecondary),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _openSoundPicker(context),
                ),

                // Báo lại
                CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  title: Text(
                    l10n.snooze,
                    style: const TextStyle(color: AppTheme.labelPrimary),
                  ),
                  additionalInfo: Text(
                    '${l10n.snoozeMinutes(_snoozeInterval)}, '
                    '${l10n.snoozeMaxTimes(_snoozeMaxCount)}',
                    style: const TextStyle(color: AppTheme.labelSecondary),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _showSnoozePicker(context, l10n),
                ),

                // Chế độ đánh thức
                Container(
                  color: AppTheme.surfaceDark,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        l10n.wakeMode,
                        style: const TextStyle(
                          color: AppTheme.labelPrimary,
                          fontSize: 17,
                        ),
                      ),
                      const Spacer(),
                      CupertinoSlidingSegmentedControl<WakeMode>(
                        groupValue: _mode,
                        backgroundColor: AppTheme.surfaceDarkElevated,
                        thumbColor: AppTheme.accentOrange,
                        children: {
                          WakeMode.normal: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text(
                              l10n.wakeModeNormal,
                              style: TextStyle(
                                color: _mode == WakeMode.normal
                                    ? CupertinoColors.white
                                    : AppTheme.labelSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          WakeMode.deep: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text(
                              l10n.wakeModeDeep,
                              style: TextStyle(
                                color: _mode == WakeMode.deep
                                    ? CupertinoColors.white
                                    : AppTheme.labelSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _mode = val;
                              if (_mode == WakeMode.deep && _challenges.isEmpty) {
                                _challenges.add(ChallengeConfig.defaultFor('math'));
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Thử thách cho chế độ sâu
            if (_mode == WakeMode.deep)
              CupertinoListSection.insetGrouped(
                backgroundColor: AppTheme.backgroundBlack,
                header: Text(
                  '${l10n.challengeTitle} (${l10n.wakeModeDeep})',
                  style: const TextStyle(color: AppTheme.labelSecondary),
                ),
                children: [
                  // 1. Math Challenge
                  CupertinoListTile(
                    backgroundColor: AppTheme.surfaceDark,
                    leading: const Icon(
                      CupertinoIcons.function,
                      color: AppTheme.accentOrange,
                    ),
                    title: Text(
                      l10n.challengeMath,
                      style: const TextStyle(color: AppTheme.labelPrimary),
                    ),
                    trailing: CupertinoSwitch(
                      activeTrackColor: AppTheme.accentOrange,
                      value: _hasChallenge('math'),
                      onChanged: (val) => _toggleChallenge('math', val),
                    ),
                  ),
                  if (_hasChallenge('math'))
                    CupertinoListTile(
                      backgroundColor: AppTheme.surfaceDarkElevated,
                      title: const Text(
                        'Độ khó',
                        style: TextStyle(color: AppTheme.labelPrimary, fontSize: 15),
                      ),
                      additionalInfo: Text(
                        _getMathDifficultyLabel(
                          (_getChallenge('math')?.params['difficulty'] as num?)?.toInt() ?? 1,
                          l10n,
                        ),
                        style: const TextStyle(color: AppTheme.accentOrange),
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _showMathDifficultyPicker(context, l10n),
                    ),

                  // 2. Shake Challenge
                  CupertinoListTile(
                    backgroundColor: AppTheme.surfaceDark,
                    leading: const Icon(
                      CupertinoIcons.device_phone_portrait,
                      color: AppTheme.accentOrange,
                    ),
                    title: Text(
                      l10n.challengeShake,
                      style: const TextStyle(color: AppTheme.labelPrimary),
                    ),
                    trailing: CupertinoSwitch(
                      activeTrackColor: AppTheme.accentOrange,
                      value: _hasChallenge('shake'),
                      onChanged: (val) => _toggleChallenge('shake', val),
                    ),
                  ),
                  if (_hasChallenge('shake'))
                    CupertinoListTile(
                      backgroundColor: AppTheme.surfaceDarkElevated,
                      title: Text(
                        l10n.shakeTargetCount,
                        style: const TextStyle(color: AppTheme.labelPrimary, fontSize: 15),
                      ),
                      additionalInfo: Text(
                        '${_getChallenge('shake')?.params['targetCount'] ?? 30} lần',
                        style: const TextStyle(color: AppTheme.accentOrange),
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _showShakeCountPicker(context, l10n),
                    ),

                  // 3. Selfie Challenge (Selfie trước gương)
                  CupertinoListTile(
                    backgroundColor: AppTheme.surfaceDark,
                    leading: const Icon(
                      CupertinoIcons.person_crop_circle_badge_checkmark,
                      color: AppTheme.accentOrange,
                    ),
                    title: Text(
                      l10n.challengeSelfie,
                      style: const TextStyle(color: AppTheme.labelPrimary),
                    ),
                    trailing: CupertinoSwitch(
                      activeTrackColor: AppTheme.accentOrange,
                      value: _hasChallenge('selfie'),
                      onChanged: (val) => _toggleChallenge('selfie', val),
                    ),
                  ),
                  if (_hasChallenge('selfie')) ...[
                    CupertinoListTile(
                      backgroundColor: AppTheme.surfaceDarkElevated,
                      title: const Text(
                        'Thời gian giữ',
                        style: TextStyle(color: AppTheme.labelPrimary, fontSize: 15),
                      ),
                      additionalInfo: Text(
                        '${_getChallenge('selfie')?.params['holdDurationSeconds'] ?? 2} giây',
                        style: const TextStyle(color: AppTheme.accentOrange),
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _showSelfieDurationPicker(context),
                    ),
                    CupertinoListTile(
                      backgroundColor: AppTheme.surfaceDarkElevated,
                      title: const Text(
                        'Bắt buộc mở mắt',
                        style: TextStyle(color: AppTheme.labelPrimary, fontSize: 15),
                      ),
                      trailing: CupertinoSwitch(
                        activeTrackColor: AppTheme.accentOrange,
                        value: _getChallenge('selfie')?.params['requireEyesOpen'] as bool? ?? true,
                        onChanged: (val) {
                          _updateChallengeParams('selfie', {'requireEyesOpen': val});
                        },
                      ),
                    ),
                  ],

                  // 4. Photo Challenge (Chụp ảnh rời giường / trước gương)
                  CupertinoListTile(
                    backgroundColor: AppTheme.surfaceDark,
                    leading: const Icon(
                      CupertinoIcons.photo_camera,
                      color: AppTheme.accentOrange,
                    ),
                    title: Text(
                      l10n.challengePhoto,
                      style: const TextStyle(color: AppTheme.labelPrimary),
                    ),
                    trailing: CupertinoSwitch(
                      activeTrackColor: AppTheme.accentOrange,
                      value: _hasChallenge('photo'),
                      onChanged: (val) => _toggleChallenge('photo', val),
                    ),
                  ),
                  if (_hasChallenge('photo'))
                    Builder(
                      builder: (context) {
                        final photoPath =
                            _getChallenge('photo')?.params['referencePhotoPath'] as String? ?? '';
                        final hasPhoto = photoPath.isNotEmpty;
                        return CupertinoListTile(
                          backgroundColor: AppTheme.surfaceDarkElevated,
                          title: Text(
                            l10n.challengePhotoSetupTitle,
                            style: const TextStyle(color: AppTheme.labelPrimary, fontSize: 15),
                          ),
                          additionalInfo: Text(
                            hasPhoto ? l10n.challengePhotoRegistered : l10n.challengePhotoNotRegistered,
                            style: TextStyle(
                              color: hasPhoto ? AppTheme.accentOrange : AppTheme.destructiveRed,
                            ),
                          ),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () async {
                            final result = await Navigator.of(context).push<String>(
                              CupertinoPageRoute(
                                builder: (_) => PhotoSetupScreen(initialPhotoPath: photoPath),
                              ),
                            );
                            if (result != null) {
                              _updateChallengeParams('photo', {'referencePhotoPath': result});
                            }
                          },
                        );
                      },
                    ),
                ],
              ),

            // Video nền báo thức (Giai đoạn 2)
            CupertinoListSection.insetGrouped(
              backgroundColor: AppTheme.backgroundBlack,
              children: [
                CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  leading: const Icon(
                    CupertinoIcons.video_camera_solid,
                    color: AppTheme.accentOrange,
                  ),
                  title: const Text(
                    'Video nền báo thức',
                    style: TextStyle(color: AppTheme.labelPrimary),
                  ),
                  additionalInfo: Text(
                    _mediaPath != null ? 'Đã chọn video' : 'Mặc định (đen)',
                    style: const TextStyle(color: AppTheme.labelSecondary),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _pickVideo,
                ),
                if (_mediaPath != null)
                  CupertinoListTile(
                    backgroundColor: AppTheme.surfaceDark,
                    title: const Text(
                      'Xóa video, dùng nền đen',
                      style: TextStyle(color: AppTheme.destructiveRed),
                    ),
                    onTap: () {
                      setState(() => _mediaPath = null);
                    },
                  ),
              ],
            ),

            // Nút xóa (chỉ khi đang sửa)
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoButton(
                  color: AppTheme.destructiveRed,
                  onPressed: _deleteAlarm,
                  child: Text(l10n.deleteAlarm),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatRepeatSummary(List<int> days, AppLocalizations l10n) {
    if (days.isEmpty) return l10n.never;
    if (days.length == 7) return l10n.everyDay;

    final weekdays = [1, 2, 3, 4, 5];
    final weekends = [6, 7];

    if (days.length == 5 && days.every((d) => weekdays.contains(d))) {
      return l10n.weekdays;
    }
    if (days.length == 2 && days.every((d) => weekends.contains(d))) {
      return l10n.weekends;
    }

    final dayNames = {
      1: l10n.mondayShort,
      2: l10n.tuesdayShort,
      3: l10n.wednesdayShort,
      4: l10n.thursdayShort,
      5: l10n.fridayShort,
      6: l10n.saturdayShort,
      7: l10n.sundayShort,
    };

    final sorted = List<int>.from(days)..sort();
    return sorted.map((d) => dayNames[d] ?? '').join(' ');
  }

  void _showRepeatPicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        var tempDays = List<int>.from(_repeatDays);
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              color: AppTheme.surfaceDark,
              height: 400,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() => _repeatDays = tempDays);
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Xong',
                            style: TextStyle(color: AppTheme.accentOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: DayPicker(
                      selectedDays: tempDays,
                      onChanged: (days) {
                        setModalState(() => tempDays = days);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSnoozePicker(BuildContext context, AppLocalizations l10n) {
    var tempInterval = _snoozeInterval;
    var tempMaxCount = _snoozeMaxCount;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              color: AppTheme.surfaceDark,
              height: 300,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _snoozeInterval = tempInterval;
                              _snoozeMaxCount = tempMaxCount;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Xong',
                            style: TextStyle(color: AppTheme.accentOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Interval picker
                  CupertinoListSection.insetGrouped(
                    backgroundColor: AppTheme.surfaceDark,
                    children: [
                      CupertinoListTile(
                        backgroundColor: AppTheme.surfaceDarkElevated,
                        title: Text(
                          l10n.snooze,
                          style: const TextStyle(
                            color: AppTheme.labelPrimary,
                          ),
                        ),
                        trailing: CupertinoSlidingSegmentedControl<int>(
                          groupValue: tempInterval,
                          children: const {
                            1: Text('1p'),
                            5: Text('5p'),
                            9: Text('9p'),
                            15: Text('15p'),
                          },
                          onValueChanged: (value) {
                            if (value != null) {
                              setModalState(() => tempInterval = value);
                            }
                          },
                        ),
                      ),
                      CupertinoListTile(
                        backgroundColor: AppTheme.surfaceDarkElevated,
                        title: const Text(
                          'Số lần tối đa',
                          style: TextStyle(
                            color: AppTheme.labelPrimary,
                          ),
                        ),
                        trailing: CupertinoSlidingSegmentedControl<int>(
                          groupValue: tempMaxCount,
                          children: const {
                            1: Text('1'),
                            3: Text('3'),
                            5: Text('5'),
                            10: Text('10'),
                          },
                          onValueChanged: (value) {
                            if (value != null) {
                              setModalState(() => tempMaxCount = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openSoundPicker(BuildContext context) async {
    final result = await Navigator.of(context).push<SoundSelection>(
      CupertinoPageRoute(
        builder: (_) => SoundPickerScreen(initialSoundPath: _soundPath),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _soundPath = result.soundPath;
      });
    }
  }

  Future<void> _pickVideo() async {
    final mediaService = MediaService();
    final savedPath = await mediaService.pickAndSaveVideo();
    if (savedPath != null && mounted) {
      setState(() {
        _mediaPath = savedPath;
      });
    }
  }

  String _getMathDifficultyLabel(int diff, AppLocalizations l10n) {
    switch (diff) {
      case 1:
        return l10n.challengeDifficultyEasy;
      case 2:
        return l10n.challengeDifficultyMedium;
      case 3:
        return l10n.challengeDifficultyHard;
      default:
        return l10n.challengeDifficultyEasy;
    }
  }

  void _showMathDifficultyPicker(BuildContext context, AppLocalizations l10n) {
    final currentDiff =
        (_getChallenge('math')?.params['difficulty'] as num?)?.toInt() ?? 1;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Chọn độ khó'),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              l10n.challengeDifficultyEasy,
              style: TextStyle(
                color: currentDiff == 1
                    ? AppTheme.accentOrange
                    : AppTheme.labelPrimary,
                fontWeight:
                    currentDiff == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onPressed: () {
              _updateChallengeParams('math', {'difficulty': 1});
              Navigator.pop(ctx);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              l10n.challengeDifficultyMedium,
              style: TextStyle(
                color: currentDiff == 2
                    ? AppTheme.accentOrange
                    : AppTheme.labelPrimary,
                fontWeight:
                    currentDiff == 2 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onPressed: () {
              _updateChallengeParams('math', {'difficulty': 2});
              Navigator.pop(ctx);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              l10n.challengeDifficultyHard,
              style: TextStyle(
                color: currentDiff == 3
                    ? AppTheme.accentOrange
                    : AppTheme.labelPrimary,
                fontWeight:
                    currentDiff == 3 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onPressed: () {
              _updateChallengeParams('math', {'difficulty': 3});
              Navigator.pop(ctx);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
    );
  }

  void _showShakeCountPicker(BuildContext context, AppLocalizations l10n) {
    final currentCount =
        (_getChallenge('shake')?.params['targetCount'] as num?)?.toInt() ?? 30;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.shakeTargetCount),
        actions: [15, 30, 50, 100].map((count) {
          return CupertinoActionSheetAction(
            child: Text(
              '$count lần',
              style: TextStyle(
                color: currentCount == count
                    ? AppTheme.accentOrange
                    : AppTheme.labelPrimary,
                fontWeight:
                    currentCount == count ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onPressed: () {
              _updateChallengeParams('shake', {'targetCount': count});
              Navigator.pop(ctx);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
    );
  }

  void _showSelfieDurationPicker(BuildContext context) {
    final currentSec =
        (_getChallenge('selfie')?.params['holdDurationSeconds'] as num?)?.toInt() ?? 2;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Thời gian giữ mặt'),
        actions: [1, 2, 3, 5].map((sec) {
          return CupertinoActionSheetAction(
            child: Text(
              '$sec giây',
              style: TextStyle(
                color: currentSec == sec
                    ? AppTheme.accentOrange
                    : AppTheme.labelPrimary,
                fontWeight:
                    currentSec == sec ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onPressed: () {
              _updateChallengeParams('selfie', {'holdDurationSeconds': sec});
              Navigator.pop(ctx);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text('Hủy'),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
    );
  }

  Future<void> _saveAlarm() async {
    final repo = ref.read(alarmRepositoryProvider);
    final l10n = AppLocalizations.of(context)!;

    if (_mode == WakeMode.deep) {
      if (_challenges.isEmpty) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(l10n.challengeTitle),
            content: Text(l10n.challengeSelectAtLeastOne),
            actions: [
              CupertinoDialogAction(
                child: Text(l10n.confirm),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
        return;
      }

      final photoChallenge = _getChallenge('photo');
      if (photoChallenge != null) {
        final photoPath = photoChallenge.params['referencePhotoPath'] as String? ?? '';
        if (photoPath.isEmpty) {
          showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text(l10n.challengePhoto),
              content: const Text('Vui lòng chụp ảnh mẫu tham chiếu cho thử thách Chụp ảnh rời giường.'),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.confirm),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
          return;
        }
      }

      final qrChallenge = _getChallenge('qr');
      if (qrChallenge != null) {
        final hashes = (qrChallenge.params['qrHashes'] as List<dynamic>?)
                ?.cast<String>() ??
            [];
        if (hashes.isEmpty) {
          showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text(l10n.challengeQr),
              content: const Text('Vui lòng quét và đăng ký ít nhất 1 mã QR.'),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.confirm),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
          return;
        }
      }
    }

    // Tạo DateTime cho báo thức: dùng ngày hôm nay + giờ đã chọn
    final now = DateTime.now();
    var alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Nếu giờ đã qua hôm nay và không lặp, đặt sang ngày mai
    if (_repeatDays.isEmpty && alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final alarm = AlarmModel(
      id: _existingAlarm?.id,
      time: alarmTime,
      repeatDays: _repeatDays,
      label: _label,
      mode: _mode,
      mediaPath: _mediaPath,
      soundPath: _soundPath,
      snoozeIntervalMinutes: _snoozeInterval,
      snoozeMaxCount: _snoozeMaxCount,
      challenges: _mode == WakeMode.deep ? _challenges : const [],
      enabled: true,
    );

    int alarmId;
    if (_isEditing) {
      await repo.updateAlarm(alarm);
      alarmId = _existingAlarm!.id!;
    } else {
      alarmId = await repo.insertAlarm(alarm);
    }

    // Lên lịch báo thức thật qua AlarmScheduler
    final scheduler = ref.read(alarmSchedulerProvider);
    final nextTime = NextAlarmCalculator.nextAlarm(
      alarmTime: alarmTime,
      repeatDays: _repeatDays,
      now: DateTime.now(),
    );
    if (nextTime != null) {
      try {
        await scheduler.scheduleAlarm(
          alarmId: alarmId,
          scheduledTime: nextTime,
          label: _label,
          soundPath: _soundPath,
        );
      } catch (e) {
        debugPrint('[AlarmEditScreen] Lỗi khi scheduleAlarm: $e');
      }
    }

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _deleteAlarm() async {
    final repo = ref.read(alarmRepositoryProvider);
    final scheduler = ref.read(alarmSchedulerProvider);

    await scheduler.cancelAlarm(widget.alarmId!);
    await repo.deleteAlarm(widget.alarmId!);

    if (mounted) {
      context.pop();
    }
  }
}
