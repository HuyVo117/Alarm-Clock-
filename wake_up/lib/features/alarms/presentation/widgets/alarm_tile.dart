import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/alarm_model.dart';

/// Widget hiển thị một báo thức trong danh sách, giống iPhone.
class AlarmTile extends StatelessWidget {
  final AlarmModel alarm;
  final bool isEditing;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AlarmTile({
    super.key,
    required this.alarm,
    required this.isEditing,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = _formatTime(alarm.time);
    final periodStr = alarm.time.hour >= 12 ? 'CH' : 'SA'; // Chiều/Sáng
    final repeatStr = _formatRepeatDays(alarm.repeatDays);

    return Dismissible(
      key: ValueKey(alarm.id),
      direction:
          isEditing ? DismissDirection.none : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.destructiveRed,
        child: const Icon(
          CupertinoIcons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.separatorColor,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Nút xóa khi đang edit
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      CupertinoIcons.minus_circle_fill,
                      color: AppTheme.destructiveRed,
                      size: 22,
                    ),
                  ),
                ),

              // Giờ và thông tin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w200,
                            letterSpacing: -1,
                            color: alarm.enabled
                                ? AppTheme.labelPrimary
                                : AppTheme.labelTertiary,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          periodStr,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w200,
                            color: alarm.enabled
                                ? AppTheme.labelPrimary
                                : AppTheme.labelTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (alarm.label.isNotEmpty) ...[
                          Text(
                            alarm.label,
                            style: TextStyle(
                              fontSize: 14,
                              color: alarm.enabled
                                  ? AppTheme.labelSecondary
                                  : AppTheme.labelTertiary,
                            ),
                          ),
                          if (repeatStr.isNotEmpty)
                            Text(
                              ', ',
                              style: TextStyle(
                                fontSize: 14,
                                color: alarm.enabled
                                    ? AppTheme.labelSecondary
                                    : AppTheme.labelTertiary,
                              ),
                            ),
                        ],
                        if (repeatStr.isNotEmpty)
                          Text(
                            repeatStr,
                            style: TextStyle(
                              fontSize: 14,
                              color: alarm.enabled
                                  ? AppTheme.labelSecondary
                                  : AppTheme.labelTertiary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Công tắc bật/tắt
              if (!isEditing)
                CupertinoSwitch(
                  value: alarm.enabled,
                  activeTrackColor: AppTheme.successGreen,
                  onChanged: onToggle,
                ),

              // Mũi tên khi đang edit
              if (isEditing)
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: AppTheme.labelTertiary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatRepeatDays(List<int> days) {
    if (days.isEmpty) return '';
    if (days.length == 7) return 'Mỗi ngày';

    final weekdays = [1, 2, 3, 4, 5];
    final weekends = [6, 7];

    if (days.length == 5 &&
        days.every((d) => weekdays.contains(d))) {
      return 'Các ngày trong tuần';
    }
    if (days.length == 2 &&
        days.every((d) => weekends.contains(d))) {
      return 'Cuối tuần';
    }

    const dayNames = {
      1: 'T2',
      2: 'T3',
      3: 'T4',
      4: 'T5',
      5: 'T6',
      6: 'T7',
      7: 'CN',
    };

    final sorted = List<int>.from(days)..sort();
    return sorted.map((d) => dayNames[d] ?? '').join(' ');
  }
}
