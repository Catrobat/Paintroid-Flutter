import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:landing_page_screen/landing_page_screen.dart';
import 'package:onboarding_screen/onboarding_screen.dart';
import 'package:workspace_screen/workspace_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class PocketPaintApp extends ConsumerWidget {
  final bool showOnboardingPage;

  PocketPaintApp({Key? key, required this.showOnboardingPage})
      : super(key: key);

  final _lightTheme = LightPaintroidThemeData();
  final _darkTheme = DarkPaintroidThemeData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeState = ref.watch(themeModeNotifierProvider);

    return PaintroidTheme(
      lightTheme: _lightTheme,
      darkTheme: _darkTheme,
      child: MaterialApp(
        theme: _lightTheme.materialThemeData,
        darkTheme: _darkTheme.materialThemeData,
        themeMode: themeModeState.themeMode,
        title: 'Pocket Paint',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
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
              child: child,
            );
          },
          child: const LandingPage(title: 'Pocket Paint'),
        ),
      ),
    );
  }
}
