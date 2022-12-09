import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/workspace/src/state/canvas_dirty_state.dart';
import 'package:paintroid/workspace/src/state/canvas_state_notifier.dart';
import 'package:paintroid/workspace/src/ui/checkerboard_pattern.dart';
import 'package:paintroid/workspace/src/ui/command_painter.dart';

class CanvasPainter extends ConsumerWidget {
  const CanvasPainter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(CanvasState.provider.select((state) => state.size));
    return Container(
      width: size.width,
      height: size.height,
      foregroundDecoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(width: 0.5)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _BackgroundLayer(),
          _PaintingLayer(),
        ],
      ),
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Consumer(
        builder: (context, ref, child) {
          final backgroundImage = ref.watch(
            CanvasState.provider.select((state) => state.backgroundImage),
          );
          return CheckerboardPattern(
            child: backgroundImage != null
                ? RawImage(image: backgroundImage)
                : null,
          );
        },
      ),
    );
  }
}

class _PaintingLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Consumer(
        builder: (context, ref, child) {
          final cachedImage = ref.watch(
            CanvasState.provider.select((state) => state.cachedImage),
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
            child: cachedImage != null
                ? RawImage(
                    image: cachedImage,
                    filterQuality: FilterQuality.none,
                  )
                : null,
          );
        },
      ),
    );
  }
}
