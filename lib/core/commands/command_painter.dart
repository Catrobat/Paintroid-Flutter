import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';

class CommandPainter extends CustomPainter {
  CommandPainter(this.commandManager, this.tool);

  final CommandManager commandManager;
  final Tool tool;

  @override
  void paint(Canvas canvas, Size size) {
    if (tool.type != ToolType.SHAPES) {
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }
    switch (tool.type) {
      case ToolType.LINE:
        _drawGhostPathsAndVertices(canvas);
        break;
      case ToolType.SHAPES:
        if ((tool as ShapesTool).isTranslatingAndScaling) {
          _drawShapesToolBoundingBox(canvas);
        }
        break;
      default:
        commandManager.executeLastCommand(canvas);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

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

  void _drawShapesToolBoundingBox(Canvas canvas) {
    final boundingBox = (tool as ShapesTool).boundingBox;
    canvas.drawRect(
      boundingBox,
      Paint()
        ..color = const Color.fromARGB(255, 5, 128, 137)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    const double circleRadius = 30.0;

    final Offset topLeft = boundingBox.topLeft;
    final Offset topRight = boundingBox.topRight;
    final Offset bottomLeft = boundingBox.bottomLeft;
    final Offset bottomRight = boundingBox.bottomRight;

    final Paint circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(topLeft, circleRadius, circlePaint);
    canvas.drawCircle(topRight, circleRadius, circlePaint);
    canvas.drawCircle(bottomLeft, circleRadius, circlePaint);
    canvas.drawCircle(bottomRight, circleRadius, circlePaint);
  }
}
