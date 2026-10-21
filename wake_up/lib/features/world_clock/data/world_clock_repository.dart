import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/world_city_model.dart';
import 'city_data.dart';

/// Interface trừu tượng quản lý lưu trữ các thành phố trong Đồng hồ Thế giới.
abstract class WorldClockRepository {
  /// Lấy danh sách thành phố đã lưu, sắp xếp theo sortOrder.
  Future<List<WorldCityModel>> getSavedCities();

  /// Lưu toàn bộ danh sách thành phố.
  Future<void> saveCities(List<WorldCityModel> cities);

  /// Thêm một thành phố vào danh sách.
  Future<void> addCity(WorldCityModel city);

  /// Xóa một thành phố theo id.
  Future<void> removeCity(String id);

  /// Đổi vị trí các thành phố (kéo thả sắp xếp).
  Future<void> reorderCities(int oldIndex, int newIndex);
}

/// Triển khai lưu trữ danh sách thành phố ra file JSON cục bộ.
/// Không cần nâng schema SQLite, nhanh, gọn, dễ dàng backup và test.
class LocalWorldClockRepository implements WorldClockRepository {
  final Future<File> Function()? _fileResolver;

  LocalWorldClockRepository([this._fileResolver]);

  Future<File> _getFile() async {
    if (_fileResolver != null) {
      return _fileResolver();
    }
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'world_clocks.json'));
  }

  @override
  Future<List<WorldCityModel>> getSavedCities() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        await saveCities(CityData.defaultCities);
        return CityData.defaultCities;
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return [];
      }
      final dynamic decoded = jsonDecode(content);
      if (decoded is List) {
        final list = decoded
            .map((item) => WorldCityModel.fromJson(item as Map<String, dynamic>))
            .toList();
        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return list;
      }
      return [];
    } catch (_) {
      return CityData.defaultCities;
    }
  }

  @override
  Future<void> saveCities(List<WorldCityModel> cities) async {
    final file = await _getFile();
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    final jsonList = cities.map((c) => c.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  @override
  Future<void> addCity(WorldCityModel city) async {
    final current = await getSavedCities();
    final alreadyExists = current.any(
      (c) => c.id == city.id || (c.timezoneId == city.timezoneId && c.cityName == city.cityName),
    );
    if (alreadyExists) return;

    final updated = List<WorldCityModel>.from(current);
    updated.add(city.copyWith(sortOrder: updated.length));
    await saveCities(updated);
  }

  @override
  Future<void> removeCity(String id) async {
    final current = await getSavedCities();
    final updated = current.where((c) => c.id != id).toList();
    for (int i = 0; i < updated.length; i++) {
      updated[i] = updated[i].copyWith(sortOrder: i);
    }
    await saveCities(updated);
  }

  @override
  Future<void> reorderCities(int oldIndex, int newIndex) async {
    final current = await getSavedCities();
    if (oldIndex < 0 || oldIndex >= current.length || newIndex < 0 || newIndex >= current.length) {
      return;
    }
    final updated = List<WorldCityModel>.from(current);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    for (int i = 0; i < updated.length; i++) {
      updated[i] = updated[i].copyWith(sortOrder: i);
    }
    await saveCities(updated);
  }
}
