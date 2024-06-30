// finalize_text_command.dart

import 'package:flutter/cupertino.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:equatable/equatable.dart';

class FinalizeTextCommand extends GraphicCommand with EquatableMixin {
  final Offset point;
  final String text;

  FinalizeTextCommand(this.point, this.text, Paint paint) : super(paint);

  @override
  void call(Canvas canvas) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: paint.color,
          fontSize: paint.strokeWidth,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, point);
  }

  void undo(Canvas canvas) {
    // TODO
  }

  @override
  List<Object?> get props => [point, text, paint];

  @override
  bool? get stringify => true;

  @override
  Map<String, dynamic> toJson() {
    return {
      'point': {'dx': point.dx, 'dy': point.dy},
      'text': text,
      'paint': const PaintConverter().toJson(paint),
    };
  }
}
