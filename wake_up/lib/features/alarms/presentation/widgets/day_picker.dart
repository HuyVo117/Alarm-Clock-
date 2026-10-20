import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_theme.dart';

/// Widget chọn ngày lặp lại cho báo thức, giống iPhone.
class DayPicker extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;

  const DayPicker({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  static const _days = [
    (day: DateTime.monday, label: 'Mỗi Thứ Hai'),
    (day: DateTime.tuesday, label: 'Mỗi Thứ Ba'),
    (day: DateTime.wednesday, label: 'Mỗi Thứ Tư'),
    (day: DateTime.thursday, label: 'Mỗi Thứ Năm'),
    (day: DateTime.friday, label: 'Mỗi Thứ Sáu'),
    (day: DateTime.saturday, label: 'Mỗi Thứ Bảy'),
    (day: DateTime.sunday, label: 'Mỗi Chủ Nhật'),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: AppTheme.backgroundBlack,
      children: _days.map((entry) {
        final isSelected = selectedDays.contains(entry.day);
        return CupertinoListTile(
          backgroundColor: AppTheme.surfaceDark,
          title: Text(
            entry.label,
            style: const TextStyle(color: AppTheme.labelPrimary),
          ),
          trailing: isSelected
              ? const Icon(
                  CupertinoIcons.checkmark,
                  color: AppTheme.accentOrange,
                  size: 20,
                )
              : null,
          onTap: () {
            final newDays = List<int>.from(selectedDays);
            if (isSelected) {
              newDays.remove(entry.day);
            } else {
              newDays.add(entry.day);
            }
            onChanged(newDays);
          },
        );
      }).toList(),
    );
  }
}
