// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// Project imports:
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final uiInteraction = UIInteraction();

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  group('[TOP_APP_BAR]: BrushTool', () {
    testWidgets('Show undo / redo but no plus / checkmark button in brush tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.BRUSH.name);

      expect(WidgetFinder.plusButton, findsNothing);
      expect(WidgetFinder.checkMark, findsNothing);
      expect(WidgetFinder.undoButton, findsOneWidget);
      expect(WidgetFinder.redoButton, findsOneWidget);
    });

    testWidgets('Undo / redo are disabled before drawing with brush tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.BRUSH.name);

      final IconButton undoButton =
          tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      final IconButton redoButton =
          tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);
    });

    testWidgets(
        'Undo is enabled & Redo is disabled after drawing with brush tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.BRUSH.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);

      await uiInteraction.tapAt(CanvasPosition.center);

      undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, isNotNull);
      expect(redoButton.onPressed, null);
    });

    testWidgets(
        'Undo is disabled & Redo is enabled after drawing with brush tool was undone',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.BRUSH.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);

      await uiInteraction.tapAt(CanvasPosition.center);

      await uiInteraction.clickUndo();

      undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, isNotNull);
    });
  });

  group('[TOP_APP_BAR]: LineTool', () {
    testWidgets('Show undo / redo and plus / checkmark button in line tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.LINE.name);

      expect(WidgetFinder.plusButton, findsOneWidget);
      expect(WidgetFinder.checkMark, findsOneWidget);
      expect(WidgetFinder.undoButton, findsOneWidget);
      expect(WidgetFinder.redoButton, findsOneWidget);
    });

    testWidgets(
        'Undo / redo and plus / checkmark are disabled before drawing with line tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.LINE.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      var plusButton = tester.firstWidget<IconButton>(WidgetFinder.plusButton);
      var checkMark = tester.firstWidget<IconButton>(WidgetFinder.checkMark);

      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);
      expect(plusButton.onPressed, null);
      expect(checkMark.onPressed, null);
    });

    testWidgets('Undo is enabled after drawing with line tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.LINE.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      expect(undoButton.onPressed, null);

      await uiInteraction.tapAt(CanvasPosition.center);
      undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      expect(undoButton.onPressed, isNotNull);
    });

    testWidgets('Redo is enabled after drawing with line tool was undone',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.LINE.name);

      await uiInteraction.tapAt(CanvasPosition.center);

      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(redoButton.onPressed, null);

      await uiInteraction.clickUndo();

      redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);

      expect(redoButton.onPressed, isNotNull);
    });
  });

  testWidgets(
      '[TOP_APP_BAR]: Show undo / redo but no plus / checkmark button in eraser tool',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();

    await uiInteraction.selectTool(ToolData.ERASER.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);
    expect(WidgetFinder.undoButton, findsOneWidget);
    expect(WidgetFinder.redoButton, findsOneWidget);
  });

  testWidgets(
      '[TOP_APP_BAR]: Show no undo / redo and no plus / checkmark button in hand tool',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();

    await uiInteraction.selectTool(ToolData.HAND.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);
    expect(WidgetFinder.undoButton, findsNothing);
    expect(WidgetFinder.redoButton, findsNothing);
  });
}

// redo is disabled after click resetted
