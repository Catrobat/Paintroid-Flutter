import 'package:command/command.dart';
import 'package:flutter/material.dart';
import 'package:tools/tools.dart';

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
        //commandManager.executeLastCommand(canvas);
        // problematic but need to fix here stroke change
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
