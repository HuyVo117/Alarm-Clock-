import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:wake_up/core/theme/app_theme.dart';
import '../../data/seeds_catalog.dart';
import '../../domain/models/chest_reward_model.dart';

/// Modal hiển thị phần thưởng khi mở Rương Thần Kỳ.
class ChestRewardModal extends StatelessWidget {
  final ChestRewardModel reward;
  final VoidCallback onClaim;

  const ChestRewardModal({
    super.key,
    required this.reward,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎁', style: TextStyle(fontSize: 54)),
          const SizedBox(height: 12),
          const Text(
            'RƯƠNG THẦN KỲ',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reward.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Danh sách vật phẩm nhận được
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Xu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('🪙', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Text('Xu nông trại', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                    Text(
                      '+${reward.coins} Xu',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (reward.bonusEnergy > 0) ...[
                  Container(height: 0.5, color: Colors.white12, margin: const EdgeInsets.symmetric(vertical: 8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text('⚡', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 8),
                          Text('Năng lượng tiếp sức', style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                      Text(
                        '+${reward.bonusEnergy}',
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                // Hạt giống tặng kèm
                ...reward.bonusSeeds.entries.map((entry) {
                  final seed = SeedsCatalog.findById(entry.key);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(seed?.iconEmoji ?? '🌱', style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(seed?.name ?? entry.key, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          ],
                        ),
                        Text(
                          '+${entry.value} gói',
                          style: const TextStyle(
                            color: Color(0xFF81C784),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Nút Nhận tất cả
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: AppTheme.accentOrange,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              onPressed: () {
                onClaim();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Mở tất cả & Nhận thưởng',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
