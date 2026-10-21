import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../data/photo_feature_service.dart';
import '../domain/photo_challenge.dart';

/// Màn hình thử thách Chụp ảnh rời giường / trước gương tham chiếu (Photo Challenge).
/// Yêu cầu người dùng chụp lại ảnh góc phòng / giường / gương đã đăng ký.
class PhotoChallengeScreen extends StatefulWidget {
  final PhotoChallenge challenge;
  final VoidCallback onCompleted;

  const PhotoChallengeScreen({
    super.key,
    required this.challenge,
    required this.onCompleted,
  });

  @override
  State<PhotoChallengeScreen> createState() => _PhotoChallengeScreenState();
}

class _PhotoChallengeScreenState extends State<PhotoChallengeScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;

  bool _isCameraReady = false;
  bool _isProcessing = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Lối thoát khẩn cấp 10s
  Timer? _emergencyTimer;
  int _emergencyHoldSeconds = 0;
  bool _isHoldingEmergency = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.challenge.start();
    _initPhotoFeaturesAndCamera();
  }

  Future<void> _initPhotoFeaturesAndCamera() async {
    // 1. Nạp đặc trưng ảnh mẫu nếu chưa có
    if (widget.challenge.referenceFeatures == null &&
        widget.challenge.referencePhotoPath.isNotEmpty) {
      final features = await PhotoFeatureService.extractFeatures(
        widget.challenge.referencePhotoPath,
      );
      widget.challenge.referenceFeatures = features;
    }

    // 2. Mở Camera (ưu tiên camera sau)
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Không tìm thấy camera trên thiết bị.';
        });
        return;
      }

      _selectedCameraIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;

      await _startCamera(_cameras[_selectedCameraIndex]);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Không thể mở camera: $e';
      });
    }
  }

  Future<void> _startCamera(CameraDescription description) async {
    _cameraController?.dispose();
    _cameraController = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;
    HapticFeedback.selectionClick();
    setState(() {
      _isCameraReady = false;
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    });
    await _startCamera(_cameras[_selectedCameraIndex]);
  }

  Future<void> _captureAndVerify() async {
    if (_isProcessing ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized ||
        widget.challenge.isCompleted) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });
    HapticFeedback.selectionClick();

    try {
      final image = await _cameraController!.takePicture();
      final capturedFeatures = await PhotoFeatureService.extractFeatures(image.path);

      if (capturedFeatures == null) {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
        return;
      }

      final completed = await widget.challenge.verify(capturedFeatures);

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (completed) {
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) widget.onCompleted();
          });
        } else {
          HapticFeedback.vibrate();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
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
    widget.onCompleted();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emergencyTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final hasRefImage = challenge.referencePhotoPath.isNotEmpty &&
        File(challenge.referencePhotoPath).existsSync();

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Chụp ảnh rời giường',
                  style: TextStyle(
                    color: AppTheme.labelPrimary,
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
                        : 'Chụp ảnh khớp với góc mẫu để tắt báo thức',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: challenge.isCompleted
                          ? const Color(0xFF34C759)
                          : AppTheme.accentOrange,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Live Camera Viewfinder
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
                            : Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: challenge.isCompleted
                                        ? const Color(0xFF34C759)
                                        : AppTheme.surfaceDarkElevated,
                                    width: 3,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    CameraPreview(_cameraController!),

                                    // Ảnh mẫu Picture-in-Picture ở góc trên
                                    if (hasRefImage)
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: Container(
                                          width: 90,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppTheme.accentOrange,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: CupertinoColors.black.withValues(alpha: 0.5),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.file(
                                                File(challenge.referencePhotoPath),
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                alignment: Alignment.bottomCenter,
                                                color: CupertinoColors.black.withValues(alpha: 0.5),
                                                padding: const EdgeInsets.symmetric(vertical: 2),
                                                child: const Text(
                                                  'Ảnh mẫu',
                                                  style: TextStyle(
                                                    color: CupertinoColors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    // Chỉ báo đang xử lý
                                    if (_isProcessing)
                                      Container(
                                        color: CupertinoColors.black.withValues(alpha: 0.5),
                                        child: const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CupertinoActivityIndicator(radius: 16),
                                              SizedBox(height: 12),
                                              Text(
                                                'Đang đối chiếu ảnh...',
                                                style: TextStyle(color: CupertinoColors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    // Thành công
                                    if (challenge.isCompleted)
                                      Container(
                                        color: const Color(0xFF34C759).withValues(alpha: 0.4),
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

                const SizedBox(height: 16),

                // Điểm tương đồng gần nhất
                if (challenge.lastSimilarity > 0.0)
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
                              widthFactor: challenge.lastSimilarity.clamp(0.0, 1.0),
                              child: Container(
                                color: challenge.isCompleted
                                    ? const Color(0xFF34C759)
                                    : AppTheme.accentOrange,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Độ khớp: ${(challenge.lastSimilarity * 100).toInt()}% (Cần ${(challenge.similarityThreshold * 100).toInt()}%)',
                          style: const TextStyle(
                            color: AppTheme.labelSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Nút chụp ảnh kiểu iPhone Camera & nút lật camera
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 48),

                      // Nút chụp ảnh lớn
                      GestureDetector(
                        onTap: _isProcessing ? null : _captureAndVerify,
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: CupertinoColors.white,
                              width: 4,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isProcessing
                                  ? AppTheme.labelTertiary
                                  : CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),

                      // Nút lật camera trước / sau
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _toggleCamera,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.surfaceDarkElevated,
                          ),
                          child: const Icon(
                            CupertinoIcons.switch_camera,
                            color: AppTheme.labelSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),

            // Nút khẩn cấp
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
