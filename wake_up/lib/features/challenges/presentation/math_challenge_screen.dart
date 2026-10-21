import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/math_challenge.dart';

/// Màn hình thử thách giải toán khi báo thức reo.
class MathChallengeScreen extends StatefulWidget {
  final MathChallenge challenge;
  final VoidCallback onCompleted;

  const MathChallengeScreen({
    super.key,
    required this.challenge,
    required this.onCompleted,
  });

  @override
  State<MathChallengeScreen> createState() => _MathChallengeScreenState();
}

class _MathChallengeScreenState extends State<MathChallengeScreen>
    with SingleTickerProviderStateMixin {
  String _input = '';
  String _displayExpression = '';
  int _displayQuestionNumber = 1;
  bool _isWrong = false;
  bool _isCorrect = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    widget.challenge.start();
    _displayExpression = widget.challenge.expression;
    _displayQuestionNumber = widget.challenge.currentQuestionIndex + 1;

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    widget.challenge.dispose();
    super.dispose();
  }

  void _onKeyPressed(String key) {
    if (_isCorrect) return;
    HapticFeedback.lightImpact();

    setState(() {
      _isWrong = false;
      if (key == 'backspace') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (key == 'clear') {
        _input = '';
      } else if (_input.length < 5) {
        _input += key;
      }
    });
  }

  Future<void> _submitAnswer() async {
    if (_input.isEmpty || _isCorrect) return;

    final answer = int.tryParse(_input);
    if (answer == null) return;

    final completed = await widget.challenge.verify(answer);

    if (completed || widget.challenge.isCompleted) {
      HapticFeedback.heavyImpact();
      setState(() {
        _isCorrect = true;
        _isWrong = false;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        widget.onCompleted();
      }
    } else if (widget.challenge.lastAnswerCorrect) {
      // Đúng câu hiện tại, còn câu tiếp theo
      HapticFeedback.mediumImpact();
      setState(() {
        _isCorrect = true;
        _isWrong = false;
      });
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        setState(() {
          _input = '';
          _isCorrect = false;
          _displayExpression = widget.challenge.expression;
          _displayQuestionNumber = widget.challenge.currentQuestionIndex + 1;
        });
      }
    } else {
      // Sai câu này
      HapticFeedback.vibrate();
      setState(() {
        _isWrong = true;
        _isCorrect = false;
        _input = '';
        _displayExpression = widget.challenge.expression;
      });
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentQ = _displayQuestionNumber;
    final totalQ = widget.challenge.questionCount;

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header: Progress
            Text(
              l10n.challengeQuestionProgress(currentQ, totalQ),
              style: const TextStyle(
                color: AppTheme.accentOrange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: totalQ > 0 ? (currentQ - 1) / totalQ : 0.0,
                    backgroundColor: AppTheme.surfaceDarkElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.accentOrange,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),

            // Expression & Animated feedback
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: Column(
                children: [
                  Text(
                    _displayExpression.isEmpty
                        ? widget.challenge.expression
                        : _displayExpression,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.labelPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User answer display box
                  Container(
                    width: 180,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isWrong
                          ? AppTheme.destructiveRed.withValues(alpha: 0.2)
                          : (_isCorrect
                              ? AppTheme.successGreen.withValues(alpha: 0.2)
                              : AppTheme.surfaceDarkElevated),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isWrong
                            ? AppTheme.destructiveRed
                            : (_isCorrect
                                ? AppTheme.successGreen
                                : AppTheme.separatorColor),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _input.isEmpty ? '?' : _input,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: _input.isEmpty
                            ? AppTheme.labelTertiary
                            : AppTheme.labelPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_isWrong)
                    Text(
                      l10n.challengeWrong,
                      style: const TextStyle(
                        color: AppTheme.destructiveRed,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (_isCorrect)
                    Text(
                      l10n.challengeCorrect,
                      style: const TextStyle(
                        color: AppTheme.successGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    const SizedBox(height: 18),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Numeric Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 12),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 12),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 12),
                  _buildKeypadRow(['clear', '0', 'backspace']),
                  const SizedBox(height: 16),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: CupertinoButton(
                      color: AppTheme.accentOrange,
                      borderRadius: BorderRadius.circular(16),
                      onPressed: _input.isEmpty ? null : _submitAnswer,
                      child: Text(
                        l10n.confirm,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return _buildKeypadButton(key);
      }).toList(),
    );
  }

  Widget _buildKeypadButton(String key) {
    Widget content;
    if (key == 'backspace') {
      content = const Icon(
        CupertinoIcons.delete_left,
        color: AppTheme.labelPrimary,
        size: 24,
      );
    } else if (key == 'clear') {
      content = const Text(
        'C',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppTheme.labelSecondary,
        ),
      );
    } else {
      content = Text(
        key,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: AppTheme.labelPrimary,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _onKeyPressed(key),
      child: Container(
        width: 82,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.surfaceDarkElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}

/// Fallback helper to draw a simple line progress bar
class LinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Animation<Color?> valueColor;

  const LinearProgressIndicator({
    super.key,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          color: backgroundColor,
          alignment: Alignment.centerLeft,
          child: Container(
            width: constraints.maxWidth * value.clamp(0.0, 1.0),
            color: valueColor.value,
          ),
        );
      },
    );
  }
}
