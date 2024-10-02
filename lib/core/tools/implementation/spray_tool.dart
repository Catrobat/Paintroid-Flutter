import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/tools/tool.dart';

class SprayTool extends Tool with EquatableMixin {
  SprayTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  final GraphicFactory graphicFactory;

  List<Offset> points = [];
  late Paint paint;

  final int particlesPerMove = 20;
  final double sprayRadius = 20.0;
  final Random random = Random();

  @override
  List<Object?> get props => [commandManager, commandFactory, graphicFactory];

  @override
  void onDown(Offset point, Paint paint) {
    this.paint = graphicFactory.copyPaint(paint);
    _addSprayPoints(point);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    _addSprayPoints(point);
  }

  @override
  void onUp(Offset point, Paint paint) {
    _addSprayPoints(point);
    _commitSprayCommand();
  }

  @override
  void onCancel() {
    points.clear();
  }

  @override
  void onPlus() {}

  @override
  void onCheckmark(Paint paint) {
    _commitSprayCommand();
  }

  @override
  void onRedo() {
    commandManager.redo();
  }

  @override
  void onUndo() {
    commandManager.undo();
  }

  void _addSprayPoints(Offset center) {
    for (int i = 0; i < particlesPerMove; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = random.nextDouble() * sprayRadius;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      points.add(Offset(dx, dy));
    }
  }

  void _commitSprayCommand() {
    if (points.isNotEmpty) {
      final command = commandFactory.createSprayCommand(points, paint);
      commandManager.addGraphicCommand(command);
      points = [];
    }
  }
}
