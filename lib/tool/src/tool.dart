import 'dart:ui';

import 'package:paintroid/command/command.dart';
import 'package:paintroid/tool/src/tool_types.dart';

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

  void onUp(Offset? point);

  void onCancel();
}
