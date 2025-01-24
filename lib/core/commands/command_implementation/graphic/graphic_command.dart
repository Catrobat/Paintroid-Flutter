import 'package:flutter/cupertino.dart';
import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:paintroid/core/json_serialization/converter/value_key_converter.dart';

abstract class GraphicCommand extends Command {
  const GraphicCommand(this.paint, this.layerKey);

  @PaintConverter()
  final Paint paint;

  @ValueKeyConverter()
  final ValueKey layerKey;

  void call(Canvas canvas);
}
