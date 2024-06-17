// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../test/utils/test_utils.dart';

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

  group('[COMMAND_MANAGER]', () {
    testWidgets('Test if tool changes during undo',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.topLeft);

      await UIInteraction.selectTool(ToolData.LINE.name);
      await UIInteraction.tapAt(CanvasPosition.bottomLeft);
      await UIInteraction.tapAt(CanvasPosition.bottomRight);

      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.topRight);

      await UIInteraction.selectTool(ToolData.LINE.name);

      var currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.LINE.type);

      await UIInteraction.clickUndo();
      currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.BRUSH.type);

      await UIInteraction.clickUndo();
      currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.LINE.type);

      await UIInteraction.clickUndo();
      currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.BRUSH.type);
    });

    testWidgets('Test if tool changes during redo',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.topLeft);

      await UIInteraction.selectTool(ToolData.LINE.name);
      await UIInteraction.tapAt(CanvasPosition.bottomLeft);
      await UIInteraction.tapAt(CanvasPosition.bottomRight);

      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.topRight);

      await UIInteraction.clickUndo(times: 3);

      var currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.BRUSH.type);

      await UIInteraction.clickRedo();
      currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.BRUSH.type);

      await UIInteraction.clickRedo();
      currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.LINE.type);

      await UIInteraction.clickRedo();
      currentTool = UIInteraction.getCurrentTool();
      expect(currentTool, ToolData.BRUSH.type);
    });
  });
}
