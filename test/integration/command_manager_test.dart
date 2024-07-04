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

  group('[COMMAND_MANAGER]', () {
    if (testID == -1 || testID == 0) {
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
        expect(currentTool.type, ToolData.LINE.type);

        await UIInteraction.clickUndo();
        currentTool = UIInteraction.getCurrentTool();
        expect(currentTool.type, ToolData.BRUSH.type);

        await UIInteraction.clickUndo();
        currentTool = UIInteraction.getCurrentTool();
        expect(currentTool.type, ToolData.LINE.type);

        await UIInteraction.clickUndo();
        await UIInteraction.clickUndo();
        currentTool = UIInteraction.getCurrentTool();
        expect(currentTool.type, ToolData.BRUSH.type);
      });
    }

    if (testID == -1 || testID == 1) {
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
        expect(currentTool.type, ToolData.BRUSH.type);

        await UIInteraction.clickRedo();
        currentTool = UIInteraction.getCurrentTool();
        expect(currentTool.type, ToolData.BRUSH.type);

        await UIInteraction.clickRedo();
        currentTool = UIInteraction.getCurrentTool();
        expect(currentTool.type, ToolData.LINE.type);

        await UIInteraction.clickRedo();
        currentTool = UIInteraction.getCurrentTool();
        expect(currentTool.type, ToolData.BRUSH.type);
      });
    }
  });
}
