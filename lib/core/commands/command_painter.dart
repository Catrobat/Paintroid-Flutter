// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';

class CommandPainter extends CustomPainter {
  CommandPainter(this.commandManager, this.tool);

  final CommandManager commandManager;
  final Tool tool;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    switch (tool.type) {
      case ToolType.LINE:
        _drawGhostPathsAndVertices(canvas);
        break;
      default:
        commandManager.executeLastCommand(canvas);
        break;
    }
  }

  void _drawGhostPathsAndVertices(Canvas canvas) {
    commandManager.drawLineToolGhostPaths(
      canvas,
      (tool as LineTool).ingoingGhostPathCommand,
      (tool as LineTool).outgoingGhostPathCommand,
    );
    commandManager.drawLineToolVertices(
      canvas,
      (tool as LineTool).vertexStack,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
