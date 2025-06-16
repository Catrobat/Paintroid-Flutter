import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/text_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/oval_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/heart_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/star_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/enums/shape_style.dart';

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

  SquareShapeCommand createSquareShapeCommand(
    Paint paint,
    Offset topLeft,
    Offset topRight,
    Offset bottomLeft,
    Offset bottomRight,
    ShapeStyle style,
  ) =>
      SquareShapeCommand(
          paint, topLeft, topRight, bottomLeft, bottomRight, style);

  OvalShapeCommand createOvalShapeCommand(
    Paint paint,
    double width,
    double height,
    Offset center,
    ShapeStyle style,
    double angle,
  ) =>
      OvalShapeCommand(paint, width, height, center, style, angle);

  StarShapeCommand createStarShapeCommand(
    Paint paint,
    int numPoints,
    double angle,
    Offset center,
    ShapeStyle style,
    double radiusX,
    double radiusY,
  ) =>
      StarShapeCommand(
        paint,
        numPoints,
        angle,
        center,
        style,
        radiusX,
        radiusY,
      );

  HeartShapeCommand createHeartShapeCommand(
    Paint paint,
    double width,
    double height,
    double angle,
    Offset center,
    ShapeStyle style,
  ) =>
      HeartShapeCommand(paint, width, height, angle, center, style);

  SprayCommand createSprayCommand(List<Offset> points, Paint paint) {
    return SprayCommand(points, paint);
  }
}
