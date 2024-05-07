// Project imports:
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';

class EraserTool extends BrushTool {
  EraserTool({
    required super.paint,
    required super.commandFactory,
    required super.commandManager,
    required super.graphicFactory,
  }) : super();

  @override
  ToolType get type => ToolType.ERASER;
}
