import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/tools/tool.dart';

class SprayTool extends Tool {
  final GraphicFactory graphicFactory;
  final Size drawingSurfaceSize;

  @visibleForTesting
  late SprayCommand sprayCommand;
  late Paint paint;

  SprayTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    required this.drawingSurfaceSize,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  final int particlesPerMove = 20;
  final double sprayRadius = 30.0;
  final Random random = Random();

  @override
  void onDown(Offset point, Paint paint) {
    this.paint = graphicFactory.copyPaint(paint);
    final initialPoints = _generateSprayPoints(point);
    sprayCommand = commandFactory.createSprayCommand(initialPoints, this.paint);
    commandManager.addGraphicCommand(sprayCommand);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    final newPoints = _generateSprayPoints(point);
    sprayCommand.points.addAll(newPoints);
  }

  @override
  void onUp(Offset point, Paint paint) {
  }

  @override
  void onCancel() {
    commandManager.discardLastCommand();
  }

  @override
  void onCheckmark(Paint paint) {}

  @override
  void onPlus() {}

  @override
  void onRedo() {
    commandManager.redo();
  }

  @override
  void onUndo() {
    commandManager.undo();
  }

  List<Offset> _generateSprayPoints(Offset center) {
    List<Offset> points = [];
    for (int i = 0; i < particlesPerMove; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = random.nextDouble() * sprayRadius;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);

        points.add(Offset(dx, dy));
      }
    return points;
  }
}