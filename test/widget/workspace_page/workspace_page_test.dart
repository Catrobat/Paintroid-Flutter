// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/top_app_bar.dart';
import 'package:paintroid/ui/pages/workspace_page/workspace_page.dart';
import 'package:paintroid/ui/theme/theme.dart';

void main() {
  late Widget sut;

  setUp(() {
    final lightTheme = LightPaintroidThemeData();
    final darkTheme = DarkPaintroidThemeData();

    sut = ProviderScope(
      child: PaintroidTheme(
        lightTheme: lightTheme,
        darkTheme: darkTheme,
        child: MaterialApp(
          theme: lightTheme.materialThemeData,
          darkTheme: darkTheme.materialThemeData,
          home: const WorkspacePage(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
        ),
      ),
    );
  });

  testWidgets('Should have a top and bottom app bar', (tester) async {
    await tester.pumpWidget(sut);
    expect(find.byType(TopAppBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets(
    'Should have the title "Pocket Paint" in app bar',
    (tester) async {
      await tester.pumpWidget(sut);
      final titleFinder = find.widgetWithText(TopAppBar, 'Pocket Paint');
      expect(titleFinder, findsOneWidget);
    },
  );

  testWidgets('Should an overflow menu button in app bar', (tester) async {
    await tester.pumpWidget(sut);
    final overflowMenuButtonFinder = find.widgetWithIcon(
      PopupMenuButton<OverflowMenuOption>,
      Icons.more_vert,
    );
    expect(overflowMenuButtonFinder, findsOneWidget);
  });

  group('Fullscreen functionality', () {
    late WorkspaceState testWorkspaceState;
    late ICommandManager commandManager;

    setUp(() {
      testWorkspaceState = WorkspaceState.initial.copyWith(isFullscreen: true);
      commandManager = CommandManager();

      final lightTheme = LightPaintroidThemeData();
      final darkTheme = DarkPaintroidThemeData();

      sut = ProviderScope(
        overrides: [
          WorkspaceState.provider.overrideWith((ref) =>
              WorkspaceStateNotifier(testWorkspaceState, commandManager))
        ],
        child: PaintroidTheme(
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          child: MaterialApp(
            theme: lightTheme.materialThemeData,
            darkTheme: darkTheme.materialThemeData,
            home: const WorkspacePage(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
          ),
        ),
      );
    });

    final exitFullscreenButtonFinder =
        find.widgetWithIcon(IconButton, Icons.fullscreen_exit);

    group('After going fullscreen', () {
      testWidgets(
        'Should hide top and bottom bar',
        (tester) async {
          await tester.pumpWidget(sut);
          expect(find.byType(TopAppBar), findsNothing);
          expect(find.byType(NavigationBar), findsNothing);
        },
      );

      testWidgets(
        'Should have an exit fullscreen button',
        (tester) async {
          await tester.pumpWidget(sut);
          expect(exitFullscreenButtonFinder, findsOneWidget);
        },
      );
    });

    group('After exiting fullscreen', () {
      testWidgets(
        'Should show top and bottom bar',
        (tester) async {
          await tester.pumpWidget(sut);
          await tester.tap(exitFullscreenButtonFinder);
          await tester.pumpAndSettle();
          expect(find.byType(TopAppBar), findsOneWidget);
          expect(find.byType(NavigationBar), findsOneWidget);
        },
      );
    });
  });
}
