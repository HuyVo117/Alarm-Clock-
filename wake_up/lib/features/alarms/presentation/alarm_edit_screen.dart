import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../media/data/media_service.dart';
import '../domain/alarm_model.dart';
import '../domain/next_alarm_calculator.dart';
import 'providers/alarm_providers.dart';
import 'widgets/day_picker.dart';

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
  int _snoozeInterval = 5;
  int _snoozeMaxCount = 3;
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
          _snoozeInterval = alarm.snoozeIntervalMinutes;
          _snoozeMaxCount = alarm.snoozeMaxCount;
        });
      }
    }
    setState(() => _isLoading = false);
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
            // Time picker
            SizedBox(
              height: 216,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: _selectedTime,
                use24hFormat: false,
                onDateTimeChanged: (dateTime) {
                  setState(() => _selectedTime = dateTime);
                },
              ),
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
                CupertinoListTile(
                  backgroundColor: AppTheme.surfaceDark,
                  title: Text(
                    l10n.wakeMode,
                    style: const TextStyle(color: AppTheme.labelPrimary),
                  ),
                  additionalInfo: Text(
                    _mode == WakeMode.normal
                        ? l10n.wakeModeNormal
                        : l10n.wakeModeDeep,
                    style: const TextStyle(color: AppTheme.labelSecondary),
                  ),
                  // GĐ 1: chỉ hỗ trợ "Thường", không cho bấm
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

  Future<void> _pickVideo() async {
    final mediaService = MediaService();
    final savedPath = await mediaService.pickAndSaveVideo();
    if (savedPath != null && mounted) {
      setState(() {
        _mediaPath = savedPath;
      });
    }
  }

  Future<void> _saveAlarm() async {
    final repo = ref.read(alarmRepositoryProvider);

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
      snoozeIntervalMinutes: _snoozeInterval,
      snoozeMaxCount: _snoozeMaxCount,
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
      await scheduler.scheduleAlarm(
        alarmId: alarmId,
        scheduledTime: nextTime,
        label: _label,
      );
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
