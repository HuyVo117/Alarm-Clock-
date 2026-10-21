import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import 'package:wake_up/core/theme/app_theme.dart';
import '../../data/seeds_catalog.dart';
import '../../domain/models/seed_model.dart';

/// Modal Cửa hàng mua hạt giống với lưới sản phẩm và thanh trượt số lượng từ 1 đến 99.
class FarmShopModal extends StatefulWidget {
  final int coins;
  final Function(String seedId, int quantity) onBuy;

  const FarmShopModal({
    super.key,
    required this.coins,
    required this.onBuy,
  });

  @override
  State<FarmShopModal> createState() => _FarmShopModalState();
}

class _FarmShopModalState extends State<FarmShopModal> {
  late SeedModel _selectedSeed;
  int _quantity = 5;

  @override
  void initState() {
    super.initState();
    _selectedSeed = SeedsCatalog.all.first;
  }

  @override
  Widget build(BuildContext context) {
    final allSeeds = SeedsCatalog.all;
    final totalCost = _selectedSeed.price * _quantity;
    final canAfford = widget.coins >= totalCost;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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

          // Title & Số dư Xu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cửa hàng Nông trại',
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
                  border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.coins} Xu',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Lưới danh sách hạt giống
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allSeeds.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final seed = allSeeds[index];
                final isSelected = _selectedSeed.id == seed.id;

                return GestureDetector(
                  onTap: () => setState(() => _selectedSeed = seed),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentOrange.withOpacity(0.18)
                          : const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppTheme.accentOrange : Colors.white12,
                        width: isSelected ? 2.0 : 0.8,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(seed.iconEmoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          seed.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          seed.price == 0 ? 'Miễn phí' : '${seed.price} Xu',
                          style: TextStyle(
                            color: seed.price == 0 ? const Color(0xFF81C784) : const Color(0xFFFFD700),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Panel chi tiết hạt giống đang chọn
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(_selectedSeed.iconEmoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedSeed.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedSeed.description,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(height: 0.5, color: Colors.white12),
                    const SizedBox(height: 8),

                    // Thông số kỹ thuật
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('⏱️ Thời gian', '${_selectedSeed.growSeconds} giây'),
                        _buildStat('🎨 Đột biến', '${_selectedSeed.variants.length} màu'),
                        _buildStat('⭐ Điểm EXP', '+${_selectedSeed.expReward} EXP'),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Các biến thể màu sắc có thể xuất hiện:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _selectedSeed.variants.map((v) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(v.colorValue).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(v.colorValue).withOpacity(0.6)),
                          ),
                          child: Text(
                            '${v.iconEmoji} ${v.name} (${(v.dropRate * 100).toInt()}%)',
                            style: TextStyle(
                              color: Color(v.colorValue),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Bộ chọn số lượng mua (thanh trượt - / + tối đa 99)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Số lượng mua:',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                    child: const Icon(CupertinoIcons.minus_circle_fill, color: AppTheme.accentOrange, size: 28),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _quantity < 99 ? () => setState(() => _quantity++) : null,
                    child: const Icon(CupertinoIcons.plus_circle_fill, color: AppTheme.accentOrange, size: 28),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Nút xác nhận mua
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: canAfford ? AppTheme.accentOrange : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              onPressed: canAfford
                  ? () {
                      widget.onBuy(_selectedSeed.id, _quantity);
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text(
                totalCost == 0
                    ? 'Nhận $_quantity gói miễn phí'
                    : 'Mua ngay ($totalCost Xu)',
                style: TextStyle(
                  color: canAfford ? Colors.black : Colors.white38,
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

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
