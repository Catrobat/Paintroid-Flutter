import 'dart:ui';

import 'package:paintroid/command/draw_path_command.dart';
import 'package:paintroid/command/graphic_command.dart';

class CommandFactory {
  GraphicCommand createDrawPathCommand(Path path, Paint paint) =>
      DrawPathCommand(path, paint);
}
