import 'dart:ui';

import 'package:paintroid/command/src/implementation/command/graphic/draw_path_command.dart';
import 'package:paintroid/core/path_with_action_history.dart';

class CommandFactory {
  const CommandFactory();

  DrawPathCommand createDrawPathCommand(
          PathWithActionHistory path, Paint paint) =>
      DrawPathCommand(path, paint);
}
