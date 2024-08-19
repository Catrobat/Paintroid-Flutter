import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.BRUSH.name);

      expect(WidgetFinder.plusButton, findsNothing);
      expect(WidgetFinder.checkMark, findsNothing);
      expect(WidgetFinder.undoButton, findsOneWidget);
      expect(WidgetFinder.redoButton, findsOneWidget);
    });

    testWidgets('Undo / redo are disabled before drawing with brush tool',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.BRUSH.name);

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
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.BRUSH.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);

      await UIInteraction.tapAt(CanvasPosition.center);

      undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, isNotNull);
      expect(redoButton.onPressed, null);
    });

    testWidgets(
        'Undo is disabled & Redo is enabled after drawing with brush tool was undone',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.BRUSH.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.clickUndo();

      undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, isNotNull);
    });
  });

  group('[TOP_APP_BAR]: LineTool', () {
    testWidgets('Show undo / redo and plus / checkmark button',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.LINE.name);

      expect(WidgetFinder.plusButton, findsOneWidget);
      expect(WidgetFinder.checkMark, findsOneWidget);
      expect(WidgetFinder.undoButton, findsOneWidget);
      expect(WidgetFinder.redoButton, findsOneWidget);
    });

    testWidgets('Undo / redo and plus / checkmark are disabled before drawing',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.LINE.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      var plusButton = tester.firstWidget<IconButton>(WidgetFinder.plusButton);
      var checkMark = tester.firstWidget<IconButton>(WidgetFinder.checkMark);

      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);
      expect(plusButton.onPressed, null);
      expect(checkMark.onPressed, null);
    });

    testWidgets('Plus / checkmark are disabled after clicking checkmark',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.LINE.name);

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.tapAt(CanvasPosition.topCenter);

      var checkMark = tester.firstWidget<IconButton>(WidgetFinder.checkMark);
      var plus = tester.firstWidget<IconButton>(WidgetFinder.plusButton);
      expect(checkMark.onPressed, isNotNull);
      expect(plus.onPressed, isNotNull);

      await UIInteraction.clickCheckmark();

      checkMark = tester.firstWidget<IconButton>(WidgetFinder.checkMark);
      plus = tester.firstWidget<IconButton>(WidgetFinder.plusButton);
      expect(checkMark.onPressed, null);
      expect(plus.onPressed, null);
    });

    testWidgets('Undo is enabled after drawing', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.LINE.name);

      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      expect(undoButton.onPressed, null);

      await UIInteraction.tapAt(CanvasPosition.center);
      undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      expect(undoButton.onPressed, isNotNull);
    });

    testWidgets('Redo is enabled after drawing was undone',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.LINE.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(redoButton.onPressed, null);

      await UIInteraction.clickUndo();

      redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);

      expect(redoButton.onPressed, isNotNull);
    });
  });

  group('[TOP_APP_BAR]: EraserTool', () {
    testWidgets('Show undo / redo but no plus / checkmark button',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.ERASER.name);

      expect(WidgetFinder.plusButton, findsNothing);
      expect(WidgetFinder.checkMark, findsNothing);
      expect(WidgetFinder.undoButton, findsOneWidget);
      expect(WidgetFinder.redoButton, findsOneWidget);
    });
  });

  group('[TOP_APP_BAR]: HandTool', () {
    testWidgets('Show undo / redo but no plus / checkmark button',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.HAND.name);

      expect(WidgetFinder.plusButton, findsNothing);
      expect(WidgetFinder.checkMark, findsNothing);
      expect(WidgetFinder.undoButton, findsOneWidget);
      expect(WidgetFinder.redoButton, findsOneWidget);
    });
  });

  group('[TOP_APP_BAR]: ShapesTool', () {
    testWidgets('Show undo / redo and checkmark but no plus button',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      expect(WidgetFinder.plusButton, findsNothing);
      expect(WidgetFinder.checkMark, findsOneWidget);
      expect(WidgetFinder.undoButton, findsOneWidget);
      expect(WidgetFinder.redoButton, findsOneWidget);
    });

    testWidgets('Undo / redo disabled and checkmark enabled before drawing',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      var checkMark = tester.firstWidget<IconButton>(WidgetFinder.checkMark);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);
      expect(checkMark.onPressed, isNotNull);
    });

    testWidgets('checkmark still enabled after clicking',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.tapAt(CanvasPosition.center);
      var checkMark = tester.firstWidget<IconButton>(WidgetFinder.checkMark);
      expect(checkMark.onPressed, isNotNull);
      await UIInteraction.clickCheckmark();
      checkMark = tester.firstWidget<IconButton>(WidgetFinder.checkMark);
      expect(checkMark.onPressed, isNotNull);
    });

    testWidgets('Undo is enabled after checkmark', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      var undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      expect(undoButton.onPressed, null);
      await UIInteraction.clickCheckmark();
      undoButton = tester.firstWidget<IconButton>(WidgetFinder.undoButton);
      expect(undoButton.onPressed, isNotNull);
    });

    testWidgets('Redo is enabled after drawing was undone',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.clickCheckmark();
      await UIInteraction.clickUndo();
      var redoButton = tester.firstWidget<IconButton>(WidgetFinder.redoButton);
      expect(redoButton.onPressed, isNotNull);
    });
  });
}
