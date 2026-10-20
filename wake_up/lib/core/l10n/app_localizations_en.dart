// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wake Up';

  @override
  String get tabWorldClock => 'World';

  @override
  String get tabAlarm => 'Alarm';

  @override
  String get tabBedtime => 'Bedtime';

  @override
  String get tabGarden => 'Garden';

  @override
  String get tabAnalytics => 'Stats';

  @override
  String get alarmListTitle => 'Alarm';

  @override
  String get addAlarm => 'Add Alarm';

  @override
  String get editAlarm => 'Edit Alarm';

  @override
  String get deleteAlarm => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get label => 'Label';

  @override
  String get repeat => 'Repeat';

  @override
  String get snooze => 'Snooze';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String snoozeMaxTimes(int count) {
    return 'Max $count times';
  }

  @override
  String get wakeMode => 'Wake Mode';

  @override
  String get wakeModeNormal => 'Normal';

  @override
  String get wakeModeDeep => 'Deep';

  @override
  String get sound => 'Sound';

  @override
  String get stop => 'Stop';

  @override
  String get snoozeButton => 'Snooze';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get everyDay => 'Every day';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekends => 'Weekends';

  @override
  String get never => 'Never';

  @override
  String get noAlarms => 'No alarms';

  @override
  String alarmIn(int hours, int minutes) {
    return 'Alarm in ${hours}h ${minutes}m';
  }

  @override
  String get worldClockTitle => 'World Clock';

  @override
  String get bedtimeTitle => 'Bedtime';

  @override
  String get gardenTitle => 'Garden';

  @override
  String get analyticsTitle => 'Stats';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get permissionAlarmTitle => 'Exact Alarm Permission';

  @override
  String get permissionAlarmDesc =>
      'This app needs exact alarm permission to ring on time.';

  @override
  String get permissionNotificationTitle => 'Notification Permission';

  @override
  String get permissionNotificationDesc =>
      'This app needs notification permission to alert you when the alarm rings.';

  @override
  String get permissionBatteryTitle => 'Battery Optimization';

  @override
  String get permissionBatteryDesc =>
      'Please disable battery optimization for this app to ensure alarms work reliably.';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get iosUnsupportedTitle => 'Not Supported';

  @override
  String get iosUnsupportedDesc => 'Alarm feature requires iOS 26 or later.';
}
