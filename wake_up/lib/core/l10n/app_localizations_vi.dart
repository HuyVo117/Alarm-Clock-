// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Wake Up';

  @override
  String get tabWorldClock => 'Thế giới';

  @override
  String get tabAlarm => 'Báo thức';

  @override
  String get tabBedtime => 'Giờ ngủ';

  @override
  String get tabGarden => 'Khu vườn';

  @override
  String get tabAnalytics => 'Thống kê';

  @override
  String get alarmListTitle => 'Báo thức';

  @override
  String get addAlarm => 'Thêm báo thức';

  @override
  String get editAlarm => 'Sửa báo thức';

  @override
  String get deleteAlarm => 'Xóa';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get edit => 'Sửa';

  @override
  String get done => 'Xong';

  @override
  String get label => 'Nhãn';

  @override
  String get repeat => 'Lặp lại';

  @override
  String get snooze => 'Báo lại';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String snoozeMaxTimes(int count) {
    return 'Tối đa $count lần';
  }

  @override
  String get wakeMode => 'Chế độ đánh thức';

  @override
  String get wakeModeNormal => 'Thường';

  @override
  String get wakeModeDeep => 'Sâu';

  @override
  String get sound => 'Âm thanh';

  @override
  String get stop => 'Dừng';

  @override
  String get snoozeButton => 'Báo lại';

  @override
  String get monday => 'Thứ 2';

  @override
  String get tuesday => 'Thứ 3';

  @override
  String get wednesday => 'Thứ 4';

  @override
  String get thursday => 'Thứ 5';

  @override
  String get friday => 'Thứ 6';

  @override
  String get saturday => 'Thứ 7';

  @override
  String get sunday => 'Chủ nhật';

  @override
  String get mondayShort => 'T2';

  @override
  String get tuesdayShort => 'T3';

  @override
  String get wednesdayShort => 'T4';

  @override
  String get thursdayShort => 'T5';

  @override
  String get fridayShort => 'T6';

  @override
  String get saturdayShort => 'T7';

  @override
  String get sundayShort => 'CN';

  @override
  String get everyDay => 'Mỗi ngày';

  @override
  String get weekdays => 'Các ngày trong tuần';

  @override
  String get weekends => 'Cuối tuần';

  @override
  String get never => 'Không bao giờ';

  @override
  String get noAlarms => 'Chưa có báo thức';

  @override
  String alarmIn(int hours, int minutes) {
    return 'Báo thức sau ${hours}g ${minutes}p';
  }

  @override
  String get worldClockTitle => 'Thế giới';

  @override
  String get bedtimeTitle => 'Giờ ngủ';

  @override
  String get gardenTitle => 'Khu vườn';

  @override
  String get analyticsTitle => 'Thống kê';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get permissionRequired => 'Cần cấp quyền';

  @override
  String get permissionAlarmTitle => 'Quyền báo thức chính xác';

  @override
  String get permissionAlarmDesc =>
      'Ứng dụng cần quyền đặt báo thức chính xác để đảm bảo chuông reo đúng giờ.';

  @override
  String get permissionNotificationTitle => 'Quyền thông báo';

  @override
  String get permissionNotificationDesc =>
      'Ứng dụng cần quyền gửi thông báo khi báo thức reo.';

  @override
  String get permissionBatteryTitle => 'Tối ưu pin';

  @override
  String get permissionBatteryDesc =>
      'Vui lòng tắt tối ưu pin cho ứng dụng để báo thức hoạt động ổn định.';

  @override
  String get grantPermission => 'Cấp quyền';

  @override
  String get openSettings => 'Mở cài đặt';

  @override
  String get iosUnsupportedTitle => 'Chưa hỗ trợ';

  @override
  String get iosUnsupportedDesc => 'Tính năng báo thức yêu cầu iOS 26 trở lên.';
}
