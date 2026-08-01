import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/clipboard_tool_options.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';

import '../utils/ui_interaction.dart';
import '../utils/clipboard_tool_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String testIDStr = String.fromEnvironment('id', defaultValue: '-1');
  final testID = int.tryParse(testIDStr) ?? testIDStr;

  group('Clipboard Tool Integration Tests', () {
    if (testID == -1 || testID == 0) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_0]: Copy and Paste operations work correctly',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);

        ui.Image? imageBeforeDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);

        await ClipboardIntegrationTestUtils.drawSomethingOnCanvas(tester);
        ui.Image? imageAfterDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterDraw, isNotNull,
            reason: 'Canvas image should be available after draw');
        expect(
            imageAfterDraw.hashCode, isNot(equals(imageBeforeDraw?.hashCode)),
            reason: 'Canvas should change after drawing a shape');

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        expect(find.byType(ClipboardToolOptions), findsOneWidget,
            reason: 'Clipboard options should be visible');

        final copyButton = find.widgetWithIcon(CustomActionChip, Icons.copy);
        expect(copyButton, findsOneWidget,
            reason: 'Copy button should be present');
        await tester.tap(copyButton);
        await tester.pumpAndSettle();

        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isTrue,
            reason: 'hasCopiedContent should be true after copy');

        final pasteButton = find.widgetWithIcon(CustomActionChip, Icons.paste);
        expect(pasteButton, findsOneWidget,
            reason: 'Paste button should be present');
        await tester.tap(pasteButton);
        await tester.pumpAndSettle();

        ui.Image? imageAfterPaste =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterPaste, isNotNull,
            reason: 'Canvas image should be available after paste');
        expect(imageAfterPaste.hashCode, isNot(equals(imageAfterDraw.hashCode)),
            reason: 'Canvas should change after paste');
      });
    }

    if (testID == -1 || testID == 1) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_1]: Cut and Paste operations work correctly',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);

        ui.Image? imageBeforeDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);

        await ClipboardIntegrationTestUtils.drawSomethingOnCanvas(tester);
        ui.Image? imageAfterDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterDraw, isNotNull,
            reason: 'Canvas image should be available after draw');
        expect(
            imageAfterDraw.hashCode, isNot(equals(imageBeforeDraw?.hashCode)),
            reason: 'Canvas should change after drawing a shape');

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        expect(find.byType(ClipboardToolOptions), findsOneWidget,
            reason: 'Clipboard options should be visible');

        final cutButton =
            find.widgetWithIcon(CustomActionChip, Icons.content_cut);
        expect(cutButton, findsOneWidget,
            reason: 'Cut button should be present');
        await tester.tap(cutButton);
        await tester.pumpAndSettle();

        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isTrue,
            reason: 'hasCopiedContent should be true after cut');

        ui.Image? imageAfterCut =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterCut, isNotNull,
            reason: 'Canvas image should be available after cut');
        expect(imageAfterCut.hashCode, isNot(equals(imageAfterDraw.hashCode)),
            reason: 'Canvas should change after cut (shape removed)');

        final pasteButton = find.widgetWithIcon(CustomActionChip, Icons.paste);
        expect(pasteButton, findsOneWidget,
            reason: 'Paste button should be present');
        await tester.tap(pasteButton);
        await tester.pumpAndSettle();

        ui.Image? imageAfterPaste =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterPaste, isNotNull,
            reason: 'Canvas image should be available after paste');
        expect(imageAfterPaste.hashCode, isNot(equals(imageAfterCut.hashCode)),
            reason: 'Canvas should change after paste (shape re-added)');
      });
    }

    if (testID == -1 || testID == 2) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_2]: Paste with initially empty clipboard does nothing',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);
        ui.Image? imageBeforeAction =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);
        int initialUndoStackLength = UIInteraction.getUndoStackLength();

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        expect(find.byType(ClipboardToolOptions), findsOneWidget);
        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isFalse,
            reason: 'Initially, clipboard should be empty');

        final pasteButton = find.widgetWithIcon(CustomActionChip, Icons.paste);
        expect(pasteButton, findsOneWidget);
        await tester.tap(pasteButton);
        await tester.pumpAndSettle();

        ui.Image? imageAfterPasteAttempt =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: false);
        int finalUndoStackLength = UIInteraction.getUndoStackLength();

        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isFalse,
            reason:
                'Clipboard should still be empty after attempting to paste nothing');
        expect(imageAfterPasteAttempt?.hashCode,
            equals(imageBeforeAction?.hashCode),
            reason:
                'Canvas image instance should not change after a no-op paste attempt on an empty clipboard');
        expect(finalUndoStackLength, equals(initialUndoStackLength),
            reason:
                'Undo stack should not change after attempting to paste nothing');
      });
    }

    if (testID == -1 || testID == 3) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_3]: Multiple Paste operations of the same content are idempotent on canvas',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);
        await ClipboardIntegrationTestUtils.drawSomethingOnCanvas(tester);
        ui.Image? imageAfterDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        final copyButton = find.widgetWithIcon(CustomActionChip, Icons.copy);
        await tester.tap(copyButton);
        await tester.pumpAndSettle();
        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isTrue);

        final pasteButton = find.widgetWithIcon(CustomActionChip, Icons.paste);
        await tester.tap(pasteButton);
        await tester.pumpAndSettle();
        ui.Image? imageAfterFirstPaste =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);
        expect(imageAfterFirstPaste?.hashCode,
            isNot(equals(imageAfterDraw?.hashCode)),
            reason: 'Canvas should change after first paste');

        await tester.tap(pasteButton);
        await tester.pumpAndSettle();
        ui.Image? imageAfterSecondPaste =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);

        expect(imageAfterSecondPaste?.hashCode,
            isNot(equals(imageAfterFirstPaste?.hashCode)),
            reason:
                'Canvas should change after pasting another instance of the same content (new command is added)');
      });
    }

    if (testID == -1 || testID == 4) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_4]: Pasting after copy and further drawing uses original copied content',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);

        await ClipboardIntegrationTestUtils.drawSomethingOnCanvas(tester);
        ui.Image? imageAfterDrawingA =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        final copyButton = find.widgetWithIcon(CustomActionChip, Icons.copy);
        await tester.tap(copyButton);
        await tester.pumpAndSettle();
        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isTrue);

        await ClipboardIntegrationTestUtils.drawSomethingElseOnCanvas(tester);
        ui.Image? imageAfterDrawingB =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);
        expect(imageAfterDrawingB?.hashCode,
            isNot(equals(imageAfterDrawingA?.hashCode)),
            reason: 'Canvas should change after drawing item B');

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        final pasteButton = find.widgetWithIcon(CustomActionChip, Icons.paste);
        await tester.tap(pasteButton);
        await tester.pumpAndSettle();

        ui.Image? imageAfterPaste =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);
        expect(imageAfterPaste?.hashCode,
            isNot(equals(imageAfterDrawingB?.hashCode)),
            reason:
                'Canvas should change after pasting, and it should be different from just having A and B');
      });
    }
    if (testID == -1 || testID == 5) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_5]: Clear operation removes content from clipboard after Copy operation',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);

        ui.Image? imageBeforeDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);

        await ClipboardIntegrationTestUtils.drawSomethingOnCanvas(tester);
        ui.Image? imageAfterDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterDraw, isNotNull,
            reason: 'Canvas image should be available after draw');
        expect(
            imageAfterDraw.hashCode, isNot(equals(imageBeforeDraw?.hashCode)),
            reason: 'Canvas should change after drawing a shape');

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        expect(find.byType(ClipboardToolOptions), findsOneWidget,
            reason: 'Clipboard options should be visible');

        final copyButton = find.widgetWithIcon(CustomActionChip, Icons.copy);
        expect(copyButton, findsOneWidget,
            reason: 'Copy button should be present');
        await tester.tap(copyButton);
        await tester.pumpAndSettle();

        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isTrue,
            reason: 'hasCopiedContent should be true after copy');

        final clearButton = find.widgetWithIcon(CustomActionChip, Icons.delete_outline);
        expect(clearButton, findsOneWidget,
            reason: 'Clear button should be present');

        final undoBeforeClear = UIInteraction.getUndoStackLength();
        await tester.tap(clearButton);
        await tester.pumpAndSettle();
        final undoAfterClear = UIInteraction.getUndoStackLength();
        expect(undoAfterClear, equals(undoBeforeClear),
        reason: 'Canvas should remain unchanged after clearing clipboard');
        
        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isFalse,
            reason: 'hasCopiedContent should be false after clear');

        ui.Image? imageAfterClear =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);

        
        final pasteButton = find.widgetWithIcon(CustomActionChip, Icons.paste);
        expect(pasteButton, findsOneWidget,
            reason: 'Paste button should be present');
        await tester.tap(pasteButton);
        await tester.pumpAndSettle();

        ui.Image? imageAfterPasteAttempt =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: false);
        expect(imageAfterPasteAttempt?.hashCode, equals(imageAfterClear.hashCode),
            reason:
                'Canvas should not change when Paste operation is performed after clearing the clipboard');
      });
    }
    if (testID == -1 || testID == 6) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_6]: Clear operation removes content from clipboard after Cut operation',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);

        ui.Image? imageBeforeDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);

        await ClipboardIntegrationTestUtils.drawSomethingOnCanvas(tester);
        ui.Image? imageAfterDraw =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterDraw, isNotNull,
            reason: 'Canvas image should be available after draw');
        expect(
            imageAfterDraw.hashCode, isNot(equals(imageBeforeDraw?.hashCode)),
            reason: 'Canvas should change after drawing a shape');

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        expect(find.byType(ClipboardToolOptions), findsOneWidget,
            reason: 'Clipboard options should be visible');

        final cutButton =
            find.widgetWithIcon(CustomActionChip, Icons.content_cut);
        expect(cutButton, findsOneWidget,
            reason: 'Cut button should be present');
        await tester.tap(cutButton);
        await tester.pumpAndSettle();

        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isTrue,
            reason: 'hasCopiedContent should be true after cut');

        ui.Image? imageAfterCut =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester);
        expect(imageAfterCut, isNotNull,
            reason: 'Canvas image should be available after cut');
        expect(imageAfterCut.hashCode, isNot(equals(imageAfterDraw.hashCode)),
            reason: 'Canvas should change after cut (shape removed)');

        final clearButton = find.widgetWithIcon(CustomActionChip, Icons.delete_outline);
        expect(clearButton, findsOneWidget,
            reason: 'Clear button should be present');

        final undoBeforeClear = UIInteraction.getUndoStackLength();
        await tester.tap(clearButton);
        await tester.pumpAndSettle();
        final undoAfterClear = UIInteraction.getUndoStackLength();
        expect(undoAfterClear, equals(undoBeforeClear),
        reason: 'Canvas should remain unchanged after clearing clipboard');

        ui.Image? imageAfterClear =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: true);

        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isFalse,
            reason: 'hasCopiedContent should be false after clearing clipboard');

        final pasteButton = find.widgetWithIcon(CustomActionChip, Icons.paste);
        expect(pasteButton, findsOneWidget,
            reason: 'Paste button should be present');
        await tester.tap(pasteButton);
        await tester.pumpAndSettle();

        ui.Image? imageAfterPasteAttempt =
            await ClipboardIntegrationTestUtils.getCanvasImage(tester,
                forceUpdate: false);
        expect(imageAfterPasteAttempt?.hashCode, equals(imageAfterClear.hashCode),
            reason:
                'Canvas should not change when Paste operation is performed after clearing the clipboard');
      });

    }
    if (testID == -1 || testID == 7) {
      testWidgets(
          '[CLIPBOARD_TOOL_TEST_ID_7]: Multiple Clear operations on empty clipboard are safe',
          (WidgetTester tester) async {
        await ClipboardIntegrationTestUtils.launchAppAndInit(tester);

        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        expect(find.byType(ClipboardToolOptions), findsOneWidget);
        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isFalse,
            reason: 'Initially, clipboard should be empty');

      final undoBefore = UIInteraction.getUndoStackLength();
        await ClipboardIntegrationTestUtils.selectTool(
            tester, ToolData.CLIPBOARD.name);
        expect(find.byType(ClipboardToolOptions), findsOneWidget,
            reason: 'Clipboard options should be visible');

        final clearButton = find.widgetWithIcon(CustomActionChip, Icons.delete_outline);
        expect(clearButton, findsOneWidget,
            reason: 'Clear button should be present');
        await tester.tap(clearButton);
        await tester.pumpAndSettle();
        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isFalse,
            reason: 'hasCopiedContent should be false after clear');

        await tester.tap(clearButton);
        await tester.pumpAndSettle();
        expect(
            ClipboardIntegrationTestUtils.getHasCopiedContent(tester), isFalse,
            reason: 'hasCopiedContent should be false after multiple clear operations');
        
        final undoAfter = UIInteraction.getUndoStackLength();
        expect(undoAfter, equals(undoBefore),
        reason: 'Multiple clear operations should not affect undo stack');
        });
    }
  });
}
