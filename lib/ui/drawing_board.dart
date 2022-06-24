import 'package:flutter/material.dart';
import 'package:paintroid/command/command_factory.dart';
import 'package:paintroid/command/graphic_command.dart';
import 'package:paintroid/command/sync_command_manager.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/tool/brush_tool.dart';

import 'draw_command_painter.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({Key? key}) : super(key: key);

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
    commandFactory: CommandFactory(),
    graphicFactory: GraphicFactory(),
  );

  @override
  Widget build(BuildContext context) {
    final isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    brushTool.paint.color = isDarkTheme ? Colors.white70 : Colors.black87;

    return GestureDetector(
      onPanDown: (details) {
        setState(() => brushTool.onDown(details.localPosition));
      },
      onPanUpdate: (details) {
        setState(() => brushTool.onDrag(details.localPosition));
      },
      onPanEnd: (_) {
        setState(() => brushTool.onUp(null));
      },
      child: CustomPaint(
        painter: DrawCommandPainter(commands: commandManger.commands),
        willChange: true,
        child: const Center(),
      ),
    );
  }
}
