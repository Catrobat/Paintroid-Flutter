import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/tools/cursor_tool/cursor_icon.dart';
import 'package:paintroid/core/tools/tool.dart';

class CursorTool extends Tool {
  final GraphicFactory graphicFactory;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;

  CursorTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
    super.icon =  const  CursorIcon(drawColor: Color(234234)),
    super.iconPosition = const Offset(0,0),
  });

  @override
  void onDown(Offset point, Paint paint) {
    print("On Down was pressed");
    super.iconPosition = point;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    print("On Drag was pressed");
    super.iconPosition = point;
  }

  @override
  void onUp(Offset point, Paint paint) {
    super.iconPosition = point;
  }

  @override
  void onCancel() {
  }

  @override
  void onCheckmark(Paint paint) {}

  @override
  void onPlus() {}

  @override
  void onRedo() {
    commandManager.redo();
  }

  @override
  void onUndo() {
    commandManager.undo();
  }
}
