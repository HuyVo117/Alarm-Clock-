import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

/// Bộ chọn giờ phong cách Samsung Clock (One UI).
/// Bố cục 3 cột rộng rãi: Buổi (SA/CH) | Giờ (1-12) | Phút (00-59),
/// số trung tâm lớn nổi bật trong thanh highlight, cuộn vòng mượt mà và rung haptic.
class SamsungTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  const SamsungTimePicker({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  });

  @override
  State<SamsungTimePicker> createState() => _SamsungTimePickerState();
}

class _SamsungTimePickerState extends State<SamsungTimePicker> {
  late FixedExtentScrollController _periodController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  late bool _isPm;
  late int _hour12; // 1 -> 12
  late int _minute; // 0 -> 59

  static const double _itemExtent = 48.0;

  @override
  void initState() {
    super.initState();
    final hour24 = widget.initialDateTime.hour;
    _minute = widget.initialDateTime.minute;
    _isPm = hour24 >= 12;
    _hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

    _periodController = FixedExtentScrollController(initialItem: _isPm ? 1 : 0);
    // Offset lớn để tạo cảm giác cuộn vô hạn cho giờ và phút
    _hourController = FixedExtentScrollController(initialItem: 1200 + (_hour12 - 1));
    _minuteController = FixedExtentScrollController(initialItem: 6000 + _minute);
  }

  @override
  void dispose() {
    _periodController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    HapticFeedback.selectionClick();
    int hour24;
    if (_isPm) {
      hour24 = _hour12 == 12 ? 12 : _hour12 + 12;
    } else {
      hour24 = _hour12 == 12 ? 0 : _hour12;
    }

    final now = widget.initialDateTime;
    final newDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour24,
      _minute,
    );
    widget.onDateTimeChanged(newDateTime);
  }

  String _calcRemainingTime() {
    final now = DateTime.now();
    int hour24;
    if (_isPm) {
      hour24 = _hour12 == 12 ? 12 : _hour12 + 12;
    } else {
      hour24 = _hour12 == 12 ? 0 : _hour12;
    }

    var target = DateTime(now.year, now.month, now.day, hour24, _minute);
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    final diff = target.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours == 0 && minutes == 0) {
      return 'Báo thức trong vòng chưa đầy 1 phút';
    } else if (hours == 0) {
      return 'Báo thức sau $minutes phút';
    } else if (minutes == 0) {
      return 'Báo thức sau $hours giờ';
    } else {
      return 'Báo thức sau $hours giờ $minutes phút';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gợi ý thời gian reo theo thời gian thực (giống Samsung Clock)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _calcRemainingTime(),
            style: const TextStyle(
              color: AppTheme.accentOrange,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Vùng con lăn chính
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thanh highlight trung tâm kiểu Samsung One UI
              Container(
                height: _itemExtent,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDarkElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.separatorColor,
                    width: 1,
                  ),
                ),
              ),

              // 3 cột cuộn
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // Cột Buổi: SA / CH
                    Expanded(
                      flex: 3,
                      child: CupertinoPicker(
                        scrollController: _periodController,
                        itemExtent: _itemExtent,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _isPm = index == 1;
                          });
                          _notifyChange();
                        },
                        children: [
                          Center(
                            child: Text(
                              'SA',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: !_isPm ? FontWeight.w700 : FontWeight.w400,
                                color: !_isPm ? AppTheme.accentOrange : AppTheme.labelTertiary,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'CH',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: _isPm ? FontWeight.w700 : FontWeight.w400,
                                color: _isPm ? AppTheme.accentOrange : AppTheme.labelTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cột Giờ (1 -> 12)
                    Expanded(
                      flex: 4,
                      child: CupertinoPicker.builder(
                        scrollController: _hourController,
                        itemExtent: _itemExtent,
                        selectionOverlay: const SizedBox.shrink(),
                        childCount: null, // Vòng lặp vô hạn
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _hour12 = (index % 12) + 1;
                          });
                          _notifyChange();
                        },
                        itemBuilder: (context, index) {
                          final hour = (index % 12) + 1;
                          final isSelected = hour == _hour12;
                          return Center(
                            child: Text(
                              hour.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: isSelected ? 34 : 22,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                color: isSelected ? AppTheme.labelPrimary : AppTheme.labelTertiary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Dấu hai chấm ngăn cách
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.labelSecondary,
                        ),
                      ),
                    ),

                    // Cột Phút (00 -> 59)
                    Expanded(
                      flex: 4,
                      child: CupertinoPicker.builder(
                        scrollController: _minuteController,
                        itemExtent: _itemExtent,
                        selectionOverlay: const SizedBox.shrink(),
                        childCount: null, // Vòng lặp vô hạn
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _minute = index % 60;
                          });
                          _notifyChange();
                        },
                        itemBuilder: (context, index) {
                          final minute = index % 60;
                          final isSelected = minute == _minute;
                          return Center(
                            child: Text(
                              minute.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: isSelected ? 34 : 22,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                color: isSelected ? AppTheme.labelPrimary : AppTheme.labelTertiary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
