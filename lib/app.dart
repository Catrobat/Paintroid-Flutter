// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/landing_page/landing_page.dart';
import 'package:paintroid/ui/pages/onboarding_page/onboarding_page.dart';
import 'package:paintroid/ui/pages/workspace_page/workspace_page.dart';
import 'package:paintroid/ui/shared/loading_overlay.dart';
import 'package:paintroid/ui/themes/color_schemes.dart';

class App extends StatelessWidget {
  final bool showOnboardingPage;

  const App({super.key, required this.showOnboardingPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Paint',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
              builder: (context) => const WorkspacePage(),
            );
          case '/OnboardingPage':
            return MaterialPageRoute(
              builder: (context) => const OnboardingPage(),
            );
        }
        return null;
      },
      home: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return LoadingOverlay(
              isLoading: ref.watch(
                WorkspaceState.provider
                    .select((state) => state.isPerformingIOTask),
              ),
              child: child);
        },
        child: const LandingPage(title: 'Pocket Paint'),
      ),
    );
  }
}
