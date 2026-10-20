import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/alarm_model.dart';
import '../domain/next_alarm_calculator.dart';
import 'providers/alarm_providers.dart';

/// Màn hình khi báo thức reo: giờ lớn, nhãn, nút Dừng và Báo lại.
/// Hỗ trợ phát video nền tùy chỉnh (Giai đoạn 2).
class AlarmRingingScreen extends ConsumerStatefulWidget {
  final int alarmId;

  const AlarmRingingScreen({super.key, required this.alarmId});

  @override
  ConsumerState<AlarmRingingScreen> createState() =>
      _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends ConsumerState<AlarmRingingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  VideoPlayerController? _videoController;
  AlarmModel? _alarm;
  static const _deviceChannel = MethodChannel('com.wakeup.app.wake_up/device');

  @override
  void initState() {
    super.initState();
    _deviceChannel.invokeMethod('turnScreenOnAndShowWhenLocked').catchError((_) {});

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadAlarmAndVideo();
  }

  Future<void> _loadAlarmAndVideo() async {
    final repo = ref.read(alarmRepositoryProvider);
    final alarm = await repo.getAlarmById(widget.alarmId);
    if (alarm != null) {
      _alarm = alarm;
      if (alarm.mediaPath != null) {
        final videoFile = File(alarm.mediaPath!);
        if (await videoFile.exists()) {
          final controller = VideoPlayerController.file(videoFile);
          try {
            await controller.initialize();
            await controller.setLooping(true);
            await controller.play();
            if (mounted) {
              setState(() {
                _videoController = controller;
              });
            }
          } catch (_) {
            // Nếu lỗi phát video, tiếp tục dùng nền mặc định
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _deviceChannel.invokeMethod('resetScreenFlags').catchError((_) {});
    _pulseController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final timeStr = _formatTime(now);
    final periodStr = now.hour >= 12 ? 'CH' : 'SA';
    final label = _alarm?.label.isNotEmpty == true ? _alarm!.label : l10n.alarmListTitle;

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      child: Stack(
        children: [
          // Lớp 1: Video nền (nếu có)
          if (_videoController != null && _videoController!.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),

          // Lớp 2: Lớp phủ mờ tối giúp chữ hiển thị sắc nét trên video
          if (_videoController != null && _videoController!.value.isInitialized)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.backgroundBlack.withValues(alpha: 0.5),
                    AppTheme.backgroundBlack.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),

          // Lớp 3: Nội dung đồng hồ, nhãn và nút bấm
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Nhãn báo thức
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.labelSecondary,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Giờ lớn với animation nhấp nháy nhẹ
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(timeStr, style: AppTheme.timeDisplayLarge),
                          const SizedBox(width: 8),
                          Text(
                            periodStr,
                            style: AppTheme.timeDisplayMedium.copyWith(
                              fontSize: 34,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Icon chuông rung
                      const Icon(
                        CupertinoIcons.bell_fill,
                        color: AppTheme.accentOrange,
                        size: 32,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // Nút Báo lại
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: AppTheme.surfaceDarkElevated.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(14),
                      onPressed: _snooze,
                      child: Text(
                        l10n.snoozeButton,
                        style: const TextStyle(
                          color: AppTheme.labelPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Nút Dừng
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: AppTheme.accentOrange,
                      borderRadius: BorderRadius.circular(14),
                      onPressed: _stop,
                      child: Text(
                        l10n.stop,
                        style: const TextStyle(
                          color: AppTheme.backgroundBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _snooze() async {
    final scheduler = ref.read(alarmSchedulerProvider);
    await scheduler.cancelAlarm(widget.alarmId);

    final interval = _alarm?.snoozeIntervalMinutes ?? 5;
    final snoozeTime = DateTime.now().add(Duration(minutes: interval));

    await scheduler.scheduleAlarm(
      alarmId: widget.alarmId,
      scheduledTime: snoozeTime,
      label: _alarm?.label ?? 'Báo lại',
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _stop() async {
    final scheduler = ref.read(alarmSchedulerProvider);
    final repo = ref.read(alarmRepositoryProvider);

    await scheduler.cancelAlarm(widget.alarmId);

    if (_alarm != null) {
      if (_alarm!.isRepeating) {
        // Tự động lên lịch lần kêu tiếp theo
        final next = NextAlarmCalculator.nextAlarm(
          alarmTime: _alarm!.time,
          repeatDays: _alarm!.repeatDays,
          now: DateTime.now(),
        );
        if (next != null) {
          await scheduler.scheduleAlarm(
            alarmId: _alarm!.id!,
            scheduledTime: next,
            label: _alarm!.label,
          );
        }
      } else {
        // Báo thức một lần -> tự động tắt
        await repo.toggleAlarm(widget.alarmId, false);
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
