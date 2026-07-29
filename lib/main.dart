import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:paintroid/app.dart';
import 'package:paintroid/core/providers/object/device_service.dart';

void main() async {
  Logger.root.onRecord.listen(
    (record) {
      log(
        record.message,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    },
  );

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  const platform = MethodChannel('org.catrobat.paintroid/file_handler');
  String? initialFileUri;

  try {
    initialFileUri = await platform.invokeMethod('getInitialFile');
  } on MissingPluginException {
    // file_handler channel is Android-only; no-op on iOS.
  } on PlatformException catch (e) {
    log("Failed to get initial file: '${e.message}'.");
  }

  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;
  final deviceSize = await DeviceService.getSizeInPixels();

  runApp(ProviderScope(
    overrides: [
      IDeviceService.sizeProvider.overrideWithValue(deviceSize),
    ],
    child: App(showOnboardingPage: showOnboarding, initialFileUri: initialFileUri),
  ));
}
