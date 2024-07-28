import 'dart:ui';

import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/circle_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/rectangle_shape_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';

class CommandFactory {
  const CommandFactory();

  PathCommand createPathCommand(
    PathWithActionHistory path,
    Paint paint,
  ) =>
      PathCommand(path, paint);

  LineCommand createLineCommand(
    PathWithActionHistory path,
    Paint paint,
    Offset startPoint,
    Offset endPoint,
  ) =>
      LineCommand(path, paint, startPoint, endPoint);

  RectangleShapeCommand createRectangleShapeCommand(
    Paint paint,
    Offset topLeft,
    Offset topRight,
    Offset bottomLeft,
    Offset bottomRight,
  ) =>
      RectangleShapeCommand(paint, topLeft, topRight, bottomLeft, bottomRight);

  CircleShapeCommand createCircleShapeCommand(
    Paint paint,
    double radius,
    Offset center,
  ) =>
      CircleShapeCommand(paint, radius, center);
}
