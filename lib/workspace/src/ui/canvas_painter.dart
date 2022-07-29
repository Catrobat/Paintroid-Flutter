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
    final backgroundImage = ref.watch(
      WorkspaceState.provider.select((value) => value.backgroundImage),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: TransparencyGridPattern(
            numberOfSquaresAlongWidth: 100,
            child: backgroundImage != null
                ? RawImage(image: backgroundImage)
                : null,
          ),
        ),
        RepaintBoundary(
          child: Consumer(
            builder: (context, ref, child) {
              final commandsCachedImage = ref.watch(
                CanvasState.provider.select((value) => value.lastRenderedImage),
              );
              return Consumer(
                builder: (context, ref, child) {
                  ref.watch(CanvasDirtyState.provider);
                  return CustomPaint(
                    foregroundPainter: CommandPainter(
                      ref.watch(CommandManager.provider),
                    ),
                    child: child,
                  );
                },
                child: commandsCachedImage != null
                    ? RawImage(image: commandsCachedImage)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
