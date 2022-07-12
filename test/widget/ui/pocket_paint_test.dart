import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/ui/overflow_menu.dart';
import 'package:paintroid/ui/pocket_paint.dart';
import 'package:paintroid/ui/top_app_bar.dart';
import 'package:paintroid/workspace/workspace.dart';

void main() {
  late Widget sut;

  setUp(() {
    sut = const ProviderScope(
      child: MaterialApp(
        home: PocketPaint(),
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
      final titleFinder = find.widgetWithText(TopAppBar, "Pocket Paint");
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

    setUp(() {
      testWorkspaceState = WorkspaceState.initial.copyWith(isFullscreen: true);
      sut = ProviderScope(
        overrides: [
          WorkspaceStateNotifier.provider
              .overrideWithValue(WorkspaceStateNotifier(testWorkspaceState))
        ],
        child: const MaterialApp(
          home: PocketPaint(),
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
