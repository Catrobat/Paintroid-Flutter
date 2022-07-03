import 'dart:ui';

import 'package:paintroid/core/path_with_action_history.dart';

import 'implementation/command/graphic/draw_path_command.dart';

class CommandFactory {
  const CommandFactory();

  DrawPathCommand createDrawPathCommand(
          PathWithActionHistory path, Paint paint) =>
      DrawPathCommand(path, paint);
}
