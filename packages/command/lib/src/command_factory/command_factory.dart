import 'dart:ui';

import 'package:command/command.dart';

class CommandFactory {
  const CommandFactory();

  DrawPathCommand createDrawPathCommand(
          PathWithActionHistory path, Paint paint) =>
      DrawPathCommand(path, paint);

  LinePathCommand createLinePathCommand(PathWithActionHistory path, Paint paint,
          Offset startPoint, Offset endPoint) =>
      LinePathCommand(path, paint, startPoint, endPoint);
}
