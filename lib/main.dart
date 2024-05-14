// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:paintroid/app.dart';

void main() async {
  Logger.root.onRecord.listen((record) {
    log(record.message,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace);
  });

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(
    ProviderScope(
      child: App(
        showOnboardingPage: showOnboarding,
      ),
    ),
  );
}
