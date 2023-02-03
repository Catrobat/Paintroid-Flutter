import 'dart:ui';

import 'package:paintroid/command/src/command.dart';

abstract class GraphicCommand extends Command {
  const GraphicCommand(this.paint);

  final Paint paint;

  void call(Canvas canvas);
}
