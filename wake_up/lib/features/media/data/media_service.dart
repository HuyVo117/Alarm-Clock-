import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Dịch vụ chọn và quản lý file media (video, âm thanh) tùy chỉnh.
class MediaService {
  final ImagePicker _picker;

  MediaService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Thư mục lưu media tùy chỉnh trong internal storage của app
  Future<Directory> get _customMediaDir async {
    final docsDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(docsDir.path, 'custom_media'));
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  /// Mở thư viện chọn video và sao chép vào thư mục nội bộ an toàn của app.
  /// Trả về đường dẫn file đã sao chép, hoặc null nếu người dùng hủy chọn.
  Future<String?> pickAndSaveVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    final targetDir = await _customMediaDir;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${timestamp}_${p.basename(pickedFile.path)}';
    final targetPath = p.join(targetDir.path, fileName);

    await File(pickedFile.path).copy(targetPath);
    return targetPath;
  }

  /// Xóa file media đã lưu (nếu có)
  Future<void> deleteMediaFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Bỏ qua lỗi xóa file
    }
  }
}
