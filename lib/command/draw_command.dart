import 'dart:ui';

import 'command.dart';

abstract class DrawCommand extends Command {
  DrawCommand(this.paint);

  final Paint paint;

  void call(Canvas canvas);
}