// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/draw_path_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';

class CommandFactory {
  const CommandFactory();

  DrawPathCommand createDrawPathCommand(
          PathWithActionHistory path, Paint paint) =>
      DrawPathCommand(path, paint);
}
