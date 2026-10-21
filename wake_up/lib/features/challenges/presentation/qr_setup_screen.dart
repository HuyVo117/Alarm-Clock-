import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wake_up/core/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/qr_challenge.dart';

/// Màn hình đăng ký mã QR khi cài đặt báo thức.
class QrSetupScreen extends StatefulWidget {
  final List<String> initialHashes;

  const QrSetupScreen({
    super.key,
    this.initialHashes = const [],
  });

  @override
  State<QrSetupScreen> createState() => _QrSetupScreenState();
}

class _QrSetupScreenState extends State<QrSetupScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  late List<String> _registeredHashes;
  String? _statusMessage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _registeredHashes = List<String>.from(widget.initialHashes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        _isProcessing = true;
        final hash = QrChallenge.hashQrCode(rawValue);

        if (_registeredHashes.contains(hash)) {
          HapticFeedback.lightImpact();
          setState(() {
            _statusMessage = 'Mã này đã được đăng ký!';
          });
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) setState(() => _statusMessage = null);
            _isProcessing = false;
          });
        } else {
          HapticFeedback.mediumImpact();
          setState(() {
            _registeredHashes.add(hash);
            _statusMessage = 'Đã thêm mã thành công!';
          });
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) setState(() => _statusMessage = null);
            _isProcessing = false;
          });
        }
        break;
      }
    }
  }

  void _removeHash(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _registeredHashes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundBlack.withValues(alpha: 0.8),
        middle: Text(
          l10n.challengeQrSetupTitle,
          style: const TextStyle(color: AppTheme.labelPrimary),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: AppTheme.accentOrange),
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(_registeredHashes),
          child: Text(
            l10n.done,
            style: const TextStyle(
              color: AppTheme.accentOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.backgroundBlack,
      child: SafeArea(
        child: Column(
          children: [
            // Camera scanner preview
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: _controller,
                    onDetect: _onDetect,
                  ),
                  // Target box overlay
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.accentOrange,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  // Top Torch Button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(10),
                      color: AppTheme.surfaceDark.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () => _controller.toggleTorch(),
                      child: const Icon(
                        CupertinoIcons.lightbulb,
                        color: AppTheme.labelPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                  // Status message pill
                  if (_statusMessage != null)
                    Positioned(
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.separatorColor),
                        ),
                        child: Text(
                          _statusMessage!,
                          style: const TextStyle(
                            color: AppTheme.labelPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Registered Hashes Section
            Expanded(
              flex: 4,
              child: Container(
                color: AppTheme.surfaceDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.challengeQrRegistered(_registeredHashes.length),
                            style: const TextStyle(
                              color: AppTheme.labelSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            l10n.challengeQrScanToAdd,
                            style: const TextStyle(
                              color: AppTheme.labelTertiary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _registeredHashes.isEmpty
                          ? Center(
                              child: Text(
                                l10n.challengeQrScanToAdd,
                                style: const TextStyle(
                                  color: AppTheme.labelTertiary,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _registeredHashes.length,
                              separatorBuilder: (_, index) => Container(
                                color: AppTheme.separatorColor,
                                height: 1,
                              ),
                              itemBuilder: (context, index) {
                                final hash = _registeredHashes[index];
                                final shortHash = hash.length > 12
                                    ? '${hash.substring(0, 10)}...'
                                    : hash;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.qrcode,
                                        color: AppTheme.accentOrange,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Mã #${index + 1} ($shortHash)',
                                          style: const TextStyle(
                                            color: AppTheme.labelPrimary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _removeHash(index),
                                        child: const Icon(
                                          CupertinoIcons.minus_circle_fill,
                                          color: AppTheme.destructiveRed,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
