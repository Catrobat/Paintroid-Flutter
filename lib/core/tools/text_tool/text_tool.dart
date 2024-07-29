import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'dart:ui';

class TextTool extends Tool {
  TextTool({
    required super.paint,
    required super.commandManager,
    required super.commandFactory,
    required this.graphicFactory,
  }) : super(
          type: ToolType.TEXT,
          hasAddFunctionality: true,
          hasFinalizeFunctionality: true,
        );

  String? currentText;
  Offset? currentPosition;
  bool isEditing = false;
  final GraphicFactory graphicFactory;

  @override
  void onDown(Offset point) {
    if (isEditing) {
      //
    } else {
      currentPosition = point;
      isEditing = true;
    }
  }

  @override
  void onDrag(Offset point) {
    if (isEditing) {
      currentPosition = point;
      print('currentPosition: $currentPosition');
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
    if (currentText != null && currentPosition != null) {
      print('currentText: $currentText' + 'currentPosition: $currentPosition');
      final command = commandFactory.createAddTextCommand(
          currentPosition!, currentText!, paint);
      commandManager.addGraphicCommand(command);
      commandManager.executeLastCommand(graphicFactory
          .createCanvasWithRecorder(graphicFactory.createPictureRecorder()));
      currentText = null;
      currentPosition = null;
      isEditing = false;
    }
  }

  @override
  void onPlus() {
    if (currentText != null && currentPosition != null) {
      final command = commandFactory.createFinalizeTextCommand(
          currentPosition!, currentText!, paint);
      commandManager.addGraphicCommand(command);
      commandManager.executeLastCommand(graphicFactory
          .createCanvasWithRecorder(graphicFactory.createPictureRecorder()));
      currentText = null;
      currentPosition = null;
      isEditing = false;
    }
  }

  TextTool copyWith({
    Paint? paint,
    CommandManager? commandManager,
    CommandFactory? commandFactory,
    GraphicFactory? graphicFactory,
    String? currentText,
    Offset? currentPosition,
    bool? isEditing,
  }) {
    return TextTool(
      paint: paint ?? this.paint,
      commandManager: commandManager ?? this.commandManager,
      commandFactory: commandFactory ?? this.commandFactory,
      graphicFactory: graphicFactory ?? this.graphicFactory,
    )
      ..currentText = currentText ?? this.currentText
      ..currentPosition = currentPosition ?? this.currentPosition
      ..isEditing = isEditing ?? this.isEditing;
  }
}
