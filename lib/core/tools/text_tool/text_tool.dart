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
  bool isEditing = false;

  @override
  void onDown(Offset point) {
    if (isEditing) {
      // If the user clicks outside the text input, finalize the text
      if (currentPosition != null && (point - currentPosition!).distance > 50) {
        onCheckmark();
      }
    } else {
      currentPosition = point;
      isEditing = true;
    }
  }

  @override
  void onDrag(Offset point) {
    if (isEditing) {
      currentPosition = point;
    }
  }

  @override
  void onUp(Offset point) {}

  @override
  void onCancel() {
    currentPosition = null;
    currentText = null;
    isEditing = false;
  }

  @override
  void onCheckmark() {
    print('onCheckmark $currentText $currentPosition');
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
      isEditing = false;
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
      isEditing = false;
    }
  }
}
