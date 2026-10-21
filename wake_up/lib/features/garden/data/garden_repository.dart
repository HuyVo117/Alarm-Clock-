import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/models/garden_profile_model.dart';
import '../domain/models/plot_model.dart';

/// Interface trừu tượng quản lý lưu trữ trạng thái Nông trại.
abstract class GardenRepository {
  /// Lấy hồ sơ người chơi (xu, năng lượng, túi đồ, sổ tay).
  Future<GardenProfileModel> loadProfile();

  /// Lưu hồ sơ người chơi.
  Future<void> saveProfile(GardenProfileModel profile);

  /// Lấy danh sách 16 ô đất của nông trại.
  Future<List<PlotModel>> loadPlots();

  /// Lưu danh sách 16 ô đất của nông trại.
  Future<void> savePlots(List<PlotModel> plots);
}

/// Triển khai lưu trữ cục bộ qua file JSON (nhanh, an toàn, dễ kiểm thử).
class LocalGardenRepository implements GardenRepository {
  final Future<File> Function()? _fileResolver;

  LocalGardenRepository([this._fileResolver]);

  Future<File> _getFile() async {
    if (_fileResolver != null) {
      return _fileResolver();
    }
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'garden_state.json'));
  }

  @override
  Future<GardenProfileModel> loadProfile() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return const GardenProfileModel();
      }
      final raw = await file.readAsString();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map.containsKey('profile')) {
        return GardenProfileModel.fromJson(map['profile'] as Map<String, dynamic>);
      }
      return const GardenProfileModel();
    } catch (_) {
      return const GardenProfileModel();
    }
  }

  @override
  Future<void> saveProfile(GardenProfileModel profile) async {
    try {
      final file = await _getFile();
      Map<String, dynamic> currentData = {};
      if (await file.exists()) {
        try {
          final raw = await file.readAsString();
          currentData = jsonDecode(raw) as Map<String, dynamic>;
        } catch (_) {}
      }
      currentData['profile'] = profile.toJson();
      await file.writeAsString(jsonEncode(currentData), flush: true);
    } catch (_) {}
  }

  @override
  Future<List<PlotModel>> loadPlots() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return _generateDefaultPlots();
      }
      final raw = await file.readAsString();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map.containsKey('plots')) {
        final list = (map['plots'] as List<dynamic>)
            .map((e) => PlotModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (list.length == 16) return list;
      }
      return _generateDefaultPlots();
    } catch (_) {
      return _generateDefaultPlots();
    }
  }

  @override
  Future<void> savePlots(List<PlotModel> plots) async {
    try {
      final file = await _getFile();
      Map<String, dynamic> currentData = {};
      if (await file.exists()) {
        try {
          final raw = await file.readAsString();
          currentData = jsonDecode(raw) as Map<String, dynamic>;
        } catch (_) {}
      }
      currentData['plots'] = plots.map((p) => p.toJson()).toList();
      await file.writeAsString(jsonEncode(currentData), flush: true);
    } catch (_) {}
  }

  List<PlotModel> _generateDefaultPlots() {
    return List.generate(
      16,
      (index) => PlotModel(index: index),
    );
  }
}
