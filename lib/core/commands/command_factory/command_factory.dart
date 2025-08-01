import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clipboard_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/delete_region_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';
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

  SquareShapeCommand createSquareShapeCommand(
    Paint paint,
    Offset topLeft,
    Offset topRight,
    Offset bottomLeft,
    Offset bottomRight,
  ) =>
      SquareShapeCommand(paint, topLeft, topRight, bottomLeft, bottomRight);

  EllipseShapeCommand createEllipseShapeCommand(
    Paint paint,
    double radiusX,
    double radiusY,
    Offset center,
    double angle,
  ) =>
      EllipseShapeCommand(
        paint,
        radiusX,
        radiusY,
        center,
        angle: angle,
      );

  ClipboardCommand createClipboardCommand(
    Paint paint,
    Uint8List imageData,
    ui.Offset offset,
    double scale,
    double rotation,
  ) =>
      ClipboardCommand(
        paint,
        imageData,
        offset,
        scale,
        rotation,
      );

  SprayCommand createSprayCommand(List<Offset> points, Paint paint) {
    return SprayCommand(points, paint);
  }

  DeleteRegionCommand createDeleteRegionCommand(
    ui.Rect region,
  ) =>
      DeleteRegionCommand(
        Paint(),
        region,
      );
}
