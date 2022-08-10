import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:paintroid/core/path_with_action_history.dart';

import '../../../graphic_command.dart';

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
