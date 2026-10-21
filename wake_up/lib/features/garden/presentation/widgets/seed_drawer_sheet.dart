import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:wake_up/core/theme/app_theme.dart';
import '../../data/seeds_catalog.dart';
import '../../domain/models/seed_model.dart';

/// Ngăn kéo chọn hạt giống trượt từ đáy màn hình lên để gieo hạt.
class SeedDrawerSheet extends StatefulWidget {
  final Map<String, int> inventory;
  final String selectedSeedId;
  final ValueChanged<String> onSelectSeed;
  final ValueChanged<String> onPlantAll;

  const SeedDrawerSheet({
    super.key,
    required this.inventory,
    required this.selectedSeedId,
    required this.onSelectSeed,
    required this.onPlantAll,
  });

  @override
  State<SeedDrawerSheet> createState() => _SeedDrawerSheetState();
}

class _SeedDrawerSheetState extends State<SeedDrawerSheet> {
  int _selectedTabIndex = 0; // 0: Tất cả, 1: Cơ bản, 2: Đặc biệt

  @override
  Widget build(BuildContext context) {
    final allSeeds = SeedsCatalog.all;
    final filteredSeeds = allSeeds.where((s) {
      if (_selectedTabIndex == 1) return s.category == SeedCategory.basic;
      if (_selectedTabIndex == 2) return s.category == SeedCategory.special;
      return true;
    }).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh kéo nhỏ trên đầu
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

          // Header + Tab phân loại
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Túi hạt giống',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Segmented control kiểu iOS
              CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedTabIndex,
                backgroundColor: const Color(0xFF2C2C2E),
                thumbColor: AppTheme.accentOrange,
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Tất cả', style: TextStyle(fontSize: 11)),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Cơ bản', style: TextStyle(fontSize: 11)),
                  ),
                  2: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Đặc biệt', style: TextStyle(fontSize: 11)),
                  ),
                },
                onValueChanged: (val) {
                  if (val != null) setState(() => _selectedTabIndex = val);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Danh sách các túi hạt giống cuộn ngang
          SizedBox(
            height: 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filteredSeeds.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final seed = filteredSeeds[index];
                final count = widget.inventory[seed.id] ?? 0;
                final isSelected = widget.selectedSeedId == seed.id;

                return GestureDetector(
                  onTap: () => widget.onSelectSeed(seed.id),
                  child: Container(
                    width: 110,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentOrange.withOpacity(0.18)
                          : const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.accentOrange : Colors.white10,
                        width: isSelected ? 2.0 : 0.8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(seed.iconEmoji, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 4),
                        Text(
                          seed.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? AppTheme.accentOrange : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'x$count',
                              style: TextStyle(
                                color: count > 0 ? const Color(0xFF81C784) : Colors.redAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '⏱️${seed.growSeconds}s',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Nút gieo hàng loạt cho hạt giống đang chọn
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  color: AppTheme.accentOrange,
                  borderRadius: BorderRadius.circular(14),
                  onPressed: () => widget.onPlantAll(widget.selectedSeedId),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.sparkles, color: Colors.black, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Gieo vào tất cả ô trống',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
