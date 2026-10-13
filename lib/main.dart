import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saydaliati/app/app.dart';
import 'package:saydaliati/app/di/app_bootstrap.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    const options = WindowOptions(
      size: Size(1366, 768),
      minimumSize: Size(1280, 720),
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(AppBootstrap.wrap(const SaydaliatiApp()));
}
