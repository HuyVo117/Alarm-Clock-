import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/challenge.dart';
import '../domain/challenge_config.dart';
import '../domain/challenge_factory.dart';
import '../domain/math_challenge.dart';
import '../domain/photo_challenge.dart';
import '../domain/qr_challenge.dart';
import '../domain/selfie_challenge.dart';
import '../domain/shake_challenge.dart';
import 'math_challenge_screen.dart';
import 'photo_challenge_screen.dart';
import 'qr_challenge_screen.dart';
import 'selfie_challenge_screen.dart';
import 'shake_challenge_screen.dart';

/// Màn hình điều phối chuỗi thử thách (Flow Controller).
/// Tích hợp lối thoát khẩn cấp (Emergency Exit).
class ChallengeFlowScreen extends StatefulWidget {
  final List<ChallengeConfig> configs;
  final VoidCallback onCompleted;

  const ChallengeFlowScreen({
    super.key,
    required this.configs,
    required this.onCompleted,
  });

  @override
  State<ChallengeFlowScreen> createState() => _ChallengeFlowScreenState();
}

class _ChallengeFlowScreenState extends State<ChallengeFlowScreen> {
  late List<Challenge> _challenges;
  int _currentIndex = 0;

  // Emergency exit timer (10s hold)
  Timer? _emergencyHoldTimer;
  Timer? _autoUnlockTimer;
  int _emergencyHoldSeconds = 0;
  static const int _targetHoldSeconds = 10;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _challenges = ChallengeFactory.createAll(widget.configs);

    // Auto unlock fallback after 15 minutes to prevent lock-out
    _autoUnlockTimer = Timer(const Duration(minutes: 15), () {
      if (mounted) {
        widget.onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _emergencyHoldTimer?.cancel();
    _autoUnlockTimer?.cancel();
    for (final c in _challenges) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCurrentChallengeCompleted() {
    if (_currentIndex < _challenges.length - 1) {
      HapticFeedback.heavyImpact();
      setState(() {
        _currentIndex++;
      });
    } else {
      // Finished all challenges!
      HapticFeedback.heavyImpact();
      widget.onCompleted();
    }
  }

  void _startEmergencyHold() {
    setState(() {
      _isHolding = true;
      _emergencyHoldSeconds = 0;
    });

    _emergencyHoldTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      HapticFeedback.selectionClick();
      setState(() {
        _emergencyHoldSeconds++;
      });

      if (_emergencyHoldSeconds >= _targetHoldSeconds) {
        timer.cancel();
        _confirmEmergencyExit();
      }
    });
  }

  void _cancelEmergencyHold() {
    _emergencyHoldTimer?.cancel();
    if (mounted && _emergencyHoldSeconds < _targetHoldSeconds) {
      setState(() {
        _isHolding = false;
        _emergencyHoldSeconds = 0;
      });
    }
  }

  Future<void> _confirmEmergencyExit() async {
    HapticFeedback.heavyImpact();
    setState(() {
      _isHolding = false;
      _emergencyHoldSeconds = 0;
    });

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.challengeEmergencyConfirm),
        content: Text(l10n.challengeEmergencyWarning),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(l10n.challengeEmergencyExit),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_challenges.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCompleted();
      });
      return const CupertinoPageScaffold(
        backgroundColor: AppTheme.backgroundBlack,
        child: SizedBox.shrink(),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    final currentChallenge = _challenges[_currentIndex];

    Widget challengeWidget;
    if (currentChallenge is MathChallenge) {
      challengeWidget = MathChallengeScreen(
        key: ValueKey('math_$_currentIndex'),
        challenge: currentChallenge,
        onCompleted: _onCurrentChallengeCompleted,
      );
    } else if (currentChallenge is ShakeChallenge) {
      challengeWidget = ShakeChallengeScreen(
        key: ValueKey('shake_$_currentIndex'),
        challenge: currentChallenge,
        onCompleted: _onCurrentChallengeCompleted,
      );
    } else if (currentChallenge is QrChallenge) {
      challengeWidget = QrChallengeScreen(
        key: ValueKey('qr_$_currentIndex'),
        challenge: currentChallenge,
        onCompleted: _onCurrentChallengeCompleted,
      );
    } else if (currentChallenge is SelfieChallenge) {
      challengeWidget = SelfieChallengeScreen(
        key: ValueKey('selfie_$_currentIndex'),
        challenge: currentChallenge,
        onCompleted: _onCurrentChallengeCompleted,
      );
    } else if (currentChallenge is PhotoChallenge) {
      challengeWidget = PhotoChallengeScreen(
        key: ValueKey('photo_$_currentIndex'),
        challenge: currentChallenge,
        onCompleted: _onCurrentChallengeCompleted,
      );
    } else {
      challengeWidget = Center(
        child: Text('Unknown challenge: ${currentChallenge.type}'),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      child: Stack(
        children: [
          // Challenge content
          Column(
            children: [
              // Top overall challenge progress if multiple
              if (_challenges.length > 1) ...[
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.challengeProgress(
                          _currentIndex + 1,
                          _challenges.length,
                        ),
                        style: const TextStyle(
                          color: AppTheme.labelSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Expanded(child: challengeWidget),
            ],
          ),

          // Emergency Exit Button (Bottom Left / discreet corner)
          Positioned(
            left: 20,
            bottom: 24,
            child: GestureDetector(
              onLongPressStart: (_) => _startEmergencyHold(),
              onLongPressEnd: (_) => _cancelEmergencyHold(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHolding
                        ? AppTheme.destructiveRed
                        : AppTheme.separatorColor.withValues(alpha: 0.5),
                    width: _isHolding ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_shield,
                      size: 16,
                      color: _isHolding
                          ? AppTheme.destructiveRed
                          : AppTheme.labelTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isHolding
                          ? l10n.challengeEmergencyHold(
                              _targetHoldSeconds - _emergencyHoldSeconds,
                            )
                          : l10n.challengeEmergencyExit,
                      style: TextStyle(
                        fontSize: 12,
                        color: _isHolding
                            ? AppTheme.destructiveRed
                            : AppTheme.labelTertiary,
                        fontWeight:
                            _isHolding ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
