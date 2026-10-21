import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import '../../data/seeds_catalog.dart';
import '../../domain/logic/isometric_math.dart';
import '../../domain/models/plot_model.dart';

/// Trình vẽ đồ họa Đảo nổi Isometric 2.5D với 16 ô đất cày xới, cây trồng và hiệu ứng.
class IsometricIslandPainter extends CustomPainter {
  final List<PlotModel> plots;
  final int? selectedPlotIndex;
  final double tileWidth;
  final double tileHeight;
  final Offset origin;

  IsometricIslandPainter({
    required this.plots,
    required this.selectedPlotIndex,
    required this.tileWidth,
    required this.tileHeight,
    required this.origin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawFloatingIslandBase(canvas);
    _drawPlots(canvas);
  }

  /// Vẽ thân đảo nổi 3D (vách đá đất nổi bồng bềnh phía dưới mặt cỏ).
  void _drawFloatingIslandBase(Canvas canvas) {
    const gridSize = 4;
    final topCorner = origin;
    final rightCorner = IsometricMath.gridToScreen(
      col: gridSize,
      row: 0,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      origin: origin,
    );
    final bottomCorner = IsometricMath.gridToScreen(
      col: gridSize,
      row: gridSize,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      origin: origin,
    );
    final leftCorner = IsometricMath.gridToScreen(
      col: 0,
      row: gridSize,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      origin: origin,
    );

    const cliffDepth = 48.0;

    // Vách bên trái (đổ bóng tối hơn)
    final leftCliffPath = Path()
      ..moveTo(leftCorner.dx, leftCorner.dy)
      ..lineTo(bottomCorner.dx, bottomCorner.dy)
      ..lineTo(bottomCorner.dx, bottomCorner.dy + cliffDepth)
      ..lineTo(leftCorner.dx, leftCorner.dy + cliffDepth)
      ..close();

    final leftCliffPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF3E2723), const Color(0xFF1B0000)],
      ).createShader(Rect.fromLTWH(leftCorner.dx, leftCorner.dy, tileWidth * 2, cliffDepth));
    canvas.drawPath(leftCliffPath, leftCliffPaint);

    // Vách bên phải (hứng sáng một chút)
    final rightCliffPath = Path()
      ..moveTo(rightCorner.dx, rightCorner.dy)
      ..lineTo(bottomCorner.dx, bottomCorner.dy)
      ..lineTo(bottomCorner.dx, bottomCorner.dy + cliffDepth)
      ..lineTo(rightCorner.dx, rightCorner.dy + cliffDepth)
      ..close();

    final rightCliffPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF4E342E), const Color(0xFF2E1C14)],
      ).createShader(Rect.fromLTWH(rightCorner.dx - tileWidth * 2, rightCorner.dy, tileWidth * 2, cliffDepth));
    canvas.drawPath(rightCliffPath, rightCliffPaint);

    // Mặt cỏ xanh mướt phía trên
    final grassPath = Path()
      ..moveTo(topCorner.dx, topCorner.dy)
      ..lineTo(rightCorner.dx, rightCorner.dy)
      ..lineTo(bottomCorner.dx, bottomCorner.dy)
      ..lineTo(leftCorner.dx, leftCorner.dy)
      ..close();

    final grassPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    canvas.drawPath(grassPath, grassPaint);

    // Viền mép cỏ phát sáng nhẹ
    final grassBorderPaint = Paint()
      ..color = const Color(0xFF66BB6A).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(grassPath, grassBorderPaint);
  }

  /// Vẽ 16 ô đất cày xới và cây trồng trên từng ô.
  void _drawPlots(Canvas canvas) {
    const gridSize = 4;
    const padding = 4.0; // Khoảng cách giữa các luống đất
    final plotW = tileWidth - padding * 2;
    final plotH = tileHeight - padding;

    final now = DateTime.now();

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        final index = IsometricMath.gridToIndex(c, r, gridSize);
        final plot = (index >= 0 && index < plots.length)
            ? plots[index]
            : PlotModel(index: index);

        final center = IsometricMath.gridToScreen(
          col: c,
          row: r,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          origin: Offset(origin.dx, origin.dy + tileHeight / 2),
        );

        final plotPath = IsometricMath.getDiamondPath(
          center: center,
          tileWidth: plotW,
          tileHeight: plotH,
        );

        // Màu nền của ô đất
        Color soilColor = const Color(0xFF5D4037); // Đất nâu ấm
        if (plot.state == PlotState.sprout || plot.state == PlotState.growing) {
          soilColor = const Color(0xFF3E2723); // Đất ẩm sau khi tưới
        } else if (plot.state == PlotState.mature) {
          soilColor = const Color(0xFF4E342E);
        }

        final soilPaint = Paint()
          ..color = soilColor
          ..style = PaintingStyle.fill;
        canvas.drawPath(plotPath, soilPaint);

        // Vẽ luống cày (rãnh đất)
        _drawTilledFurrows(canvas, center, plotW, plotH);

        // Nếu ô đất đang được chọn -> vẽ viền vàng phát sáng
        final isSelected = selectedPlotIndex == index;
        if (isSelected) {
          final selectBorderPaint = Paint()
            ..color = const Color(0xFFFFD700)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.5;
          canvas.drawPath(plotPath, selectBorderPaint);

          final glowPaint = Paint()
            ..color = const Color(0xFFFFD700).withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
          canvas.drawPath(plotPath, glowPaint);
        } else {
          // Viền bình thường của ô đất
          final borderPaint = Paint()
            ..color = const Color(0xFF1B0000).withOpacity(0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;
          canvas.drawPath(plotPath, borderPaint);
        }

        // Vẽ cây trồng và trạng thái trên ô đất
        _drawPlotContent(canvas, center, plot, now);
      }
    }
  }

  /// Vẽ các đường rãnh luống đất nông nghiệp.
  void _drawTilledFurrows(Canvas canvas, Offset center, double w, double h) {
    final furrowPaint = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(center.dx - w * 0.25, center.dy - h * 0.1),
      Offset(center.dx + w * 0.25, center.dy + h * 0.1),
      furrowPaint,
    );
    canvas.drawLine(
      Offset(center.dx - w * 0.25, center.dy + h * 0.1),
      Offset(center.dx + w * 0.25, center.dy - h * 0.1),
      furrowPaint,
    );
  }

  /// Vẽ nội dung cây trồng / mầm / quả chín / đếm ngược thời gian.
  void _drawPlotContent(Canvas canvas, Offset center, PlotModel plot, DateTime now) {
    switch (plot.state) {
      case PlotState.empty:
        // Đất trống: vẽ dấu chấm cộng mờ gợi ý gieo hạt
        final dotPaint = Paint()..color = Colors.white.withOpacity(0.15);
        canvas.drawCircle(center, 2.5, dotPaint);
        break;

      case PlotState.sprout:
        // Mầm nhỏ nhú lên
        _drawEmoji(canvas, center.translate(0, -6), '🌱', 20);
        break;

      case PlotState.growing:
        // Đang lớn: vẽ mầm to hơn và số giây đếm ngược
        _drawEmoji(canvas, center.translate(0, -10), '🌿', 24);
        final rem = plot.remainingSeconds(now);
        _drawText(
          canvas,
          center.translate(0, 10),
          '${rem}s',
          color: const Color(0xFF81C784),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        );
        break;

      case PlotState.mature:
        // Cây đã chín: tìm biến thể màu sắc đột biến
        final variant = SeedsCatalog.findVariantById(plot.mutationVariantId ?? '');
        final color = Color(variant?.colorValue ?? 0xFFFFD700);

        // Hiệu ứng hào quang phát sáng
        final glowPaint = Paint()
          ..color = color.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(center.translate(0, -12), 16, glowPaint);

        // Icon nông sản
        final emoji = variant?.iconEmoji ?? '⭐';
        _drawEmoji(canvas, center.translate(0, -14), emoji, 28);

        // Nhãn tên biến thể màu sắc
        _drawText(
          canvas,
          center.translate(0, 10),
          variant?.name.split(' ').last ?? 'Chín',
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        );
        break;

      case PlotState.harvested:
        // Vừa thu hoạch: hiện tia sao vàng
        _drawEmoji(canvas, center.translate(0, -8), '✨', 18);
        break;
    }
  }

  void _drawEmoji(Canvas canvas, Offset center, String emoji, double fontSize) {
    final textSpan = TextSpan(
      text: emoji,
      style: TextStyle(fontSize: fontSize),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  void _drawText(
    Canvas canvas,
    Offset center,
    String text, {
    required Color color,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: '.SF Pro Text',
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant IsometricIslandPainter oldDelegate) {
    return true; // Luôn repaint theo nhịp ticker và tương tác
  }
}
