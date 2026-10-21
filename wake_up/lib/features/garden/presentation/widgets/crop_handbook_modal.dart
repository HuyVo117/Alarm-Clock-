import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import '../../data/seeds_catalog.dart';
import '../../domain/models/crop_variant_model.dart';

/// Modal Sổ tay bộ sưu tập nông sản đột biến màu sắc.
class CropHandbookModal extends StatelessWidget {
  final Set<String> unlockedVariantIds;

  const CropHandbookModal({
    super.key,
    required this.unlockedVariantIds,
  });

  @override
  Widget build(BuildContext context) {
    final allSeeds = SeedsCatalog.all;
    int totalVariants = 0;
    for (final s in allSeeds) {
      totalVariants += s.variants.length;
    }
    final unlockedCount = unlockedVariantIds.length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header thanh kéo
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title & Tiến độ mở khóa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sổ tay Nông sản',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  'Khám phá $unlockedCount / $totalVariants',
                  style: const TextStyle(
                    color: Color(0xFF81C784),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Danh sách các loại nông sản và các biến thể đột biến
          Expanded(
            child: ListView.separated(
              itemCount: allSeeds.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final seed = allSeeds[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(seed.iconEmoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Text(
                            seed.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Hàng hiển thị 3 biến thể màu
                      Row(
                        children: seed.variants.map((v) {
                          final isUnlocked = unlockedVariantIds.contains(v.id);

                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? Color(v.colorValue).withOpacity(0.12)
                                    : Colors.black26,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isUnlocked
                                      ? Color(v.colorValue).withOpacity(0.7)
                                      : Colors.white10,
                                  width: isUnlocked ? 1.5 : 0.8,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    isUnlocked ? v.iconEmoji : '❓',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: isUnlocked ? null : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isUnlocked ? v.name : 'Chưa mở',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isUnlocked ? Color(v.colorValue) : Colors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _buildRarityBadge(v.rarity, isUnlocked),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRarityBadge(CropRarity rarity, bool isUnlocked) {
    if (!isUnlocked) {
      return const Text('???', style: TextStyle(color: Colors.white30, fontSize: 9));
    }

    String label;
    Color color;
    switch (rarity) {
      case CropRarity.common:
        label = 'Thường';
        color = Colors.grey;
        break;
      case CropRarity.rare:
        label = 'Hiếm';
        color = Colors.cyanAccent;
        break;
      case CropRarity.legendary:
        label = 'Hoàng kim';
        color = const Color(0xFFFFD700);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }
}
