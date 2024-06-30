import 'package:paintroid/core/providers/state/canvas_state_data.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'dart:ui';

class TextTool extends Tool {
  final CanvasStateData stateData;
  TextTool({
    required super.paint,
    required super.commandManager,
    required super.commandFactory,
    required this.stateData,
  }) : super(
          type: ToolType.TEXT,
          hasAddFunctionality: true,
          hasFinalizeFunctionality: true,
        );

  String? currentText;
  Offset? currentPosition;

  @override
  void onDown(Offset point) {
    currentPosition = point;
  }

  @override
  void onDrag(Offset point) {}

  @override
  void onUp(Offset point) {}

  @override
  void onCancel() {
    currentPosition = null;
    currentText = null;
  }

  @override
  void onCheckmark() {
    final state = stateData;
    if (currentText != null && currentPosition != null) {
      final command = commandFactory.createAddTextCommand(
          currentPosition!, currentText!, paint);
      commandManager.addGraphicCommand(command);
      commandManager.executeLastCommand(state.graphicFactory
          .createCanvasWithRecorder(
              state.graphicFactory.createPictureRecorder()));
      currentText = null;
      currentPosition = null;
    }
  }

  @override
  void onPlus() {
    final state = stateData;
    if (currentText != null && currentPosition != null) {
      final command = commandFactory.createFinalizeTextCommand(
          currentPosition!, currentText!, paint);
      commandManager.addGraphicCommand(command);
      commandManager.executeLastCommand(state.graphicFactory
          .createCanvasWithRecorder(
              state.graphicFactory.createPictureRecorder()));
      currentText = null;
      currentPosition = null;
    }
  }
}
