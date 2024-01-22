import 'dart:ui';

import 'package:command/command.dart';

abstract class GraphicCommand extends Command {
  const GraphicCommand(this.paint);

  final Paint paint;

  void call(Canvas canvas);
}
