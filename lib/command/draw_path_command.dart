import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'graphic_command.dart';

class DrawPathCommand extends GraphicCommand with EquatableMixin {
  const DrawPathCommand(this._path, super.paint);

  final Path _path;

  @override
  void call(Canvas canvas) {
    canvas.drawPath(_path, paint);
  }

  @override
  List<Object?> get props => [paint, _path];
}
