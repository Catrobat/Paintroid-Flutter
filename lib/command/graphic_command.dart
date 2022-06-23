import 'dart:ui';

import 'command.dart';

abstract class GraphicCommand extends Command {
  const GraphicCommand(this.paint);

  final Paint paint;

  void call(Canvas canvas);
}
