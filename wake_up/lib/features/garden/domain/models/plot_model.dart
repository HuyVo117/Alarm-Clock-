/// Các trạng thái của một ô đất trong nông trại.
enum PlotState {
  empty,      // Đất trống, sẵn sàng gieo hạt
  sprout,     // Mầm mới nhú (vừa gieo trong vài giây đầu)
  growing,    // Đang phát triển (có đồng hồ đếm ngược)
  mature,     // Cây đã chín (đã xác định biến thể đột biến màu)
  harvested,  // Đã thu hoạch (chờ chuyển về empty)
}

/// Mô hình biểu diễn trạng thái của 1 ô đất trong lưới 4x4 (16 ô).
class PlotModel {
  final int index;
  final PlotState state;
  final String? seedId;
  final DateTime? plantedAt;
  final int growDurationSeconds;
  final int reducedSeconds;
  final String? mutationVariantId;

  const PlotModel({
    required this.index,
    this.state = PlotState.empty,
    this.seedId,
    this.plantedAt,
    this.growDurationSeconds = 0,
    this.reducedSeconds = 0,
    this.mutationVariantId,
  });

  /// Tính số giây còn lại cho đến khi cây chín.
  int remainingSeconds([DateTime? currentTime]) {
    if (state == PlotState.empty || plantedAt == null || growDurationSeconds <= 0) {
      return 0;
    }
    final now = currentTime ?? DateTime.now();
    final elapsed = now.difference(plantedAt!).inSeconds;
    final totalEffectiveElapsed = elapsed + reducedSeconds;
    final remaining = growDurationSeconds - totalEffectiveElapsed;
    return remaining > 0 ? remaining : 0;
  }

  /// Kiểm tra cây đã chín và sẵn sàng thu hoạch chưa.
  bool isReadyForHarvest([DateTime? currentTime]) {
    if (state == PlotState.mature) return true;
    if (state == PlotState.growing || state == PlotState.sprout) {
      return remainingSeconds(currentTime) <= 0;
    }
    return false;
  }

  /// Tiến độ sinh trưởng từ 0.0 (mới gieo) đến 1.0 (chín).
  double growthProgress([DateTime? currentTime]) {
    if (state == PlotState.empty || plantedAt == null || growDurationSeconds <= 0) {
      return 0.0;
    }
    if (state == PlotState.mature) return 1.0;
    final now = currentTime ?? DateTime.now();
    final elapsed = now.difference(plantedAt!).inSeconds + reducedSeconds;
    final ratio = elapsed / growDurationSeconds;
    if (ratio < 0.0) return 0.0;
    if (ratio >= 1.0) return 1.0;
    return ratio;
  }

  /// Tạo bản sao với các thuộc tính cập nhật.
  PlotModel copyWith({
    int? index,
    PlotState? state,
    String? seedId,
    DateTime? plantedAt,
    int? growDurationSeconds,
    int? reducedSeconds,
    String? mutationVariantId,
    bool clearMutation = false,
    bool clearSeed = false,
  }) {
    return PlotModel(
      index: index ?? this.index,
      state: state ?? this.state,
      seedId: clearSeed ? null : (seedId ?? this.seedId),
      plantedAt: clearSeed ? null : (plantedAt ?? this.plantedAt),
      growDurationSeconds: growDurationSeconds ?? this.growDurationSeconds,
      reducedSeconds: reducedSeconds ?? this.reducedSeconds,
      mutationVariantId: clearMutation ? null : (mutationVariantId ?? this.mutationVariantId),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'state': state.name,
      'seedId': seedId,
      'plantedAt': plantedAt?.toIso8601String(),
      'growDurationSeconds': growDurationSeconds,
      'reducedSeconds': reducedSeconds,
      'mutationVariantId': mutationVariantId,
    };
  }

  factory PlotModel.fromJson(Map<String, dynamic> json) {
    return PlotModel(
      index: json['index'] as int? ?? 0,
      state: PlotState.values.firstWhere(
        (e) => e.name == json['state'],
        orElse: () => PlotState.empty,
      ),
      seedId: json['seedId'] as String?,
      plantedAt: json['plantedAt'] != null
          ? DateTime.tryParse(json['plantedAt'] as String)
          : null,
      growDurationSeconds: json['growDurationSeconds'] as int? ?? 0,
      reducedSeconds: json['reducedSeconds'] as int? ?? 0,
      mutationVariantId: json['mutationVariantId'] as String?,
    );
  }

  @override
  String toString() {
    return 'PlotModel(index: $index, state: $state, seed: $seedId, remaining: ${remainingSeconds()}s)';
  }
}
