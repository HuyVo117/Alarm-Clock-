import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/shake_challenge.dart';

/// Màn hình thử thách lắc điện thoại khi báo thức reo.
class ShakeChallengeScreen extends StatefulWidget {
  final ShakeChallenge challenge;
  final VoidCallback onCompleted;

  const ShakeChallengeScreen({
    super.key,
    required this.challenge,
    required this.onCompleted,
  });

  @override
  State<ShakeChallengeScreen> createState() => _ShakeChallengeScreenState();
}

class _ShakeChallengeScreenState extends State<ShakeChallengeScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription? _sensorSubscription;
  StreamSubscription? _countSubscription;
  int _currentCount = 0;
  bool _isCompleted = false;

  late AnimationController _shakeAnimationController;
  late Animation<double> _shakeRotationAnimation;

  @override
  void initState() {
    super.initState();
    widget.challenge.start();

    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _shakeRotationAnimation = Tween<double>(begin: -0.15, end: 0.15).animate(
      CurvedAnimation(
        parent: _shakeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to real sensors from sensors_plus
    _sensorSubscription = accelerometerEventStream().listen(
      (event) {
        if (!mounted || _isCompleted) return;
        widget.challenge.handleAccelerometerEvent(event.x, event.y, event.z);
      },
      onError: (_) {
        // Fallback for emulator or sensor missing: can still complete
      },
    );

    // Listen to challenge count updates
    _countSubscription = widget.challenge.shakeCountStream.listen((count) {
      if (!mounted || _isCompleted) return;
      HapticFeedback.mediumImpact();
      setState(() {
        _currentCount = count;
      });

      if (widget.challenge.isCompleted) {
        _onSuccess();
      }
    });
  }

  Future<void> _onSuccess() async {
    _isCompleted = true;
    _sensorSubscription?.cancel();
    HapticFeedback.heavyImpact();
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      widget.onCompleted();
    }
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    _countSubscription?.cancel();
    _shakeAnimationController.dispose();
    widget.challenge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final target = widget.challenge.targetCount;
    final progress = target > 0 ? (_currentCount / target).clamp(0.0, 1.0) : 0.0;

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Header
            Text(
              l10n.challengeShakeInstruction,
              style: const TextStyle(
                color: AppTheme.labelPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.challengeShakeProgress(_currentCount, target),
              style: const TextStyle(
                color: AppTheme.accentOrange,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),

            // Circular progress ring with animated shaking icon
            Center(
              child: SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(240, 240),
                      painter: _CircularProgressPainter(
                        progress: progress,
                        backgroundColor: AppTheme.surfaceDarkElevated,
                        progressColor: _isCompleted
                            ? AppTheme.successGreen
                            : AppTheme.accentOrange,
                        strokeWidth: 14,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _shakeRotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _isCompleted ? 0 : _shakeRotationAnimation.value,
                              child: Icon(
                                _isCompleted
                                    ? CupertinoIcons.check_mark_circled_solid
                                    : CupertinoIcons.device_phone_portrait,
                                size: 72,
                                color: _isCompleted
                                    ? AppTheme.successGreen
                                    : AppTheme.labelPrimary,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$_currentCount / $target',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: _isCompleted
                                ? AppTheme.successGreen
                                : AppTheme.labelPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            if (_isCompleted)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  l10n.challengeCompleted,
                  style: const TextStyle(
                    color: AppTheme.successGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  l10n.challengeShakeDesc(target),
                  style: const TextStyle(
                    color: AppTheme.labelSecondary,
                    fontSize: 15,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw arc for progress (-pi/2 starts from top)
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
