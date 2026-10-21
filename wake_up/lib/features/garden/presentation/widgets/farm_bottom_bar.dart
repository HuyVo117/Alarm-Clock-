import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:wake_up/core/theme/app_theme.dart';

/// Thanh Footer HUD ở góc dưới màn hình: Nhiệm vụ nhanh, Sổ tay, Bạn bè, Nút Gieo hạt.
class FarmBottomBar extends StatelessWidget {
  final int pumpkinPlantedCount;
  final int unlockedVariantsCount;
  final bool isSeedDrawerOpen;
  final VoidCallback onToggleSeedDrawer;
  final VoidCallback onOpenHandbook;
  final VoidCallback onOpenFriends;

  const FarmBottomBar({
    super.key,
    required this.pumpkinPlantedCount,
    required this.unlockedVariantsCount,
    required this.isSeedDrawerOpen,
    required this.onToggleSeedDrawer,
    required this.onOpenHandbook,
    required this.onOpenFriends,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Góc dưới trái: Card nhiệm vụ nhanh
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Text('🎯', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Text(
                    'Nhiệm vụ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Bí ngô đã trồng: ($pumpkinPlantedCount/16)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Góc dưới phải: Các nút điều hướng chính
        Row(
          children: [
            // Nút Sổ tay bộ sưu tập
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onOpenHandbook,
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text('📖', style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(width: 8),

            // Nút Bạn bè
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onOpenFriends,
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text('👥', style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(width: 8),

            // Nút Gieo hạt (mở/đóng khay hạt giống trượt từ đáy)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onToggleSeedDrawer,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSeedDrawerOpen
                        ? [Colors.grey.shade700, Colors.grey.shade900]
                        : [AppTheme.accentOrange, const Color(0xFFE65100)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSeedDrawerOpen ? Colors.white24 : const Color(0xFFFFD700),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentOrange.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isSeedDrawerOpen ? '✖' : '🌱', style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      isSeedDrawerOpen ? 'Đóng túi' : 'Gieo hạt',
                      style: TextStyle(
                        color: isSeedDrawerOpen ? Colors.white : Colors.black,
                        fontSize: 12,
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
    );
  }
}
