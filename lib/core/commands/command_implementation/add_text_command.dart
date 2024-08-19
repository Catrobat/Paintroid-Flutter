import 'package:flutter/cupertino.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:equatable/equatable.dart';

class AddTextCommand extends GraphicCommand with EquatableMixin {
  final Offset point;
  final String text;
  final TextStyle style;

  AddTextCommand(
    this.point,
    this.text,
    this.style,
    Paint paint,
  ) : super(paint);

  @override
  void call(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    final textOffset =
        point - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
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
