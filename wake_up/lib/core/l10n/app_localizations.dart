import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Wake Up'**
  String get appTitle;

  /// No description provided for @tabWorldClock.
  ///
  /// In vi, this message translates to:
  /// **'Thế giới'**
  String get tabWorldClock;

  /// No description provided for @tabAlarm.
  ///
  /// In vi, this message translates to:
  /// **'Báo thức'**
  String get tabAlarm;

  /// No description provided for @tabBedtime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ ngủ'**
  String get tabBedtime;

  /// No description provided for @tabGarden.
  ///
  /// In vi, this message translates to:
  /// **'Khu vườn'**
  String get tabGarden;

  /// No description provided for @tabAnalytics.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get tabAnalytics;

  /// No description provided for @alarmListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo thức'**
  String get alarmListTitle;

  /// No description provided for @addAlarm.
  ///
  /// In vi, this message translates to:
  /// **'Thêm báo thức'**
  String get addAlarm;

  /// No description provided for @editAlarm.
  ///
  /// In vi, this message translates to:
  /// **'Sửa báo thức'**
  String get editAlarm;

  /// No description provided for @deleteAlarm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get deleteAlarm;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get done;

  /// No description provided for @label.
  ///
  /// In vi, this message translates to:
  /// **'Nhãn'**
  String get label;

  /// No description provided for @repeat.
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại'**
  String get repeat;

  /// No description provided for @snooze.
  ///
  /// In vi, this message translates to:
  /// **'Báo lại'**
  String get snooze;

  /// No description provided for @snoozeMinutes.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String snoozeMinutes(int minutes);

  /// No description provided for @snoozeMaxTimes.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa {count} lần'**
  String snoozeMaxTimes(int count);

  /// No description provided for @wakeMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ đánh thức'**
  String get wakeMode;

  /// No description provided for @wakeModeNormal.
  ///
  /// In vi, this message translates to:
  /// **'Thường'**
  String get wakeModeNormal;

  /// No description provided for @wakeModeDeep.
  ///
  /// In vi, this message translates to:
  /// **'Sâu'**
  String get wakeModeDeep;

  /// No description provided for @sound.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh'**
  String get sound;

  /// No description provided for @stop.
  ///
  /// In vi, this message translates to:
  /// **'Dừng'**
  String get stop;

  /// No description provided for @snoozeButton.
  ///
  /// In vi, this message translates to:
  /// **'Báo lại'**
  String get snoozeButton;

  /// No description provided for @monday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 2'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 3'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 4'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 5'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 6'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 7'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In vi, this message translates to:
  /// **'Chủ nhật'**
  String get sunday;

  /// No description provided for @mondayShort.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get sundayShort;

  /// No description provided for @everyDay.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi ngày'**
  String get everyDay;

  /// No description provided for @weekdays.
  ///
  /// In vi, this message translates to:
  /// **'Các ngày trong tuần'**
  String get weekdays;

  /// No description provided for @weekends.
  ///
  /// In vi, this message translates to:
  /// **'Cuối tuần'**
  String get weekends;

  /// No description provided for @never.
  ///
  /// In vi, this message translates to:
  /// **'Không bao giờ'**
  String get never;

  /// No description provided for @noAlarms.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có báo thức'**
  String get noAlarms;

  /// No description provided for @alarmIn.
  ///
  /// In vi, this message translates to:
  /// **'Báo thức sau {hours}g {minutes}p'**
  String alarmIn(int hours, int minutes);

  /// No description provided for @worldClockTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thế giới'**
  String get worldClockTitle;

  /// No description provided for @bedtimeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giờ ngủ'**
  String get bedtimeTitle;

  /// No description provided for @gardenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khu vườn'**
  String get gardenTitle;

  /// No description provided for @analyticsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get analyticsTitle;

  /// No description provided for @comingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get comingSoon;

  /// No description provided for @permissionRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần cấp quyền'**
  String get permissionRequired;

  /// No description provided for @permissionAlarmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyền báo thức chính xác'**
  String get permissionAlarmTitle;

  /// No description provided for @permissionAlarmDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng cần quyền đặt báo thức chính xác để đảm bảo chuông reo đúng giờ.'**
  String get permissionAlarmDesc;

  /// No description provided for @permissionNotificationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyền thông báo'**
  String get permissionNotificationTitle;

  /// No description provided for @permissionNotificationDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng cần quyền gửi thông báo khi báo thức reo.'**
  String get permissionNotificationDesc;

  /// No description provided for @permissionBatteryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tối ưu pin'**
  String get permissionBatteryTitle;

  /// No description provided for @permissionBatteryDesc.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng tắt tối ưu pin cho ứng dụng để báo thức hoạt động ổn định.'**
  String get permissionBatteryDesc;

  /// No description provided for @grantPermission.
  ///
  /// In vi, this message translates to:
  /// **'Cấp quyền'**
  String get grantPermission;

  /// No description provided for @openSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở cài đặt'**
  String get openSettings;

  /// No description provided for @iosUnsupportedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa hỗ trợ'**
  String get iosUnsupportedTitle;

  /// No description provided for @iosUnsupportedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng báo thức yêu cầu iOS 26 trở lên.'**
  String get iosUnsupportedDesc;

  /// No description provided for @challengeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thử thách'**
  String get challengeTitle;

  /// No description provided for @challengeMath.
  ///
  /// In vi, this message translates to:
  /// **'Giải toán'**
  String get challengeMath;

  /// No description provided for @challengeShake.
  ///
  /// In vi, this message translates to:
  /// **'Lắc điện thoại'**
  String get challengeShake;

  /// No description provided for @challengeQr.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã QR'**
  String get challengeQr;

  /// No description provided for @challengeMathDesc.
  ///
  /// In vi, this message translates to:
  /// **'{count} câu toán'**
  String challengeMathDesc(int count);

  /// No description provided for @challengeShakeDesc.
  ///
  /// In vi, this message translates to:
  /// **'{count} lần lắc'**
  String challengeShakeDesc(int count);

  /// No description provided for @challengeQrDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã đã đăng ký'**
  String get challengeQrDesc;

  /// No description provided for @challengeSetup.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get challengeSetup;

  /// No description provided for @challengeDifficultyEasy.
  ///
  /// In vi, this message translates to:
  /// **'Dễ'**
  String get challengeDifficultyEasy;

  /// No description provided for @challengeDifficultyMedium.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get challengeDifficultyMedium;

  /// No description provided for @challengeDifficultyHard.
  ///
  /// In vi, this message translates to:
  /// **'Khó'**
  String get challengeDifficultyHard;

  /// No description provided for @challengeProgress.
  ///
  /// In vi, this message translates to:
  /// **'Thử thách {current}/{total}'**
  String challengeProgress(int current, int total);

  /// No description provided for @challengeQuestionProgress.
  ///
  /// In vi, this message translates to:
  /// **'Câu {current}/{total}'**
  String challengeQuestionProgress(int current, int total);

  /// No description provided for @challengeShakeProgress.
  ///
  /// In vi, this message translates to:
  /// **'{current}/{total} lần'**
  String challengeShakeProgress(int current, int total);

  /// No description provided for @challengeStartButton.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu thử thách'**
  String get challengeStartButton;

  /// No description provided for @challengeCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Đúng!'**
  String get challengeCorrect;

  /// No description provided for @challengeWrong.
  ///
  /// In vi, this message translates to:
  /// **'Sai, thử lại!'**
  String get challengeWrong;

  /// No description provided for @challengeShakeInstruction.
  ///
  /// In vi, this message translates to:
  /// **'Lắc điện thoại!'**
  String get challengeShakeInstruction;

  /// No description provided for @challengeQrInstruction.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã QR đã đăng ký'**
  String get challengeQrInstruction;

  /// No description provided for @challengeQrMatched.
  ///
  /// In vi, this message translates to:
  /// **'Mã khớp!'**
  String get challengeQrMatched;

  /// No description provided for @challengeQrNotMatched.
  ///
  /// In vi, this message translates to:
  /// **'Sai mã, thử mã khác'**
  String get challengeQrNotMatched;

  /// No description provided for @challengeCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành!'**
  String get challengeCompleted;

  /// No description provided for @challengeEmergencyExit.
  ///
  /// In vi, this message translates to:
  /// **'Thoát khẩn cấp'**
  String get challengeEmergencyExit;

  /// No description provided for @challengeEmergencyHold.
  ///
  /// In vi, this message translates to:
  /// **'Giữ {seconds} giây để thoát'**
  String challengeEmergencyHold(int seconds);

  /// No description provided for @challengeEmergencyConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận thoát khẩn cấp?'**
  String get challengeEmergencyConfirm;

  /// No description provided for @challengeEmergencyWarning.
  ///
  /// In vi, this message translates to:
  /// **'Báo thức sẽ được tắt mà không hoàn thành thử thách.'**
  String get challengeEmergencyWarning;

  /// No description provided for @challengeSelectAtLeastOne.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ít nhất 1 thử thách'**
  String get challengeSelectAtLeastOne;

  /// No description provided for @challengeQrSetupTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt mã QR'**
  String get challengeQrSetupTitle;

  /// No description provided for @challengeQrScanToAdd.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã QR để thêm'**
  String get challengeQrScanToAdd;

  /// No description provided for @challengeQrRegistered.
  ///
  /// In vi, this message translates to:
  /// **'{count} mã đã đăng ký'**
  String challengeQrRegistered(int count);

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @shakeTargetCount.
  ///
  /// In vi, this message translates to:
  /// **'Số lần lắc'**
  String get shakeTargetCount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
