import 'package:flutter/widgets.dart';

import 'draw_command.dart';

class DrawPath implements DrawCommand {
  const DrawPath(this.path, this.paint);

  final Path path;

  @override
  final Paint paint;

  @override
  void call(Canvas canvas) {
    canvas.drawPath(path, paint);
  }
}
