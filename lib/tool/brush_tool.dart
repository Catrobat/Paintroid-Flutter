import 'dart:ui';

import 'package:paintroid/command/command_manager.dart';
import 'package:paintroid/command/draw_command.dart';
import 'package:paintroid/command/draw_path.dart';

import 'tool.dart';

class BrushTool implements Tool {
  BrushTool({required this.paint, required this.commandManager})  {
    if (commandManager.commands.isNotEmpty) {
      final command = commandManager.commands.last;
      if (command is DrawPath) {
        _drawPath = command;
      }
    }
  }

  @override
  final Paint paint;

  @override
  final CommandManager<DrawCommand> commandManager;

  late DrawPath _drawPath;

  @override
  void onDown(Offset point) {
    final path = Path()..moveTo(point.dx, point.dy);
    _drawPath = DrawPath(path, paint);
    commandManager.commands.add(_drawPath);
  }

  @override
  void onDrag(Offset point) {
    _drawPath.path.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset? point) {
    if (_drawPath.path.getBounds().size == Size.zero) {
      _drawPath.path.close();
    }
  }
}
