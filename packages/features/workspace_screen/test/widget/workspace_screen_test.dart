// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:command/command.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

// Project imports:
import 'package:workspace_screen/workspace_screen.dart';

class FakeCommandManager extends Fake implements CommandManager {}

void main() {
  late Widget sut;

  setUp(() {
    sut = const ProviderScope(
      child: MaterialApp(
        home: WorkspaceScreen(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
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
    late FakeCommandManager fakeCommandManager;

    setUp(() {
      testWorkspaceState = WorkspaceState.initial.copyWith(isFullscreen: true);
      fakeCommandManager = FakeCommandManager();
      sut = ProviderScope(
        overrides: [
          WorkspaceState.provider.overrideWith((ref) =>
              WorkspaceStateNotifier(testWorkspaceState, fakeCommandManager))
        ],
        child: const MaterialApp(
          home: WorkspaceScreen(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
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
