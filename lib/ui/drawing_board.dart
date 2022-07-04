import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/provider/providers.dart';
import 'package:paintroid/provider/state_providers.dart';
import 'package:paintroid/tool/brush_tool.dart';

import 'graphic_command_painter.dart';

class DrawingBoard extends ConsumerStatefulWidget {
  const DrawingBoard({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends ConsumerState<DrawingBoard> {
  late final commandManger = ref.read(Providers.graphicCommandManager);
  late final brushTool = BrushTool(
    paint: Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2,
    commandManager: commandManger,
    commandFactory: ref.read(Providers.commandFactory),
    graphicFactory: ref.read(Providers.graphicFactory),
  );

  @override
  Widget build(BuildContext context) {
    final isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    brushTool.paint.color = isDarkTheme ? Colors.white70 : Colors.black87;

    return GestureDetector(
      onPanDown: (details) {
        ref.read(StateProviders.isUserDrawing.notifier).state = true;
        setState(() => brushTool.onDown(details.localPosition));
      },
      onPanUpdate: (details) {
        setState(() => brushTool.onDrag(details.localPosition));
      },
      onPanEnd: (_) {
        ref.read(StateProviders.isUserDrawing.notifier).state = false;
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
