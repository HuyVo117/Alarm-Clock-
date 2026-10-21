import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/world_clock_repository.dart';
import '../../domain/world_city_model.dart';
import '../../domain/world_clock_service.dart';

/// Provider cung cấp instance WorldClockService thuần Dart.
final worldClockServiceProvider = Provider<WorldClockService>((ref) {
  return WorldClockService();
});

/// Provider cung cấp repository lưu trữ thành phố thế giới.
final worldClockRepositoryProvider = Provider<WorldClockRepository>((ref) {
  return LocalWorldClockRepository();
});

/// Notifier quản lý danh sách các thành phố đã lưu.
class SavedCitiesNotifier extends AsyncNotifier<List<WorldCityModel>> {
  @override
  Future<List<WorldCityModel>> build() async {
    final repo = ref.watch(worldClockRepositoryProvider);
    return repo.getSavedCities();
  }

  /// Thêm một thành phố mới vào danh sách đã lưu.
  Future<void> addCity(WorldCityModel city) async {
    final repo = ref.read(worldClockRepositoryProvider);
    await repo.addCity(city);
    ref.invalidateSelf();
  }

  /// Xóa thành phố theo ID.
  Future<void> removeCity(String id) async {
    final repo = ref.read(worldClockRepositoryProvider);
    await repo.removeCity(id);
    ref.invalidateSelf();
  }

  /// Sắp xếp lại vị trí thành phố (hỗ trợ kéo thả ReorderableListView).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final repo = ref.read(worldClockRepositoryProvider);
    await repo.reorderCities(oldIndex, newIndex);
    ref.invalidateSelf();
  }
}

/// Provider chính cho danh sách thành phố thế giới đã lưu.
final savedCitiesProvider =
    AsyncNotifierProvider<SavedCitiesNotifier, List<WorldCityModel>>(
  SavedCitiesNotifier.new,
);
