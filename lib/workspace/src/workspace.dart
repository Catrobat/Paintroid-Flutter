import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/ui/graphic_command_painter.dart';

import 'workspace_state_notifier.dart';

class Workspace {
  const Workspace(this.ref, {required this.exportWidth});

  static final provider = Provider((ref) => Workspace(ref, exportWidth: 1080));

  final Ref ref;
  final int exportWidth;

  Future<Image> get scaledCanvasImage async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final commandManager = ref.read(SyncCommandManager.provider);
    final canvasState = ref.read(WorkspaceStateNotifier.provider).canvasState;
    final exportHeight = exportWidth ~/ canvasState.aspectRatio;
    final scaledSize = Size(exportWidth.toDouble(), exportHeight.toDouble());
    final painter = GraphicCommandPainter(commands: commandManager.commands);
    canvas.scale(exportWidth / canvasState.width);
    painter.paint(canvas, scaledSize);
    final picture = recorder.endRecording();
    return await picture.toImage(exportWidth, exportHeight);
  }
}
