// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// Project imports:
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../../ui_interaction.dart';

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

      expect(uiInteraction.plusButton, findsNothing);
      expect(uiInteraction.checkMark, findsNothing);
      expect(uiInteraction.undoButton, findsOneWidget);
      expect(uiInteraction.redoButton, findsOneWidget);
    });

    testWidgets('Undo / redo are disabled before drawing with brush tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.BRUSH.name);

      final IconButton undoButton =
          tester.firstWidget<IconButton>(uiInteraction.undoButton);
      final IconButton redoButton =
          tester.firstWidget<IconButton>(uiInteraction.redoButton);
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

      var undoButton = tester.firstWidget<IconButton>(uiInteraction.undoButton);
      var redoButton = tester.firstWidget<IconButton>(uiInteraction.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);

      await uiInteraction.tapAt(uiInteraction.center);

      undoButton = tester.firstWidget<IconButton>(uiInteraction.undoButton);
      redoButton = tester.firstWidget<IconButton>(uiInteraction.redoButton);
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

      var undoButton = tester.firstWidget<IconButton>(uiInteraction.undoButton);
      var redoButton = tester.firstWidget<IconButton>(uiInteraction.redoButton);
      expect(undoButton.onPressed, null);
      expect(redoButton.onPressed, null);

      await uiInteraction.tapAt(uiInteraction.center);

      await uiInteraction.clickUndo();

      undoButton = tester.firstWidget<IconButton>(uiInteraction.undoButton);
      redoButton = tester.firstWidget<IconButton>(uiInteraction.redoButton);
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

      expect(uiInteraction.plusButton, findsOneWidget);
      expect(uiInteraction.checkMark, findsOneWidget);
      expect(uiInteraction.undoButton, findsOneWidget);
      expect(uiInteraction.redoButton, findsOneWidget);
    });

    testWidgets(
        'Undo / redo and plus / checkmark are disabled before drawing with line tool',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.LINE.name);

      var undoButton = tester.firstWidget<IconButton>(uiInteraction.undoButton);
      var redoButton = tester.firstWidget<IconButton>(uiInteraction.redoButton);
      var plusButton = tester.firstWidget<IconButton>(uiInteraction.plusButton);
      var checkMark = tester.firstWidget<IconButton>(uiInteraction.checkMark);

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

      var undoButton = tester.firstWidget<IconButton>(uiInteraction.undoButton);
      expect(undoButton.onPressed, null);

      await uiInteraction.tapAt(uiInteraction.center);
      undoButton = tester.firstWidget<IconButton>(uiInteraction.undoButton);
      expect(undoButton.onPressed, isNotNull);
    });

    testWidgets('Redo is enabled after drawing with line tool was undone',
        (WidgetTester tester) async {
      uiInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await uiInteraction.createNewImage();

      await uiInteraction.selectTool(ToolData.LINE.name);

      await uiInteraction.tapAt(uiInteraction.center);

      var redoButton = tester.firstWidget<IconButton>(uiInteraction.redoButton);
      expect(redoButton.onPressed, null);

      await uiInteraction.clickUndo();

      redoButton = tester.firstWidget<IconButton>(uiInteraction.redoButton);

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

    expect(uiInteraction.plusButton, findsNothing);
    expect(uiInteraction.checkMark, findsNothing);
    expect(uiInteraction.undoButton, findsOneWidget);
    expect(uiInteraction.redoButton, findsOneWidget);
  });

  testWidgets(
      '[TOP_APP_BAR]: Show no undo / redo and no plus / checkmark button in hand tool',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();

    await uiInteraction.selectTool(ToolData.HAND.name);

    expect(uiInteraction.plusButton, findsNothing);
    expect(uiInteraction.checkMark, findsNothing);
    expect(uiInteraction.undoButton, findsNothing);
    expect(uiInteraction.redoButton, findsNothing);
  });
}

// redo is disabled after click resetted
