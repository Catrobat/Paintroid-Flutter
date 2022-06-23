import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:paintroid/command/graphic_command.dart';
import 'package:paintroid/core/graphic_factory.dart';

import 'tool.dart';

class BrushTool extends Tool<GraphicCommand> with EquatableMixin {
  BrushTool({
    required super.paint,
    required super.commandManager,
    required super.commandFactory,
    required this.graphicFactory,
  });

  final GraphicFactory graphicFactory;

  @visibleForTesting
  late Path pathToDraw;

  @override
  void onDown(Offset point) {
    pathToDraw = graphicFactory.createPath()..moveTo(point.dx, point.dy);
    final command = commandFactory.createDrawPathCommand(pathToDraw, paint);
    commandManager.commands.add(command);
  }

  @override
  void onDrag(Offset point) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset? point) {
    // This basically makes the path a point.
    if (pathToDraw.getBounds().size == Size.zero) {
      pathToDraw.close();
    }
  }

  @override
  List<Object?> get props =>
      [paint, commandManager, commandFactory, graphicFactory];
}
