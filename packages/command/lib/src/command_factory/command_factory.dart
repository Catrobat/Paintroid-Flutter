// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:command/command.dart';

class CommandFactory {
  const CommandFactory();

  DrawPathCommand createDrawPathCommand(
          PathWithActionHistory path, Paint paint) =>
      DrawPathCommand(path, paint);
}
