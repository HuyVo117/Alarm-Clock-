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

  @override
  String get challengeTitle => 'Challenge';

  @override
  String get challengeMath => 'Math';

  @override
  String get challengeShake => 'Shake Phone';

  @override
  String get challengeQr => 'Scan QR Code';

  @override
  String challengeMathDesc(int count) {
    return '$count questions';
  }

  @override
  String challengeShakeDesc(int count) {
    return '$count shakes';
  }

  @override
  String get challengeQrDesc => 'Scan registered code';

  @override
  String get challengeSetup => 'Setup';

  @override
  String get challengeDifficultyEasy => 'Easy';

  @override
  String get challengeDifficultyMedium => 'Medium';

  @override
  String get challengeDifficultyHard => 'Hard';

  @override
  String challengeProgress(int current, int total) {
    return 'Challenge $current/$total';
  }

  @override
  String challengeQuestionProgress(int current, int total) {
    return 'Q $current/$total';
  }

  @override
  String challengeShakeProgress(int current, int total) {
    return '$current/$total shakes';
  }

  @override
  String get challengeStartButton => 'Start Challenge';

  @override
  String get challengeCorrect => 'Correct!';

  @override
  String get challengeWrong => 'Wrong, try again!';

  @override
  String get challengeShakeInstruction => 'Shake your phone!';

  @override
  String get challengeQrInstruction => 'Scan the registered QR code';

  @override
  String get challengeQrMatched => 'Code matched!';

  @override
  String get challengeQrNotMatched => 'Wrong code, try another';

  @override
  String get challengeCompleted => 'Completed!';

  @override
  String get challengeEmergencyExit => 'Emergency Exit';

  @override
  String challengeEmergencyHold(int seconds) {
    return 'Hold for ${seconds}s to exit';
  }

  @override
  String get challengeEmergencyConfirm => 'Confirm emergency exit?';

  @override
  String get challengeEmergencyWarning =>
      'The alarm will be dismissed without completing the challenge.';

  @override
  String get challengeSelectAtLeastOne => 'Select at least 1 challenge';

  @override
  String get challengeQrSetupTitle => 'QR Code Setup';

  @override
  String get challengeQrScanToAdd => 'Scan a QR code to add';

  @override
  String challengeQrRegistered(int count) {
    return '$count codes registered';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get shakeTargetCount => 'Shake count';

  @override
  String get challengeSelfie => 'Mirror Selfie';

  @override
  String challengeSelfieDesc(int seconds) {
    return 'Look into mirror & open eyes for ${seconds}s';
  }

  @override
  String get challengePhoto => 'Out of Bed Photo';

  @override
  String get challengePhotoDesc => 'Match reference location photo';

  @override
  String get challengePhotoRegistered => 'Reference photo set';

  @override
  String get challengePhotoNotRegistered => 'Need reference photo';

  @override
  String get challengePhotoSetupTitle => 'Register Photo';

  @override
  String get addCity => 'Add City';

  @override
  String get searchCityPlaceholder => 'Search city or country';

  @override
  String get noSavedCities => 'No World Clocks';

  @override
  String get noSavedCitiesDesc =>
      'Tap the + button in the top right to add a city';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get sameTime => 'same time';

  @override
  String get hoursAhead => 'HRS';

  @override
  String get hoursBehind => 'HRS';

  @override
  String get cityAlreadyAdded => 'City already added';

  @override
  String get editList => 'Edit';

  @override
  String get doneEditing => 'Done';

  @override
  String get currentLocalTime => 'Local Time';
}
