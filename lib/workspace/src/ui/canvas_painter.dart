import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';

import '../state/canvas_dirty_state.dart';
import '../state/canvas_state_notifier.dart';
import '../state/workspace_state_notifier.dart';
import 'command_painter.dart';
import 'transparency_grid_pattern.dart';

class CanvasPainter extends ConsumerWidget {
  const CanvasPainter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedImage = ref.watch(
      WorkspaceState.provider.select((value) => value.loadedImage),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: TransparencyGridPattern(
            numberOfSquaresAlongWidth: 100,
            child: loadedImage != null
                ? RawImage(image: loadedImage, fit: BoxFit.fill)
                : null,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            ref.watch(CanvasDirtyState.provider);
            final canvasImage = ref.watch(
              CanvasState.provider.select((value) => value.lastRenderedImage),
            );
            return CustomPaint(
              foregroundPainter:
                  CommandPainter(ref.watch(CommandManager.provider)),
              child: canvasImage != null
                  ? RawImage(image: canvasImage, fit: BoxFit.fill)
                  : null,
            );
          },
        ),
      ],
    );
  }
}
