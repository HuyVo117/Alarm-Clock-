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

  @override
  String get challengeTitle => 'Thử thách';

  @override
  String get challengeMath => 'Giải toán';

  @override
  String get challengeShake => 'Lắc điện thoại';

  @override
  String get challengeQr => 'Quét mã QR';

  @override
  String challengeMathDesc(int count) {
    return '$count câu toán';
  }

  @override
  String challengeShakeDesc(int count) {
    return '$count lần lắc';
  }

  @override
  String get challengeQrDesc => 'Quét mã đã đăng ký';

  @override
  String get challengeSetup => 'Cài đặt';

  @override
  String get challengeDifficultyEasy => 'Dễ';

  @override
  String get challengeDifficultyMedium => 'Trung bình';

  @override
  String get challengeDifficultyHard => 'Khó';

  @override
  String challengeProgress(int current, int total) {
    return 'Thử thách $current/$total';
  }

  @override
  String challengeQuestionProgress(int current, int total) {
    return 'Câu $current/$total';
  }

  @override
  String challengeShakeProgress(int current, int total) {
    return '$current/$total lần';
  }

  @override
  String get challengeStartButton => 'Bắt đầu thử thách';

  @override
  String get challengeCorrect => 'Đúng!';

  @override
  String get challengeWrong => 'Sai, thử lại!';

  @override
  String get challengeShakeInstruction => 'Lắc điện thoại!';

  @override
  String get challengeQrInstruction => 'Quét mã QR đã đăng ký';

  @override
  String get challengeQrMatched => 'Mã khớp!';

  @override
  String get challengeQrNotMatched => 'Sai mã, thử mã khác';

  @override
  String get challengeCompleted => 'Hoàn thành!';

  @override
  String get challengeEmergencyExit => 'Thoát khẩn cấp';

  @override
  String challengeEmergencyHold(int seconds) {
    return 'Giữ $seconds giây để thoát';
  }

  @override
  String get challengeEmergencyConfirm => 'Xác nhận thoát khẩn cấp?';

  @override
  String get challengeEmergencyWarning =>
      'Báo thức sẽ được tắt mà không hoàn thành thử thách.';

  @override
  String get challengeSelectAtLeastOne => 'Chọn ít nhất 1 thử thách';

  @override
  String get challengeQrSetupTitle => 'Cài đặt mã QR';

  @override
  String get challengeQrScanToAdd => 'Quét mã QR để thêm';

  @override
  String challengeQrRegistered(int count) {
    return '$count mã đã đăng ký';
  }

  @override
  String get confirm => 'Xác nhận';

  @override
  String get shakeTargetCount => 'Số lần lắc';

  @override
  String get challengeSelfie => 'Selfie trước gương';

  @override
  String challengeSelfieDesc(int seconds) {
    return 'Soi gương và mở mắt ${seconds}s';
  }

  @override
  String get challengePhoto => 'Chụp ảnh rời giường';

  @override
  String get challengePhotoDesc => 'Chụp ảnh vị trí tham chiếu';

  @override
  String get challengePhotoRegistered => 'Đã có ảnh mẫu';

  @override
  String get challengePhotoNotRegistered => 'Cần chụp ảnh mẫu';

  @override
  String get challengePhotoSetupTitle => 'Đăng ký ảnh mẫu';

  @override
  String get addCity => 'Thêm thành phố';

  @override
  String get searchCityPlaceholder => 'Tìm kiếm thành phố hoặc quốc gia';

  @override
  String get noSavedCities => 'Chưa có thành phố nào';

  @override
  String get noSavedCitiesDesc =>
      'Nhấn nút + ở góc trên bên phải để thêm đồng hồ thế giới';

  @override
  String get today => 'Hôm nay';

  @override
  String get tomorrow => 'Ngày mai';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get sameTime => 'cùng giờ';

  @override
  String get hoursAhead => 'giờ';

  @override
  String get hoursBehind => 'giờ';

  @override
  String get cityAlreadyAdded => 'Đã thêm thành phố này';

  @override
  String get editList => 'Sửa';

  @override
  String get doneEditing => 'Xong';

  @override
  String get currentLocalTime => 'Giờ địa phương';
}
