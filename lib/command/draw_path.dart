import 'package:flutter/widgets.dart';

import 'draw_command.dart';

class DrawPath extends DrawCommand {
  DrawPath(this.path, Paint paint) : super(paint);

  final Path path;

  @override
  void call(Canvas canvas) {
    canvas.drawPath(path, paint);
  }
}
