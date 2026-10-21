import 'package:flutter_test/flutter_test.dart';
import 'package:wake_up/features/garden/domain/models/plot_model.dart';

void main() {
  group('PlotModel Tests', () {
    test('Default plot is empty with 0 remaining seconds', () {
      const plot = PlotModel(index: 0);
      expect(plot.state, equals(PlotState.empty));
      expect(plot.remainingSeconds(), equals(0));
      expect(plot.isReadyForHarvest(), isFalse);
      expect(plot.growthProgress(), equals(0.0));
    });

    test('Plot calculates remaining time and growth progress correctly', () {
      final now = DateTime(2026, 10, 21, 12, 0, 0);
      final plantedAt = now.subtract(const Duration(seconds: 10));

      final plot = PlotModel(
        index: 1,
        state: PlotState.growing,
        seedId: 'radish',
        plantedAt: plantedAt,
        growDurationSeconds: 20,
      );

      // 10s elapsed out of 20s -> 10s remaining, 50% progress
      expect(plot.remainingSeconds(now), equals(10));
      expect(plot.growthProgress(now), closeTo(0.5, 0.01));
      expect(plot.isReadyForHarvest(now), isFalse);
    });

    test('Plot with water reduction becomes ready for harvest early', () {
      final now = DateTime(2026, 10, 21, 12, 0, 0);
      final plantedAt = now.subtract(const Duration(seconds: 10));

      // 10s elapsed + 12s water reduction = 22s effective > 20s growDuration
      final plot = PlotModel(
        index: 2,
        state: PlotState.growing,
        seedId: 'radish',
        plantedAt: plantedAt,
        growDurationSeconds: 20,
        reducedSeconds: 12,
      );

      expect(plot.remainingSeconds(now), equals(0));
      expect(plot.growthProgress(now), equals(1.0));
      expect(plot.isReadyForHarvest(now), isTrue);
    });

    test('PlotModel JSON serialization and deserialization roundtrip', () {
      final now = DateTime(2026, 10, 21, 12, 0, 0);
      final plot = PlotModel(
        index: 5,
        state: PlotState.mature,
        seedId: 'corn',
        plantedAt: now,
        growDurationSeconds: 45,
        reducedSeconds: 7,
        mutationVariantId: 'corn_gold',
      );

      final json = plot.toJson();
      final restored = PlotModel.fromJson(json);

      expect(restored.index, equals(5));
      expect(restored.state, equals(PlotState.mature));
      expect(restored.seedId, equals('corn'));
      expect(restored.mutationVariantId, equals('corn_gold'));
      expect(restored.growDurationSeconds, equals(45));
      expect(restored.reducedSeconds, equals(7));
    });
  });
}
