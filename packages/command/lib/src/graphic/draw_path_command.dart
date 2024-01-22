import 'dart:ui';
import 'package:command/command.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/widgets.dart';

class DrawPathCommand extends GraphicCommand {
  const DrawPathCommand(this.path, super.paint);

  final PathWithActionHistory path;

  @override
  void call(Canvas canvas) {
    canvas.drawPath(path, paint);
  }

  @override
  List<Object?> get props => [paint, path];
}
