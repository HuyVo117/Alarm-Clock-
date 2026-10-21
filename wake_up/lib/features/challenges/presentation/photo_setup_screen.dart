import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_theme.dart';

/// Màn hình đăng ký ảnh mẫu tham chiếu cho thử thách Chụp ảnh rời giường.
/// Người dùng chụp ảnh góc phòng, bồn rửa mặt, bàn học hoặc gương.
class PhotoSetupScreen extends StatefulWidget {
  final String? initialPhotoPath;

  const PhotoSetupScreen({
    super.key,
    this.initialPhotoPath,
  });

  @override
  State<PhotoSetupScreen> createState() => _PhotoSetupScreenState();
}

class _PhotoSetupScreenState extends State<PhotoSetupScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;

  bool _isCameraReady = false;
  bool _hasError = false;
  String _errorMessage = '';

  String? _previewPhotoPath;

  @override
  void initState() {
    super.initState();
    _previewPhotoPath = widget.initialPhotoPath;
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Không tìm thấy camera trên máy.';
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

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    HapticFeedback.selectionClick();
    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _previewPhotoPath = image.path;
      });
    } catch (_) {}
  }

  Future<void> _saveAndConfirm() async {
    if (_previewPhotoPath == null) return;
    HapticFeedback.heavyImpact();

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(appDir.path, 'reference_photos'));
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      final fileName = 'ref_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = p.join(photosDir.path, fileName);
      await File(_previewPhotoPath!).copy(savedPath);

      if (mounted) {
        Navigator.of(context).pop(savedPath);
      }
    } catch (e) {
      // Fallback trả về path tạm nếu lỗi copy
      if (mounted) {
        Navigator.of(context).pop(_previewPhotoPath);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundBlack,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.surfaceDark.withValues(alpha: 0.9),
        middle: const Text(
          'Đăng ký ảnh mẫu',
          style: TextStyle(color: AppTheme.labelPrimary),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Hủy', style: TextStyle(color: AppTheme.accentOrange)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Chụp một vị trí bạn bắt buộc phải rời giường đến (ví dụ: gương, bồn rửa mặt, bàn học)',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.labelSecondary, fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),

            // Khu vực Preview ảnh đã chụp hoặc Live Camera
            Expanded(
              child: Center(
                child: _previewPhotoPath != null && File(_previewPhotoPath!).existsSync()
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.accentOrange, width: 2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.file(
                          File(_previewPhotoPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : _hasError
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
                                margin: const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme.surfaceDarkElevated,
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CameraPreview(_cameraController!),
                              ),
              ),
            ),

            const SizedBox(height: 16),

            // Nút bấm bên dưới
            if (_previewPhotoPath != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        color: AppTheme.surfaceDarkElevated,
                        child: const Text(
                          'Chụp lại',
                          style: TextStyle(color: AppTheme.labelPrimary),
                        ),
                        onPressed: () {
                          setState(() {
                            _previewPhotoPath = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CupertinoButton(
                        color: AppTheme.accentOrange,
                        onPressed: _saveAndConfirm,
                        child: const Text(
                          'Dùng ảnh này',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 48),
                    // Nút chụp ảnh
                    GestureDetector(
                      onTap: _takePhoto,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: CupertinoColors.white, width: 4),
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
                    // Nút đổi camera
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
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
