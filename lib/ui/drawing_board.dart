import 'package:flutter/material.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/tool/brush_tool.dart';

import 'graphic_command_painter.dart';

class DrawingBoard extends StatefulWidget {
  final VoidCallback startedDrawing;
  final VoidCallback stoppedDrawing;

  const DrawingBoard({
    Key? key,
    required this.startedDrawing,
    required this.stoppedDrawing,
  }) : super(key: key);

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  late final commandManger = SyncCommandManager<GraphicCommand>(commands: []);
  late final brushTool = BrushTool(
    paint: Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2,
    commandManager: commandManger,
    commandFactory: const CommandFactory(),
    graphicFactory: const GraphicFactory(),
  );

  @override
  Widget build(BuildContext context) {
    final isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    brushTool.paint.color = isDarkTheme ? Colors.white70 : Colors.black87;

    return GestureDetector(
      onPanDown: (details) {
        widget.startedDrawing();
        setState(() => brushTool.onDown(details.localPosition));
      },
      onPanUpdate: (details) {
        setState(() => brushTool.onDrag(details.localPosition));
      },
      onPanEnd: (_) {
        widget.stoppedDrawing();
        setState(() => brushTool.onUp(null));
      },
      child: CustomPaint(
        painter: GraphicCommandPainter(commands: commandManger.commands),
        willChange: true,
        child: const Center(),
      ),
    );
  }
}
