import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/qr_challenge.dart';

/// Màn hình quét QR giải thử thách khi báo thức reo.
class QrChallengeScreen extends StatefulWidget {
  final QrChallenge challenge;
  final VoidCallback onCompleted;

  const QrChallengeScreen({
    super.key,
    required this.challenge,
    required this.onCompleted,
  });

  @override
  State<QrChallengeScreen> createState() => _QrChallengeScreenState();
}

class _QrChallengeScreenState extends State<QrChallengeScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _isMatched = false;
  bool _isWrong = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    widget.challenge.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.challenge.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || _isMatched) return;

    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        _isProcessing = true;
        final matched = await widget.challenge.verify(rawValue);

        if (matched) {
          HapticFeedback.heavyImpact();
          setState(() {
            _isMatched = true;
            _isWrong = false;
          });
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) {
            widget.onCompleted();
          }
        } else {
          HapticFeedback.vibrate();
          setState(() {
            _isWrong = true;
          });
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) setState(() => _isWrong = false);
            _isProcessing = false;
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Full camera scanner
            Positioned.fill(
              child: MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
            ),

            // Top Instructions
            Positioned(
              top: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.separatorColor),
                ),
                child: Text(
                  l10n.challengeQrInstruction,
                  style: const TextStyle(
                    color: AppTheme.labelPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Center targeting reticle
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isMatched
                      ? AppTheme.successGreen
                      : (_isWrong ? AppTheme.destructiveRed : AppTheme.accentOrange),
                  width: 3.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),

            // Torch Button
            Positioned(
              top: 24,
              right: 24,
              child: CupertinoButton(
                padding: const EdgeInsets.all(12),
                color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(30),
                onPressed: () => _controller.toggleTorch(),
                child: const Icon(
                  CupertinoIcons.lightbulb,
                  color: AppTheme.labelPrimary,
                  size: 24,
                ),
              ),
            ),

            // Bottom Feedback Message
            Positioned(
              bottom: 48,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _isMatched
                      ? AppTheme.successGreen.withValues(alpha: 0.9)
                      : (_isWrong
                          ? AppTheme.destructiveRed.withValues(alpha: 0.9)
                          : AppTheme.surfaceDark.withValues(alpha: 0.85)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isMatched
                          ? CupertinoIcons.check_mark_circled_solid
                          : (_isWrong
                              ? CupertinoIcons.xmark_circle_fill
                              : CupertinoIcons.qrcode_viewfinder),
                      color: CupertinoColors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isMatched
                          ? l10n.challengeQrMatched
                          : (_isWrong
                              ? l10n.challengeQrNotMatched
                              : l10n.challengeQrDesc),
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
