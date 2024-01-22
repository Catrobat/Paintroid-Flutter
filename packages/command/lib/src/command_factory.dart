import 'dart:ui';

import 'package:command/command.dart';
import 'package:component_library/component_library.dart';

class CommandFactory {
  const CommandFactory();

  DrawPathCommand createDrawPathCommand(
          PathWithActionHistory path, Paint paint) =>
      DrawPathCommand(path, paint);
}
