import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/provider/providers.dart';
import 'package:paintroid/tool/brush_tool.dart';
import 'package:paintroid/ui/transparency_grid_pattern.dart';
import 'package:paintroid/workspace/workspace.dart';

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
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5,
    commandManager: commandManger,
    commandFactory: ref.read(Providers.commandFactory),
    graphicFactory: ref.read(Providers.graphicFactory),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(width: 0.5)),
      ),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: GestureDetector(
          onPanDown: (details) {
            ref
                .read(WorkspaceStateNotifier.provider.notifier)
                .toggleDrawingState(true);
            setState(() => brushTool.onDown(details.localPosition));
          },
          onPanUpdate: (details) {
            setState(() => brushTool.onDrag(details.localPosition));
          },
          onPanEnd: (_) {
            ref
                .read(WorkspaceStateNotifier.provider.notifier)
                .toggleDrawingState(false);
            setState(() => brushTool.onUp(null));
          },
          child: _drawingCanvas,
        ),
      ),
    );
  }

  CustomPaint get _drawingCanvas {
    return CustomPaint(
      foregroundPainter: GraphicCommandPainter(
        commands: commandManger.commands,
      ),
      willChange: true,
      child: const TransparencyGridPattern(
        numberOfSquaresAlongWidth: 100,
      ),
    );
  }
}
