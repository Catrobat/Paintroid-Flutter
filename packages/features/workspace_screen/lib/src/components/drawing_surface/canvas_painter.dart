// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:command/command_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:workspace_screen/workspace_screen.dart';

class CanvasPainter extends ConsumerWidget {
  const CanvasPainter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(canvasStateProvider.select((state) => state.size));
    return Container(
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
    final cachedImage = ref.watch(
      canvasStateProvider.select((state) => state.cachedImage),
    );
    final commands = ref.watch(commandManagerProvider);

    ref.watch(CanvasDirtyState.provider);

    return RepaintBoundary(
      child: Opacity(
        opacity: 0.99,
        child: CustomPaint(
          foregroundPainter: CommandPainter(commands),
          child: cachedImage != null
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
