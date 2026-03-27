import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/command_painter.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/checkerboard_pattern.dart';

class CanvasPainter extends ConsumerWidget {
  const CanvasPainter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(canvasStateProvider.select((state) => state.size));
    return Container(
      key: const ValueKey(WidgetIdentifier.canvasPainter),
      width: size.width,
      height: size.height,
      foregroundDecoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(width: 0.5)),
      ),
      child: const Stack(
        fit: StackFit.expand,
        children: [
          BackgroundLayer(),
          PaintingLayer(),
        ],
      ),
    );
  }
}

class BackgroundLayer extends ConsumerWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundImage = ref.watch(
      canvasStateProvider.select((state) => state.backgroundImage),
    );
    return RepaintBoundary(
      child: CheckerboardPattern(
        child:
            backgroundImage != null ? RawImage(image: backgroundImage) : null,
      ),
    );
  }
}

class PaintingLayer extends ConsumerWidget {
  const PaintingLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(commandManagerProvider);
    ref.watch(canvasPainterProvider);
    ref.watch(paintProvider);
    ref.watch(toolBoxStateProvider);
    ref.watch(textToolOptionsStateProvider);

    final cachedImage = ref.watch(
      canvasStateProvider.select((state) => state.cachedImage),
    );

    final currentTool =
        ref.watch(toolBoxStateProvider.select((state) => state.currentTool));
    final isCachingCommand = ref
        .watch(canvasStateProvider.select((state) => state.isCachingCommand));

    bool isEraserDrawing = false;
    if (currentTool.type == ToolType.ERASER && currentTool is BrushTool) {
      isEraserDrawing = currentTool.isDrawing || isCachingCommand;
    }

    return RepaintBoundary(
      child: Opacity(
        opacity: 0.99,
        child: CustomPaint(
          foregroundPainter: CommandPainter(ref, cachedImage: cachedImage),
          child: cachedImage != null && !isEraserDrawing
              ? RawImage(
                  image: cachedImage,
                  filterQuality: FilterQuality.none,
                )
              : null,
        ),
      ),
    );
  }
}
