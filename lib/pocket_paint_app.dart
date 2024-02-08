import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:landing_page_screen/landing_page_screen.dart';
import 'package:onboarding_screen/onboarding_screen.dart';
import 'package:search_bar_screen/src/search_screen.dart';
import 'package:workspace_screen/workspace_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class PocketPaintApp extends StatelessWidget {
  final bool showOnboardingPage;

  const PocketPaintApp({Key? key, required this.showOnboardingPage})
      : super(key: key);

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
              builder: (context) => const WorkspaceScreen(),
            );
          case '/OnboardingPage':
            return MaterialPageRoute(
              builder: (context) => const OnboardingPage(),
            );
          case '/SearchScreenPage':
            return MaterialPageRoute(
              builder: (context) => const SearchScreen(),
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
