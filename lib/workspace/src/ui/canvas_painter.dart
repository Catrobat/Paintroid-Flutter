import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';

import '../state/canvas_dirty_state.dart';
import '../state/canvas_state_notifier.dart';
import 'checkerboard_pattern.dart';
import 'command_painter.dart';

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
          _backgroundLayer,
          _paintingLayer,
        ],
      ),
    );
  }

  Widget get _backgroundLayer {
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

  Widget get _paintingLayer {
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
            child: cachedImage != null ? RawImage(image: cachedImage) : null,
          );
        },
      ),
    );
  }
}
