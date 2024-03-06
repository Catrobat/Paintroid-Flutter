import 'dart:ui';

import 'package:command/command.dart';
import 'package:io_library/io_library.dart';

abstract class GraphicCommand extends Command {
  const GraphicCommand(this.paint);

  @PaintConverter()
  final Paint paint;

  void call(Canvas canvas);
}
