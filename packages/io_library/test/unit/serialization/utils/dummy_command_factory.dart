// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:command/command.dart';

// Project imports:
import 'package:io_library/io_library.dart';
import 'dummy_paint_factory.dart';
import 'dummy_path_factory.dart';
import 'dummy_version_strategy.dart';

class DummyCommandFactory {
  static Iterable<Command> createCommandList(int numberOfCommands,
      {int version = Version.v1}) {
    CommandFactory commandFactory = const CommandFactory();
    VersionStrategyManager.setStrategy(
        DummyVersionStrategy(drawPathCommandVersion: version));
    List<Command> commands = [];
    for (int i = 0; i < numberOfCommands; i++) {
      PathWithActionHistory originalPath =
          DummyPathFactory.createPathWithActionHistory(i * numberOfCommands);
      Paint originalPaint = DummyPaintFactory.createPaint();
      DrawPathCommand command =
          commandFactory.createDrawPathCommand(originalPath, originalPaint);
      commands.add(command);
    }
    return commands;
  }

  static DrawPathCommand createDrawPathCommand(
      PathWithActionHistory path, Paint paint,
      {int version = Version.v1}) {
    CommandFactory commandFactory = const CommandFactory();
    VersionStrategyManager.setStrategy(
        DummyVersionStrategy(drawPathCommandVersion: version));
    return commandFactory.createDrawPathCommand(path, paint);
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
    if (command1 is DrawPathCommand && command2 is DrawPathCommand) {
      return command1.path == command2.path &&
          DummyPaintFactory.comparePaint(
            command1.paint,
            command2.paint,
          );
    }
    return false;
  }
}
