import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/landing_page/landing_page.dart';
import 'package:paintroid/ui/pages/onboarding_page/onboarding_page.dart';
import 'package:paintroid/ui/pages/workspace_page/workspace_page.dart';
import 'package:paintroid/ui/shared/loading_overlay.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:colorpicker/colorpicker.dart';

class App extends StatelessWidget {
  final bool showOnboardingPage;
  final String? initialFileUri;

  App({super.key, required this.showOnboardingPage,this.initialFileUri});

  final _lightTheme = LightPaintroidThemeData();
  final _darkTheme = DarkPaintroidThemeData();

  @override
  Widget build(BuildContext context) {
    return PaintroidTheme(
      lightTheme: _lightTheme,
      darkTheme: _darkTheme,
      child: MaterialApp(
        title: 'Pocket Paint',
        theme: _lightTheme.materialThemeData,
        darkTheme: _darkTheme.materialThemeData,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ColorPickerLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales + ColorPickerLocalizations.supportedLocales,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => showOnboardingPage
                    ? const OnboardingPage(
                        navigateTo: LandingPage(title: 'Pocket Paint'),
                      )
                    :LandingPage(title: 'Pocket Paint',initialFileUri:initialFileUri),                   
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
                workspaceStateProvider.select(
                  (state) => state.isPerformingIOTask,
                ),
              ),
              child: child,
            );
          },
          child:  LandingPage(title: 'Pocket Paint',initialFileUri:initialFileUri),          
        ),
      ),
    );
  }
}
