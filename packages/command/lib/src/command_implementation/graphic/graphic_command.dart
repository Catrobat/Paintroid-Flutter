// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:io_library/io_library.dart';

// Project imports:
import 'package:command/command.dart';

abstract class GraphicCommand extends Command {
  const GraphicCommand(this.paint);

  @PaintConverter()
  final Paint paint;

  void call(Canvas canvas);
}
