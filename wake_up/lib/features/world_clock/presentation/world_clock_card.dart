import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/world_city_model.dart';
import '../domain/world_clock_service.dart';

/// Card hiển thị từng thành phố trong Đồng hồ Thế giới, thiết kế chuẩn iOS Clock.
class WorldClockCard extends StatelessWidget {
  final WorldCityModel city;
  final WorldClockService service;
  final DateTime currentTime;
  final bool isEditing;
  final VoidCallback onDelete;

  const WorldClockCard({
    super.key,
    required this.city,
    required this.service,
    required this.currentTime,
    required this.isEditing,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tzTime = service.nowIn(city.timezoneId, currentTime.toUtc());

    final hourStr = tzTime.hour.toString().padLeft(2, '0');
    final minuteStr = tzTime.minute.toString().padLeft(2, '0');
    final timeStr = '$hourStr:$minuteStr';

    final isDay = service.isDaytime(city.timezoneId, currentTime.toUtc());
    final utcOffset = service.getUtcOffsetString(city.timezoneId, currentTime.toUtc());
    final relativeDesc = service.getRelativeDescription(
      city.timezoneId,
      baseUtc: currentTime.toUtc(),
      todayText: l10n.today,
      tomorrowText: l10n.tomorrow,
      yesterdayText: l10n.yesterday,
      sameTimeText: l10n.sameTime,
      hoursAheadSuffix: l10n.hoursAhead,
      hoursBehindSuffix: l10n.hoursBehind,
    );

    return Dismissible(
      key: ValueKey(city.id),
      direction: isEditing ? DismissDirection.none : DismissDirection.endToStart,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            // Nút xóa màu đỏ khi ở chế độ Edit
            if (isEditing) ...[
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: onDelete,
                child: const Icon(
                  CupertinoIcons.minus_circle_fill,
                  color: AppTheme.destructiveRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Cột thông tin thành phố bên trái
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tương quan ngày giờ (ví dụ: "Hôm nay, +2 giờ")
                  Text(
                    relativeDesc,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.labelSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Tên thành phố lớn
                  Text(
                    city.cityName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.labelPrimary,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Quốc gia & Offset UTC
                  Text(
                    '${city.countryName} • $utcOffset',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.labelTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Cột thời gian và biểu tượng Ngày/Đêm bên phải
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Biểu tượng ngày/đêm
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    isDay ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                    size: 20,
                    color: isDay ? const Color(0xFFFFD60A) : const Color(0xFF5E5CE6),
                  ),
                ),

                // Giờ địa phương dạng số lớn
                Text(
                  timeStr,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -1,
                    color: AppTheme.labelPrimary,
                    height: 1.0,
                  ),
                ),

                // Biểu tượng kéo thả khi đang edit
                if (isEditing) ...[
                  const SizedBox(width: 12),
                  const Icon(
                    CupertinoIcons.bars,
                    color: AppTheme.labelTertiary,
                    size: 22,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
