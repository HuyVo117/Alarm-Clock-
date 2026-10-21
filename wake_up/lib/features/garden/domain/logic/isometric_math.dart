import 'dart:ui';

/// Thư viện toán học thuần túy chuyển đổi tọa độ Isometric 2.5D cho nông trại.
class IsometricMath {
  /// Chuyển đổi chỉ số 1D (0..15) thành tọa độ lưới 2D (col, row).
  static (int col, int row) indexToGrid(int index, [int gridSize = 4]) {
    final col = index % gridSize;
    final row = index ~/ gridSize;
    return (col, row);
  }

  /// Chuyển đổi tọa độ lưới 2D (col, row) thành chỉ số 1D (0..15).
  static int gridToIndex(int col, int row, [int gridSize = 4]) {
    return row * gridSize + col;
  }

  /// Tính tọa độ tâm màn hình (Screen Center Offset) từ tọa độ ô lưới (col, row).
  /// [tileWidth]: Chiều rộng hình thoi ô đất.
  /// [tileHeight]: Chiều cao hình thoi ô đất (thường = tileWidth / 2).
  /// [origin]: Điểm gốc (đỉnh trên của hòn đảo).
  static Offset gridToScreen({
    required int col,
    required int row,
    required double tileWidth,
    required double tileHeight,
    required Offset origin,
  }) {
    final screenX = (col - row) * (tileWidth / 2) + origin.dx;
    final screenY = (col + row) * (tileHeight / 2) + origin.dy;
    return Offset(screenX, screenY);
  }

  /// Tìm ô lưới (col, row) từ điểm chạm ngón tay trên màn hình (Screen Position).
  /// Trả về null nếu điểm chạm nằm ngoài phạm vi hòn đảo 4x4.
  static (int col, int row)? screenToGrid({
    required Offset screenPos,
    required double tileWidth,
    required double tileHeight,
    required Offset origin,
    int gridSize = 4,
  }) {
    final dx = screenPos.dx - origin.dx;
    final dy = screenPos.dy - origin.dy;

    final termX = dx / (tileWidth / 2);
    final termY = dy / (tileHeight / 2);

    final floatCol = (termX + termY) / 2.0;
    final floatRow = (termY - termX) / 2.0;

    final col = floatCol.floor();
    final row = floatRow.floor();

    if (col >= 0 && col < gridSize && row >= 0 && row < gridSize) {
      return (col, row);
    }
    return null;
  }

  /// Tạo đường Path hình thoi 4 đỉnh bao quanh 1 ô đất tại tọa độ tâm [center].
  static Path getDiamondPath({
    required Offset center,
    required double tileWidth,
    required double tileHeight,
  }) {
    final halfW = tileWidth / 2;
    final halfH = tileHeight / 2;

    return Path()
      ..moveTo(center.dx, center.dy - halfH)        // Đỉnh trên
      ..lineTo(center.dx + halfW, center.dy)        // Đỉnh phải
      ..lineTo(center.dx, center.dy + halfH)        // Đỉnh dưới
      ..lineTo(center.dx - halfW, center.dy)        // Đỉnh trái
      ..close();
  }
}
