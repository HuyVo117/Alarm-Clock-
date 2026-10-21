import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../data/face_detection_service.dart';
import '../domain/selfie_challenge.dart';

/// Màn hình thử thách Selfie trước gương (Face / Selfie Challenge).
/// Giao diện phong cách Apple iOS Camera với khung oval soi gương.
class SelfieChallengeScreen extends StatefulWidget {
  final SelfieChallenge challenge;
  final VoidCallback onCompleted;

  const SelfieChallengeScreen({
    super.key,
    required this.challenge,
    required this.onCompleted,
  });

  @override
  State<SelfieChallengeScreen> createState() => _SelfieChallengeScreenState();
}

class _SelfieChallengeScreenState extends State<SelfieChallengeScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  final FaceDetectionService _faceService = MlKitFaceDetectionService();

  bool _isCameraReady = false;
  bool _isDetecting = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _screenFlash = false; // Tăng sáng màn hình hỗ trợ phòng tối
  Timer? _detectionTimer;

  // Lối thoát khẩn cấp 10s
  Timer? _emergencyTimer;
  int _emergencyHoldSeconds = 0;
  bool _isHoldingEmergency = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.challenge.start();
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopDetection();
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Không tìm thấy camera trên thiết bị.';
        });
        return;
      }

      // Ưu tiên camera trước (Selfie)
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });

      _startAutoDetection();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Không thể mở camera: $e';
      });
    }
  }

  void _startAutoDetection() {
    _detectionTimer?.cancel();
    // Quét định kỳ mỗi 600ms
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      _processFrame();
    });
  }

  void _stopDetection() {
    _detectionTimer?.cancel();
    _detectionTimer = null;
  }

  Future<void> _processFrame() async {
    if (_isDetecting ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized ||
        widget.challenge.isCompleted) {
      return;
    }

    _isDetecting = true;
    try {
      final image = await _cameraController!.takePicture();
      final selfieInput = await _faceService.detectFaceFromFile(
        image.path,
        elapsedSeconds: 0.6,
      );

      final completed = await widget.challenge.verify(selfieInput);

      if (mounted) {
        setState(() {});
        if (completed) {
          _stopDetection();
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) widget.onCompleted();
          });
        }
      }
    } catch (_) {
      // Bỏ qua lỗi chụp khung hình tạm thời
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> _captureManual() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    HapticFeedback.selectionClick();
    await _processFrame();
  }

  void _startEmergencyHold() {
    setState(() {
      _isHoldingEmergency = true;
      _emergencyHoldSeconds = 0;
    });

    _emergencyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      HapticFeedback.selectionClick();
      setState(() {
        _emergencyHoldSeconds++;
      });

      if (_emergencyHoldSeconds >= 10) {
        timer.cancel();
        _confirmEmergencyExit();
      }
    });
  }

  void _cancelEmergencyHold() {
    _emergencyTimer?.cancel();
    if (mounted && _emergencyHoldSeconds < 10) {
      setState(() {
        _isHoldingEmergency = false;
        _emergencyHoldSeconds = 0;
      });
    }
  }

  void _confirmEmergencyExit() {
    HapticFeedback.heavyImpact();
    _stopDetection();
    widget.onCompleted();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopDetection();
    _emergencyTimer?.cancel();
    _cameraController?.dispose();
    _faceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final isDetected = challenge.isFaceDetected;
    final areEyesOpen = challenge.areEyesOpen;
    final progress = challenge.progress;

    return CupertinoPageScaffold(
      backgroundColor: _screenFlash ? CupertinoColors.white : AppTheme.backgroundBlack,
      child: SafeArea(
        child: Stack(
          children: [
            // Nội dung chính
            Column(
              children: [
                const SizedBox(height: 12),
                // Tiêu đề & Trạng thái
                Text(
                  'Selfie trước gương',
                  style: TextStyle(
                    color: _screenFlash ? CupertinoColors.black : AppTheme.labelPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    challenge.statusMessage.isNotEmpty
                        ? challenge.statusMessage
                        : 'Soi gương và mở to mắt để tắt báo thức',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDetected && areEyesOpen
                          ? const Color(0xFF34C759)
                          : AppTheme.accentOrange,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Kính ngắm Camera Oval soi gương
                Expanded(
                  child: Center(
                    child: _hasError
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.destructiveRed),
                            ),
                          )
                        : !_isCameraReady
                            ? const CupertinoActivityIndicator(radius: 16)
                            : SizedBox(
                                width: 280,
                                height: 380,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Live Camera Preview được clip hình Oval
                                    ClipOval(
                                      child: SizedBox(
                                        width: 270,
                                        height: 370,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: SizedBox(
                                            width: _cameraController!.value.previewSize?.height ?? 270,
                                            height: _cameraController!.value.previewSize?.width ?? 370,
                                            child: CameraPreview(_cameraController!),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Viền Oval phát sáng theo trạng thái
                                    Container(
                                      width: 278,
                                      height: 378,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(Radius.elliptical(139, 189)),
                                        border: Border.all(
                                          color: isDetected && areEyesOpen
                                              ? const Color(0xFF34C759)
                                              : isDetected
                                                  ? const Color(0xFFFFCC00)
                                                  : AppTheme.accentOrange.withValues(alpha: 0.8),
                                          width: 4,
                                        ),
                                      ),
                                    ),

                                    // Biểu tượng hoàn thành
                                    if (challenge.isCompleted)
                                      Container(
                                        width: 270,
                                        height: 370,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF34C759).withValues(alpha: 0.4),
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.all(Radius.elliptical(135, 185)),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            CupertinoIcons.checkmark_alt_circle_fill,
                                            color: CupertinoColors.white,
                                            size: 80,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                  ),
                ),

                const SizedBox(height: 12),

                // Thanh tiến trình giữ mặt
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 8,
                          color: AppTheme.surfaceDarkElevated,
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: progress.clamp(0.0, 1.0),
                            child: Container(
                              color: progress >= 1.0
                                  ? const Color(0xFF34C759)
                                  : AppTheme.accentOrange,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tiến trình: ${(progress * 100).toInt()}%',
                        style: TextStyle(
                          color: _screenFlash ? CupertinoColors.black : AppTheme.labelSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Điều khiển: Bật đèn sáng màn hình & Nút chụp ảnh
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Nút tăng sáng màn hình
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _screenFlash
                                ? AppTheme.accentOrange
                                : AppTheme.surfaceDarkElevated,
                          ),
                          child: Icon(
                            _screenFlash
                                ? CupertinoIcons.lightbulb_fill
                                : CupertinoIcons.lightbulb,
                            color: _screenFlash
                                ? CupertinoColors.white
                                : AppTheme.labelSecondary,
                            size: 24,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _screenFlash = !_screenFlash;
                          });
                        },
                      ),

                      // Nút chụp ảnh lớn kiểu iOS Camera
                      GestureDetector(
                        onTap: _captureManual,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: CupertinoColors.white,
                              width: 4,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),

                      // Nút làm mới
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.surfaceDarkElevated,
                          ),
                          child: const Icon(
                            CupertinoIcons.arrow_clockwise,
                            color: AppTheme.labelSecondary,
                            size: 24,
                          ),
                        ),
                        onPressed: () {
                          widget.challenge.reset();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),

            // Lối thoát khẩn cấp (Góc trên bên phải)
            Positioned(
              top: 12,
              right: 16,
              child: GestureDetector(
                onLongPressStart: (_) => _startEmergencyHold(),
                onLongPressEnd: (_) => _cancelEmergencyHold(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isHoldingEmergency
                        ? AppTheme.destructiveRed.withValues(alpha: 0.3)
                        : AppTheme.surfaceDarkElevated.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHoldingEmergency
                          ? AppTheme.destructiveRed
                          : AppTheme.labelTertiary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.exclamationmark_shield,
                        size: 14,
                        color: _isHoldingEmergency
                            ? AppTheme.destructiveRed
                            : AppTheme.labelSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isHoldingEmergency
                            ? 'Giữ ${10 - _emergencyHoldSeconds}s'
                            : 'Khẩn cấp',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isHoldingEmergency
                              ? AppTheme.destructiveRed
                              : AppTheme.labelSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
