import 'package:command/command.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_library/io_library.dart';

import '../utils/dummy_command_factory.dart';
import '../utils/dummy_paint_factory.dart';
import '../utils/dummy_path_factory.dart';

void main() {
  group('Version 1', () {
    test('Test PathCommand serialization with one path', () {
      PathWithActionHistory originalPath =
          DummyPathFactory.createPathWithActionHistory(1);
      Paint originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      PathCommand command = DummyCommandFactory.createPathCommand(
        originalPath,
        originalPaint,
        version: Version.v1,
      );

      var json = command.toJson();
      PathCommand deserializedCommand = PathCommand.fromJson(json);

      expect(command.version, equals(deserializedCommand.version));
      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(originalPath, equals(deserializedCommand.path));
    });

    test('Test PathCommand serialization with multiple paths', () {
      PathWithActionHistory originalPath =
          DummyPathFactory.createPathWithActionHistory(5);
      Paint originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      PathCommand command = DummyCommandFactory.createPathCommand(
        originalPath,
        originalPaint,
        version: Version.v1,
      );

      var json = command.toJson();
      PathCommand deserializedCommand = PathCommand.fromJson(json);

      expect(command.version, equals(deserializedCommand.version));
      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(originalPath, equals(deserializedCommand.path));
    });
  });
}
