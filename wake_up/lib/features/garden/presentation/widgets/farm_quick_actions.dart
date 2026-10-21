import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;


/// Các nút thao tác nhanh bên trái màn hình: Tưới nước hàng loạt & Thu hoạch toàn bộ.
class FarmQuickActions extends StatelessWidget {
  final int readyToHarvestCount;
  final int growingCount;
  final VoidCallback onWaterAll;
  final VoidCallback onHarvestAll;

  const FarmQuickActions({
    super.key,
    required this.readyToHarvestCount,
    required this.growingCount,
    required this.onWaterAll,
    required this.onHarvestAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Nút Tưới nước hàng loạt
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: growingCount > 0 ? onWaterAll : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: growingCount > 0
                    ? [const Color(0xFF0288D1), const Color(0xFF01579B)]
                    : [Colors.grey.shade800, Colors.grey.shade900],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: growingCount > 0 ? Colors.lightBlueAccent : Colors.white12,
                width: 1.0,
              ),
              boxShadow: growingCount > 0
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🚿', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tưới nước',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$growingCount ô',
                      style: const TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 2. Nút Thu hoạch toàn bộ (N vị trí)
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: readyToHarvestCount > 0 ? onHarvestAll : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: readyToHarvestCount > 0
                    ? [const Color(0xFFFF9800), const Color(0xFFE65100)]
                    : [Colors.grey.shade800, Colors.grey.shade900],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: readyToHarvestCount > 0 ? const Color(0xFFFFD700) : Colors.white12,
                width: 1.2,
              ),
              boxShadow: readyToHarvestCount > 0
                  ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🧺', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Thu hoạch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$readyToHarvestCount ô chín',
                      style: TextStyle(
                        color: readyToHarvestCount > 0 ? const Color(0xFFFFD700) : Colors.grey,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
