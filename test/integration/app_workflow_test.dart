import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String testIDStr = String.fromEnvironment('id', defaultValue: '-1');
  final testID = int.tryParse(testIDStr) ?? testIDStr;

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  if (testID == -1 || testID == 0) {
    testWidgets('[GENERAL]: undo stack is empty for new image',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      var undoStackLength = UIInteraction.getUndoStackLength();
      expect(undoStackLength, 0);

      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.center);

      undoStackLength = UIInteraction.getUndoStackLength();
      expect(undoStackLength, 1);

      await UIInteraction.clickBackButton();
      await UIInteraction.clickDiscard();
      await UIInteraction.createNewImage();

      undoStackLength = UIInteraction.getUndoStackLength();
      expect(undoStackLength, 0);
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[GENERAL]: redo stack is empty for new image with empty image',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      var redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 0);

      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.center);

      redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 0);

      await UIInteraction.clickUndo();

      redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 1);

      await UIInteraction.clickBackButton();
      await UIInteraction.createNewImage();

      redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 0);
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets(
        '[GENERAL]: redo stack is empty for new image with non empty image',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      var redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 0);
      var undoStackLength = UIInteraction.getUndoStackLength();
      expect(undoStackLength, 0);

      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.centerLeft);
      await UIInteraction.tapAt(CanvasPosition.centerRight);

      undoStackLength = UIInteraction.getUndoStackLength();
      expect(undoStackLength, 2);
      redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 0);

      await UIInteraction.clickUndo();

      undoStackLength = UIInteraction.getUndoStackLength();
      expect(undoStackLength, 1);
      redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 1);

      await UIInteraction.clickBackButton();
      await UIInteraction.clickDiscard();
      await UIInteraction.createNewImage();

      undoStackLength = UIInteraction.getUndoStackLength();
      expect(undoStackLength, 0);
      redoStackLength = UIInteraction.getRedoStackLength();
      expect(redoStackLength, 0);
    });
  }
}
