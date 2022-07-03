import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/ui/pocket_paint.dart';

void main() {
  late String testTitle;
  late Widget sut;

  setUp(() {
    testTitle = "Test Title";
    sut = MaterialApp(
      home: PocketPaint(title: testTitle),
    );
  });

  testWidgets('Should have a top and bottom app bar', (tester) async {
    await tester.pumpWidget(sut);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('Should have the title in app bar', (tester) async {
    await tester.pumpWidget(sut);
    final titleFinder = find.widgetWithText(AppBar, testTitle);
    expect(titleFinder, findsOneWidget);
  });

  group('Fullscreen functionality', () {
    final enterFullscreenButtonFinder =
        find.widgetWithIcon(IconButton, Icons.fullscreen);
    final exitFullscreenButtonFinder =
        find.widgetWithIcon(IconButton, Icons.fullscreen_exit);

    testWidgets(
      'Should have a fullscreen button in AppBar',
      (tester) async {
        await tester.pumpWidget(sut);
        expect(enterFullscreenButtonFinder, findsOneWidget);
        final buttonAncestorFinder = find.ancestor(
          of: enterFullscreenButtonFinder,
          matching: find.byType(AppBar),
        );
        expect(buttonAncestorFinder, findsOneWidget);
      },
    );

    group('After going fullscreen', () {
      testWidgets(
        'Should hide top and bottom bar',
        (tester) async {
          await tester.pumpWidget(sut);
          final buttonFinder =
              find.widgetWithIcon(IconButton, Icons.fullscreen);
          await tester.tap(buttonFinder);
          await tester.pumpAndSettle();
          expect(find.byType(AppBar), findsNothing);
          expect(find.byType(NavigationBar), findsNothing);
        },
      );

      testWidgets(
        'Should have an exit fullscreen button',
        (tester) async {
          await tester.pumpWidget(sut);
          await tester.tap(enterFullscreenButtonFinder);
          await tester.pumpAndSettle();
          expect(exitFullscreenButtonFinder, findsOneWidget);
        },
      );
    });

    group('After exiting fullscreen', () {
      testWidgets(
        'Should show top and bottom bar',
        (tester) async {
          await tester.pumpWidget(sut);
          await tester.tap(enterFullscreenButtonFinder);
          await tester.pumpAndSettle();
          await tester.tap(exitFullscreenButtonFinder);
          await tester.pumpAndSettle();
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.byType(NavigationBar), findsOneWidget);
        },
      );
    });
  });
}
