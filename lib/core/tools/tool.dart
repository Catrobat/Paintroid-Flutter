// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';

abstract class Tool {
  const Tool({
    required this.paint,
    required this.commandManager,
    required this.commandFactory,
    required this.type,
  });

  final Paint paint;
  final ToolType type;
  final CommandManager commandManager;
  final CommandFactory commandFactory;

  void onDown(Offset point);

  void onDrag(Offset point);

  void onUp(Offset point);

  void onCancel();

  void onCheckmark();

  void onPlus();

  void undo();

  void redo();
}
