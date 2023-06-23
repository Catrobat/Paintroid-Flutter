import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paintroid/ui/color_schemes.dart';
import 'package:paintroid/ui/landing_page/landing_page.dart';
import 'package:paintroid/ui/onboarding/onboarding_page.dart';
import 'package:paintroid/ui/pocket_paint.dart';
import 'package:paintroid/ui/shared/loading_overlay.dart';
import 'package:paintroid/workspace/workspace.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      child: PocketPaintApp(
        showOnboardingPage: showOnboarding,
      ),
    ),
  );
}

class PocketPaintApp extends StatelessWidget {
  final bool showOnboardingPage;

  const PocketPaintApp({Key? key, required this.showOnboardingPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return LoadingOverlay(
          isLoading: ref.watch(
            WorkspaceState.provider.select(
              (state) => state.isPerformingIOTask,
            ),
          ),
          child: child,
        );
      },
      child: MaterialApp(
        title: 'Pocket Paint',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => showOnboardingPage
                    ? const OnboardingPage(
                        navigateTo: LandingPage(title: 'Pocket Paint'),
                      )
                    : const LandingPage(title: 'Pocket Paint'),
              );
            case '/PocketPaint':
              return MaterialPageRoute(
                builder: (context) => const PocketPaint(),
              );
            case '/OnboardingPage':
              return MaterialPageRoute(
                builder: (context) => const OnboardingPage(),
              );
          }
          return null;
        },
      ),
    );
  }
}
