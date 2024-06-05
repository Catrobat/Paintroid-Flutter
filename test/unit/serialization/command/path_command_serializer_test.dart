// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
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
