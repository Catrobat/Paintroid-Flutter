import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/ui/graphic_command_painter.dart';
import 'package:paintroid/workspace/workspace.dart';

class Workspace {
  const Workspace(this.ref);

  static final provider = Provider((ref) => Workspace(ref));

  final Ref ref;

  Future<Image> get scaledCanvasImage async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final commandManager = ref.read(SyncCommandManager.provider);
    final workspaceState = ref.read(WorkspaceStateNotifier.provider);
    final canvasState = ref.read(CanvasStateNotifier.provider);
    final canvasWidth = canvasState.width;
    final exportWidth = workspaceState.exportWidth;
    final exportHeight = workspaceState.exportHeight;
    final scaledSize = Size(exportWidth.toDouble(), exportHeight.toDouble());
    final painter = GraphicCommandPainter(commands: commandManager.commands);
    canvas.scale(exportWidth / canvasWidth);
    if (workspaceState.loadedImage != null) {
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, scaledSize.width, scaledSize.height),
          image: workspaceState.loadedImage!,
          fit: BoxFit.cover);
    }
    painter.paint(canvas, scaledSize);
    final picture = recorder.endRecording();
    return await picture.toImage(exportWidth, exportHeight);
  }
}
