import 'dart:ui';

import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';

abstract class Tool {
  final ToolType type;
  final CommandManager commandManager;
  final CommandFactory commandFactory;
  final bool hasAddFunctionality;
  final bool hasFinalizeFunctionality;

  const Tool({
    required this.commandManager,
    required this.commandFactory,
    required this.type,
    required this.hasAddFunctionality,
    required this.hasFinalizeFunctionality,
  });

  void onDown(Offset point, Paint paint);

  void onDrag(Offset point, Paint paint);

  void onUp(Offset point, Paint paint);

  void onCancel();

  void onCheckmark();

  void onPlus();

  void onUndo();

  void onRedo();
}
