import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/tool/brush_tool.dart';
import 'package:paintroid/workspace/workspace.dart';

import 'graphic_command_painter.dart';
import 'transparency_grid_pattern.dart';

class DrawingBoard extends ConsumerStatefulWidget {
  const DrawingBoard({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends ConsumerState<DrawingBoard> {
  late final commandManger = ref.read(SyncCommandManager.provider);
  late final brushTool = BrushTool(
    paint: Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5,
    commandManager: commandManger,
    commandFactory: ref.read(CommandFactory.provider),
    graphicFactory: ref.read(GraphicFactory.provider),
  );

  final drawCanvasKey = GlobalKey(debugLabel: "drawCanvas");

  void _updateCanvasSizeToStateNotifier() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final ctx = drawCanvasKey.currentContext!;
      final renderBox = ctx.findRenderObject() as RenderBox;
      ref
          .read(CanvasStateNotifier.provider.notifier)
          .setCanvasSize(renderBox.size.width, renderBox.size.height);
    });
  }

  @override
  void initState() {
    _updateCanvasSizeToStateNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = ref.watch(
      WorkspaceStateNotifier.provider.select((state) => state.aspectRatio),
    );
    ref.listen<WorkspaceState>(WorkspaceStateNotifier.provider,
        (previous, next) {
      if (previous?.loadedImage != next.loadedImage) {
        _updateCanvasSizeToStateNotifier();
      }
    });
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(width: 0.5)),
      ),
      child: AspectRatio(
        aspectRatio: ratio,
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
    final loadedImage = ref.watch(
      WorkspaceStateNotifier.provider.select((value) => value.loadedImage),
    );
    return CustomPaint(
      key: drawCanvasKey,
      foregroundPainter: GraphicCommandPainter(
        commands: commandManger.commands,
      ),
      willChange: true,
      child: RepaintBoundary(
        child: TransparencyGridPattern(
          numberOfSquaresAlongWidth: 100,
          child: loadedImage != null
              ? RawImage(image: loadedImage, fit: BoxFit.fill)
              : null,
        ),
      ),
    );
  }
}
