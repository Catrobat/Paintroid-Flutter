// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';

abstract class Tool {
  const Tool({
    required this.paint,
    required this.commandManager,
    required this.commandFactory,
    required this.type,
    required this.hasUndoRedoFunctionality,
    required this.hasAddFunctionality,
    required this.hasFinalizeFunctionality,
  });

  final Paint paint;
  final ToolType type;
  final ICommandManager commandManager;
  final CommandFactory commandFactory;
  final bool hasUndoRedoFunctionality;
  final bool hasAddFunctionality;
  final bool hasFinalizeFunctionality;

  void onDown(Offset point);

  void onDrag(Offset point);

  void onUp(Offset point);

  void onCancel();

  void onCheckmark();

  void onPlus();

  void undo();

  void redo();
}
