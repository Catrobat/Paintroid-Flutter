// Project imports:
import 'package:tools/tools.dart';

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
