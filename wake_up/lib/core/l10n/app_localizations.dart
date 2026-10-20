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
