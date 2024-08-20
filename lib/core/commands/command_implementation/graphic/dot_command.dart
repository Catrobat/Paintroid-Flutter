import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';

class DotCommand extends GraphicCommand with EquatableMixin {
  final Offset position;

  DotCommand(this.position, Paint paint) : super(paint);

  @override
  void call(Canvas canvas) {
    canvas.drawCircle(position, 0.5, paint);
  }

  @override
  List<Object?> get props => [position, paint];

  @override
  bool? get stringify => true;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'DotCommand',
      'position': {'dx': position.dx, 'dy': position.dy},
      'paint': paintToJson(paint),
    };
  }

  Map<String, dynamic> paintToJson(Paint paint) {
    return {
      'color': paint.color.value,
      'strokeWidth': paint.strokeWidth,
      'style': paint.style.index,
    };
  }
}
