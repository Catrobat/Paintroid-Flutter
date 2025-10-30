import 'dart:ui';

import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/heart_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/star_shape_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';
import 'dummy_paint_factory.dart';
import 'dummy_path_factory.dart';
import 'dummy_version_strategy.dart';

class DummyCommandFactory {
  static const commandFactory = CommandFactory();

  static Iterable<Command> createCommandList(
    int numberOfCommands, {
    int version = Version.v1,
  }) {
    VersionStrategyManager.setStrategy(
        DummyVersionStrategy(pathCommandVersion: version));
    List<Command> commands = [];
    for (int i = 0; i < numberOfCommands; i++) {
      PathWithActionHistory originalPath =
          DummyPathFactory.createPathWithActionHistory(i * numberOfCommands);
      Paint originalPaint = DummyPaintFactory.createPaint();
      PathCommand command =
          commandFactory.createPathCommand(originalPath, originalPaint);
      commands.add(command);
    }
    return commands;
  }

  static PathCommand createPathCommand(
    PathWithActionHistory path,
    Paint paint, {
    int version = Version.v1,
  }) {
    VersionStrategyManager.setStrategy(
        DummyVersionStrategy(pathCommandVersion: version));
    return commandFactory.createPathCommand(path, paint);
  }

  static LineCommand createLineCommand(
    PathWithActionHistory path,
    Paint paint,
    Offset startPoint,
    Offset endPoint, {
    int version = Version.v1,
  }) {
    VersionStrategyManager.setStrategy(
        DummyVersionStrategy(lineCommandVersion: version));
    return commandFactory.createLineCommand(path, paint, startPoint, endPoint);
  }

  static SquareShapeCommand createSquareShapeCommand(
    Paint paint,
    Offset topLeft,
    Offset topRight,
    Offset bottomLeft,
    Offset bottomRight,
    ShapeStyle style, {
    int version = Version.v1,
  }) {
    VersionStrategyManager.setStrategy(
      DummyVersionStrategy(squareShapeCommandVersion: version),
    );
    return commandFactory.createSquareShapeCommand(
      paint,
      topLeft,
      topRight,
      bottomLeft,
      bottomRight,
      style,
    );
  }

  static EllipseShapeCommand createEllipseShapeCommand(
    Paint paint,
    double width,
    double height,
    Offset center,
    ShapeStyle style,
    double angle, {
    int version = Version.v1,
  }) {
    VersionStrategyManager.setStrategy(
      DummyVersionStrategy(ellipseShapeCommandVersion: version),
    );
    return commandFactory.createEllipseShapeCommand(
      paint,
      width,
      height,
      center,
      style,
      angle,
    );
  }

  static StarShapeCommand createStarShapeCommand(
    Paint paint,
    int numPoints,
    double angle,
    Offset center,
    ShapeStyle style,
    double radiusX,
    double radiusY, {
    int version = Version.v1,
  }) {
    VersionStrategyManager.setStrategy(
      DummyVersionStrategy(starShapeCommandVersion: version),
    );
    return commandFactory.createStarShapeCommand(
      paint,
      numPoints,
      angle,
      center,
      style,
      radiusX,
      radiusY,
    );
  }

  static HeartShapeCommand createHeartShapeCommand(
    Paint paint,
    double width,
    double height,
    double angle,
    Offset center,
    ShapeStyle style, {
    int version = Version.v1,
  }) {
    VersionStrategyManager.setStrategy(
      DummyVersionStrategy(heartShapeCommandVersion: version),
    );
    return commandFactory.createHeartShapeCommand(
      paint,
      width,
      height,
      angle,
      center,
      style,
    );
  }

  static bool compareCommandLists(
      Iterable<Command> commands1, Iterable<Command> commands2) {
    if (commands1.length != commands2.length) {
      return false;
    }
    var iterator1 = commands1.iterator;
    var iterator2 = commands2.iterator;

    while (iterator1.moveNext() && iterator2.moveNext()) {
      if (!areCommandsEqual(iterator1.current, iterator2.current)) {
        return false;
      }
    }
    return true;
  }

  static bool areCommandsEqual(Command command1, Command command2) {
    if (command1.runtimeType != command2.runtimeType) {
      return false;
    }

    if (command1 is PathCommand && command2 is PathCommand) {
      return command1.path == command2.path &&
          DummyPaintFactory.comparePaint(
            command1.paint,
            command2.paint,
          );
    } else if (command1 is EllipseShapeCommand &&
        command2 is EllipseShapeCommand) {
      return command1.center == command2.center &&
          command1.radiusX == command2.radiusX &&
          command1.radiusY == command2.radiusY &&
          command1.angle == command2.angle &&
          DummyPaintFactory.comparePaint(
            command1.paint,
            command2.paint,
          );
    } else if (command1 is LineCommand && command2 is LineCommand) {
      return command1.path == command2.path &&
          command1.startPoint == command2.startPoint &&
          command1.endPoint == command2.endPoint &&
          DummyPaintFactory.comparePaint(
            command1.paint,
            command2.paint,
          );
    } else if (command1 is SquareShapeCommand &&
        command2 is SquareShapeCommand) {
      return command1.topLeft == command2.topLeft &&
          command1.topRight == command2.topRight &&
          command1.bottomLeft == command2.bottomLeft &&
          command1.bottomRight == command2.bottomRight &&
          DummyPaintFactory.comparePaint(
            command1.paint,
            command2.paint,
          );
    }
    return false;
  }
}
