import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:paintroid/app.dart';

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
  const platform = MethodChannel('org.catrobat.paintroid/file_handler');
  String? initialFileUri;

  try {
    initialFileUri = await platform.invokeMethod('getInitialFile');
  } on PlatformException catch (e) {
    log("Failed to get initial file: '${e.message}'.");
  }

  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(ProviderScope(child: App(showOnboardingPage: showOnboarding,initialFileUri: initialFileUri)));
}
