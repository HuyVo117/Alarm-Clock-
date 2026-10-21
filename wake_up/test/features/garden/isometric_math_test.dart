import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/garden/domain/logic/isometric_math.dart';

void main() {
  group('IsometricMath Tests', () {
    test('indexToGrid and gridToIndex should be reciprocal for 4x4 grid', () {
      for (int i = 0; i < 16; i++) {
        final (col, row) = IsometricMath.indexToGrid(i, 4);
        expect(col, inInclusiveRange(0, 3));
        expect(row, inInclusiveRange(0, 3));
        final reconstructedIndex = IsometricMath.gridToIndex(col, row, 4);
        expect(reconstructedIndex, equals(i));
      }
    });

    test('gridToScreen calculates correct coordinates', () {
      const tileWidth = 80.0;
      const tileHeight = 40.0;
      const origin = Offset(200, 100);

      // (0, 0)
      final pos00 = IsometricMath.gridToScreen(
        col: 0,
        row: 0,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        origin: origin,
      );
      expect(pos00, equals(const Offset(200, 100)));

      // (1, 0) -> x = (1-0)*40 + 200 = 240, y = (1+0)*20 + 100 = 120
      final pos10 = IsometricMath.gridToScreen(
        col: 1,
        row: 0,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        origin: origin,
      );
      expect(pos10, equals(const Offset(240, 120)));

      // (0, 1) -> x = (0-1)*40 + 200 = 160, y = (0+1)*20 + 100 = 120
      final pos01 = IsometricMath.gridToScreen(
        col: 0,
        row: 1,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        origin: origin,
      );
      expect(pos01, equals(const Offset(160, 120)));
    });

    test('screenToGrid inverse mapping should correctly identify tile centers', () {
      const tileWidth = 80.0;
      const tileHeight = 40.0;
      const origin = Offset(200, 100);

      for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
          final center = IsometricMath.gridToScreen(
            col: c,
            row: r,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            origin: origin,
          );

          final found = IsometricMath.screenToGrid(
            screenPos: center,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            origin: origin,
            gridSize: 4,
          );

          expect(found, isNotNull);
          expect(found!.$1, equals(c));
          expect(found.$2, equals(r));
        }
      }
    });

    test('screenToGrid returns null for points clearly outside island', () {
      const tileWidth = 80.0;
      const tileHeight = 40.0;
      const origin = Offset(200, 100);

      final outPoint = IsometricMath.screenToGrid(
        screenPos: const Offset(500, 500),
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        origin: origin,
        gridSize: 4,
      );
      expect(outPoint, isNull);
    });

    test('getDiamondPath creates closed path with 4 points', () {
      final path = IsometricMath.getDiamondPath(
        center: const Offset(100, 100),
        tileWidth: 80,
        tileHeight: 40,
      );
      final bounds = path.getBounds();
      expect(bounds.left, equals(60));
      expect(bounds.right, equals(140));
      expect(bounds.top, equals(80));
      expect(bounds.bottom, equals(120));
    });
  });
}
