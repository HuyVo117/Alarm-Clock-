import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:wake_up/core/theme/app_theme.dart';
import '../../domain/models/garden_profile_model.dart';

/// Thanh Header HUD ở góc trên: Avatar, Số dư Xu, Nút Cửa hàng, Thanh năng lượng Rương.
class FarmHeaderHud extends StatelessWidget {
  final GardenProfileModel profile;
  final VoidCallback onOpenShop;
  final VoidCallback onOpenChest;

  const FarmHeaderHud({
    super.key,
    required this.profile,
    required this.onOpenShop,
    required this.onOpenChest,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (profile.chestEnergy / profile.maxChestEnergy).clamp(0.0, 1.0);
    final isChestFull = profile.isChestReady;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Góc trên trái: Avatar + Tên trang trại
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                ),
                child: const Center(
                  child: Text('👨‍🌾', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Trang trại',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Cấp ${profile.level}',
                    style: TextStyle(
                      color: AppTheme.accentOrange.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Góc trên phải: Xu + Cửa hàng + Rương năng lượng
          Row(
            children: [
              // Badge Xu nông trại
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      '${profile.coins}',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Nút Cửa hàng (Shop)
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: onOpenShop,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.cart_fill, color: Colors.black, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Shop',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Rương thần kỳ (kèm thanh tiến độ năng lượng)
              GestureDetector(
                onTap: onOpenChest,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isChestFull ? const Color(0xFF388E3C) : const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isChestFull ? const Color(0xFFFFD700) : Colors.blueAccent.withOpacity(0.5),
                      width: isChestFull ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isChestFull ? '🎁' : '⚡',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${profile.chestEnergy}/${profile.maxChestEnergy}',
                            style: TextStyle(
                              color: isChestFull ? Colors.white : Colors.lightBlueAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 3,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isChestFull ? const Color(0xFFFFD700) : Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
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
