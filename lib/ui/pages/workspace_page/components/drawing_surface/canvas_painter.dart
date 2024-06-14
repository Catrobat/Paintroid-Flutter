// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/command_painter.dart';
import 'package:paintroid/core/providers/object/canvas_dirty_notifier.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/checkmark_clicked_state.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
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
    final cachedImage = ref.watch(
      canvasStateProvider.select((state) => state.cachedImage),
    );
    final commandManager = ref.watch(commandManagerProvider);

    ref.watch(CanvasDirtyNotifier.provider);
    ref.watch(CheckMarkClickedState.provider);
    // ref.watch(brushToolStateProvider); for stroke change??

    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    return RepaintBoundary(
      child: Opacity(
        opacity: 0.99,
        child: CustomPaint(
          foregroundPainter: CommandPainter(
            commandManager,
            currentTool,
          ),
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
