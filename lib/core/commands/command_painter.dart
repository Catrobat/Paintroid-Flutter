import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';

class CommandPainter extends CustomPainter {
  Tool currentTool;
  CommandManager commandManager;
  CommandPainter(this.ref)
      : currentTool = ref.read(toolBoxStateProvider).currentTool,
        commandManager = ref.read(commandManagerProvider);

  final WidgetRef ref;

  @override
  void paint(Canvas canvas, Size size) {
    if (currentTool.type != ToolType.SHAPES) {
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }
    switch (currentTool.type) {
      case ToolType.LINE:
        _drawGhostPathsAndVertices(canvas, currentTool as LineTool);
        break;
      case ToolType.SHAPES:
        _drawShapeAndGuides(canvas, currentTool as ShapesTool);

        break;
      default:
        commandManager.executeLastCommand(canvas);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawGhostPathsAndVertices(Canvas canvas, LineTool lineTool) {
    commandManager.drawLineToolGhostPaths(
      canvas,
      lineTool.ingoingGhostPathCommand,
      lineTool.outgoingGhostPathCommand,
    );
    commandManager.drawLineToolVertices(
      canvas,
      lineTool.vertexStack,
    );
  }

  void _drawShapeAndGuides(Canvas canvas, ShapesTool shapesTool) {
    shapesTool.drawRectangle(canvas, ref.read(paintProvider));
    shapesTool.drawGuides(canvas);
  }
}
