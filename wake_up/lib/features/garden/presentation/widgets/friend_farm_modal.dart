import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:wake_up/core/theme/app_theme.dart';

/// Dữ liệu bạn bè nông trại mô phỏng.
class FriendFarmInfo {
  final String id;
  final String name;
  final String avatar;
  final int level;
  final int streakDays;
  final String status;
  bool hasWateredHelp;

  FriendFarmInfo({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.streakDays,
    required this.status,
    this.hasWateredHelp = false,
  });
}

/// Modal ghé thăm nông trại bạn bè và tưới nước hộ nhận thưởng.
class FriendFarmModal extends StatefulWidget {
  final Function(String friendName) onWaterFriend;

  const FriendFarmModal({
    super.key,
    required this.onWaterFriend,
  });

  @override
  State<FriendFarmModal> createState() => _FriendFarmModalState();
}

class _FriendFarmModalState extends State<FriendFarmModal> {
  final List<FriendFarmInfo> _friends = [
    FriendFarmInfo(
      id: 'f1',
      name: 'Hoàng Anh',
      avatar: '👨‍🌾',
      level: 5,
      streakDays: 14,
      status: 'Đang trồng Bí ngô 🎃',
    ),
    FriendFarmInfo(
      id: 'f2',
      name: 'Mai Lan',
      avatar: '👩‍🌾',
      level: 3,
      streakDays: 8,
      status: 'Cần tưới nước Củ cải 💧',
    ),
    FriendFarmInfo(
      id: 'f3',
      name: 'Thanh Tùng',
      avatar: '🧑‍🌾',
      level: 7,
      streakDays: 25,
      status: 'Nông trại trù phú ⭐',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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

          // Title
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nông trại Bạn bè',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tưới hộ nhận Xu & Năng lượng ⚡',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Danh sách bạn bè
          Expanded(
            child: ListView.separated(
              itemCount: _friends.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final friend = _friends[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white12,
                          border: Border.all(color: AppTheme.accentOrange, width: 1.5),
                        ),
                        child: Center(
                          child: Text(friend.avatar, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Thông tin
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Cấp ${friend.level} • Chuỗi dậy sớm ${friend.streakDays} ngày 🔥',
                              style: const TextStyle(
                                color: AppTheme.accentOrange,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              friend.status,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nút tưới nước giúp
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        color: friend.hasWateredHelp ? Colors.grey.shade800 : const Color(0xFF0288D1),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: friend.hasWateredHelp
                            ? null
                            : () {
                                setState(() {
                                  friend.hasWateredHelp = true;
                                });
                                widget.onWaterFriend(friend.name);
                              },
                        child: Text(
                          friend.hasWateredHelp ? 'Đã tưới' : 'Tưới giúp 💧',
                          style: TextStyle(
                            color: friend.hasWateredHelp ? Colors.white38 : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}
