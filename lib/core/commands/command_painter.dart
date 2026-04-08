import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/clipboard_tool.dart';
import 'package:paintroid/core/tools/implementation/cursor_tool.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool.dart';
import 'package:paintroid/core/tools/implementation/text_tool.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'dart:ui' as ui;

class CommandPainter extends CustomPainter {
  Tool currentTool;
  CommandManager commandManager;
  bool isCachingCommand;
  final ui.Image? cachedImage;

  CommandPainter(this.ref, {this.cachedImage})
      : currentTool = ref.read(toolBoxStateProvider).currentTool,
        commandManager = ref.read(commandManagerProvider),
        isCachingCommand = ref.read(
            canvasStateProvider.select((state) => state.isCachingCommand));

  final WidgetRef ref;

  @override
  void paint(Canvas canvas, Size size) {
    if (currentTool.type != ToolType.SHAPES &&
        currentTool.type != ToolType.TEXT &&
        currentTool.type != ToolType.CLIPBOARD) {
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    bool isEraserDrawing = currentTool.type == ToolType.ERASER &&
                           currentTool is BrushTool &&
                           ((currentTool as BrushTool).isDrawing || isCachingCommand);

    if (isEraserDrawing) {
      canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

      if (cachedImage != null) {
        canvas.drawImage(cachedImage!, Offset.zero, Paint());
      }
    }

    switch (currentTool.type) {
      case ToolType.LINE:
        _drawGhostPathsAndVertices(canvas, currentTool as LineTool);
        break;
      case ToolType.SHAPES:
        (currentTool as ShapesTool)
          ..drawShape(canvas, ref.read(paintProvider))
          ..drawGuides(canvas);
        break;
      case ToolType.CURSOR:
        commandManager.executeLastCommand(canvas);
        (currentTool as CursorTool)
            .drawCursorIcon(canvas, ref.read(paintProvider));
        break;
      case ToolType.CLIPBOARD:
        (currentTool as ClipboardTool).paint(canvas, size);
      case ToolType.TEXT:
        (currentTool as TextTool).drawGuides(canvas, ref.read(paintProvider));
        break;
      default:
        if (currentTool is BrushTool) {
          if ((currentTool as BrushTool).isDrawing || isCachingCommand) {
            commandManager.executeLastCommand(canvas);
          }
        } else {
          commandManager.executeLastCommand(canvas);
        }
        break;
    }
    
    if (isEraserDrawing) {
      canvas.restore();
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
    commandManager.drawLineToolVertices(canvas, lineTool.vertexStack);
  }
}
