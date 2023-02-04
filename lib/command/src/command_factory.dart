import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/path_with_action_history.dart';

import 'package:paintroid/command/src/implementation/command/graphic/draw_path_command.dart';

class CommandFactory {
  const CommandFactory();

  static final provider = Provider((ref) => const CommandFactory());

  DrawPathCommand createDrawPathCommand(PathWithActionHistory path, Paint paint) => DrawPathCommand(path, paint);
}
