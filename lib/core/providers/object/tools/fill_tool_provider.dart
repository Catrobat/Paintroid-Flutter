import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/implementation/fill_tool.dart';

final fillToolProvider = Provider<FillTool>((ref) {
  Future<ui.Image?> sourceImageProvider() async {
    final canvasState = ref.read(canvasStateProvider);
    final size = canvasState.size;
    if (size.width <= 0 || size.height <= 0) {
      return null;
    }

    final recorder = ref.read(graphicFactoryProvider).createPictureRecorder();
    final canvas =
        ref.read(graphicFactoryProvider).createCanvasWithRecorder(recorder);
    final bounds = ui.Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(bounds);

    if (canvasState.backgroundImage != null) {
      canvas.drawImage(
          canvasState.backgroundImage!, ui.Offset.zero, ui.Paint());
    }
    if (canvasState.cachedImage != null) {
      canvas.drawImage(canvasState.cachedImage!, ui.Offset.zero, ui.Paint());
    }

    final picture = recorder.endRecording();
    return picture.toImage(size.width.toInt(), size.height.toInt());
  }

  Future<void> onFillApplied() async {
    await ref.read(canvasStateProvider.notifier).updateCachedImage();
    ref.read(canvasPainterProvider.notifier).repaint();
  }

  return FillTool(
    commandManager: ref.watch(commandManagerProvider),
    commandFactory: ref.watch(commandFactoryProvider),
    graphicFactory: ref.watch(graphicFactoryProvider),
    type: ToolType.FILL,
    getSourceImage: sourceImageProvider,
    onFillApplied: onFillApplied,
  );
});
