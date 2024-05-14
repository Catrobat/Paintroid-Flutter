// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';

abstract class GraphicCommand extends Command {
  const GraphicCommand(this.paint);

  @PaintConverter()
  final Paint paint;

  void call(Canvas canvas);
}
