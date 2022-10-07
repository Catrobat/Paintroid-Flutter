import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/path_with_action_history.dart';
import 'package:paintroid/ui/tool_options/brush/brush_options_state.dart';

import 'tool.dart';

class BrushTool extends Tool with EquatableMixin {
  BrushTool({
    required super.paint,
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
  });

  static final provider = Provider(
    (ref) {
      final brushPaint = ref.watch(GraphicFactory.provider).createPaint()
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;
      ref.listen<BrushOptionsState>(BrushOptionsState.provider, (_, current) {
        brushPaint
          ..color = current.color
          ..strokeCap = current.strokeCap
          ..strokeWidth = current.strokeWidth;
      }, fireImmediately: true);
      return BrushTool(
        paint: brushPaint,
        commandManager: ref.watch(CommandManager.provider),
        commandFactory: ref.watch(CommandFactory.provider),
        graphicFactory: ref.watch(GraphicFactory.provider),
      );
    },
  );

  final GraphicFactory graphicFactory;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;

  @override
  void onDown(Offset point) {
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);
    final command = commandFactory.createDrawPathCommand(pathToDraw, paint);
    commandManager.addGraphicCommand(command);
  }

  @override
  void onDrag(Offset point) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset? point) {
    if (pathToDraw.getBounds().size == Size.zero) {
      pathToDraw.close();
    }
  }

  @override
  List<Object?> get props => [commandManager, commandFactory, graphicFactory];
}
