import 'dart:developer' as dev;

import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/world_clock/domain/world_clock_service.dart';

void main() async {
  dev.log('>>> [STARTUP] main() started');
  WidgetsFlutterBinding.ensureInitialized();
  dev.log('>>> [STARTUP] WidgetsFlutterBinding initialized');

  WorldClockService.initialize();

  try {
    dev.log('>>> [STARTUP] Calling Alarm.init()...');
    await Alarm.init();
    dev.log('>>> [STARTUP] Alarm.init() completed successfully');
  } catch (e, st) {
    dev.log('>>> [STARTUP] Alarm.init() error: $e\n$st');
  }

  dev.log('>>> [STARTUP] Calling runApp...');
  runApp(
    const ProviderScope(
      child: WakeUpApp(),
    ),
  );
  dev.log('>>> [STARTUP] runApp called');
}
