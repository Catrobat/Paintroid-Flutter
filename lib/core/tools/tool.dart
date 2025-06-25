import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/cursor_tool/cursor_icon.dart';

abstract class Tool {
  final ToolType type;
  final CommandManager commandManager;
  final CommandFactory commandFactory;
  final bool hasAddFunctionality;
  final bool hasFinalizeFunctionality;
   CursorIcon? icon;
   Offset? iconPosition;

   Tool({
    required this.commandManager,
    required this.commandFactory,
    required this.type,
    required this.hasAddFunctionality,
    required this.hasFinalizeFunctionality,
    this.icon,
     this.iconPosition,
  });

  void onDown(Offset point, Paint paint);

  void onDrag(Offset point, Paint paint);

  void onUp(Offset point, Paint paint);

  void onCancel();

  void onCheckmark(Paint paint);

  void onPlus();

  void onUndo();

  void onRedo();
}
