import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';

import '../state/canvas_state_notifier.dart';
import '../state/workspace_state_notifier.dart';
import 'command_painter.dart';
import 'transparency_grid_pattern.dart';

class DrawCanvas extends ConsumerWidget {
  const DrawCanvas({super.key});

  static final _canvasKey = GlobalKey(debugLabel: "DrawCanvas");

  static final sizeProvider = FutureProvider((ref) {
    final completer = Completer<Size>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final ctx = _canvasKey.currentContext!;
      final renderBox = ctx.findRenderObject() as RenderBox;
      completer.complete(renderBox.size);
    });
    return completer.future;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadedImage = ref.watch(
      WorkspaceState.provider.select((value) => value.loadedImage),
    );
    final canvasImage = ref.watch(
      CanvasState.provider.select((value) => value.lastCompiledImage),
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
        CustomPaint(
          key: _canvasKey,
          foregroundPainter: CommandPainter(ref.watch(CommandManager.provider)),
          child: canvasImage != null
              ? RawImage(image: canvasImage, fit: BoxFit.fill)
              : null,
        ),
      ],
    );
  }
}
