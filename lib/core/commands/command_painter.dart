import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';

class CommandPainter extends CustomPainter {
  CommandPainter(
    this.commandManager,
    this.tool,
    this.isRotating,
  );

  final CommandManager commandManager;
  final Tool tool;
  final bool isRotating;

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
        _drawShapesToolBoundingBox(canvas);

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
    final topLeft = (tool as ShapesTool).topLeft;
    final topRight = (tool as ShapesTool).topRight;
    final bottomLeft = (tool as ShapesTool).bottomLeft;
    final bottomRight = (tool as ShapesTool).bottomRight;

    final boundingBoxPaint = Paint()
      ..color = const Color.fromARGB(255, 5, 128, 137)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    canvas.drawPath(path, boundingBoxPaint);

    // Draw a rectangle inside the path that considers rotation
    final innerRectPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final innerPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    canvas.drawPath(innerPath, innerRectPaint);
    
    final center = Offset(
      (topLeft.dx + bottomRight.dx) / 2,
      (topLeft.dy + bottomRight.dy) / 2,
    );

    // Draw a circle inside the bounding box
    final innerCirclePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        center, (topLeft - bottomLeft).distance / 2, innerCirclePaint);

    const double circleRadius = 30.0;

    final Paint circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      topLeft,
      circleRadius,
      Paint()
        ..color = Colors.purple
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(topRight, circleRadius, circlePaint);
    canvas.drawCircle(bottomLeft, circleRadius, circlePaint);
    canvas.drawCircle(bottomRight, circleRadius, circlePaint);

    // // Calculate the center and radius of the circumscribing circle
    // final center = Offset(
    //   (topLeft.dx + bottomRight.dx) / 2,
    //   (topLeft.dy + bottomRight.dy) / 2,
    // );

    final diagonalLength = (topLeft - bottomRight).distance;
    final circumscribingCircleRadius = diagonalLength / 2;

    // Draw the circumscribing circle
    final circumscribingCirclePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      center,
      circumscribingCircleRadius,
      circumscribingCirclePaint,
    );
  }
}
