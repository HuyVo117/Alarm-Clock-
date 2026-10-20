import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import 'providers/alarm_providers.dart';

/// Màn hình khi báo thức reo: giờ lớn, nhãn, nút Dừng và Báo lại.
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

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final timeStr = _formatTime(now);
    final periodStr = now.hour >= 12 ? 'CH' : 'SA';

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

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
                  color: AppTheme.surfaceDarkElevated,
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
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _snooze() {
    // TODO: Kích hoạt báo lại qua AlarmScheduler
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _stop() {
    // TODO: Dừng báo thức qua AlarmScheduler
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
