import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();

  runApp(
    const ProviderScope(
      child: WakeUpApp(),
    ),
  );
}
