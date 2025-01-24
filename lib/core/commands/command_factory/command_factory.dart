import 'package:flutter/cupertino.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/circle_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';

class CommandFactory {
  const CommandFactory();

  PathCommand createPathCommand(
    PathWithActionHistory path,
    Paint paint,
    ValueKey layerKey,
  ) =>
      PathCommand(path, paint, layerKey);

  LineCommand createLineCommand(
    PathWithActionHistory path,
    Paint paint,
    Offset startPoint,
    Offset endPoint,
    ValueKey layerKey,
  ) =>
      LineCommand(path, paint, layerKey, startPoint, endPoint);

  SquareShapeCommand createSquareShapeCommand(
    Paint paint,
    Offset topLeft,
    Offset topRight,
    Offset bottomLeft,
    Offset bottomRight,
    ValueKey layerKey,
  ) =>
      SquareShapeCommand(
          paint, layerKey, topLeft, topRight, bottomLeft, bottomRight);

  CircleShapeCommand createCircleShapeCommand(
    Paint paint,
    double radius,
    Offset center,
    ValueKey layerKey,
  ) =>
      CircleShapeCommand(paint, layerKey, radius, center);

  SprayCommand createSprayCommand(
    List<Offset> points,
    Paint paint,
    ValueKey layerKey,
  ) {
    return SprayCommand(points, paint, layerKey);
  }
}
