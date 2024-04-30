// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/draw_path_command.dart';
import 'package:paintroid/core/commands/utils/path_with_action_history.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import '../utils/dummy_command_factory.dart';
import '../utils/dummy_paint_factory.dart';
import '../utils/dummy_path_factory.dart';

void main() {
  group('Version 1', () {
    test('Test DrawPathCommand serialization with one path', () {
      PathWithActionHistory originalPath =
          DummyPathFactory.createPathWithActionHistory(1);
      Paint originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      DrawPathCommand command = DummyCommandFactory.createDrawPathCommand(
        originalPath,
        originalPaint,
        version: Version.v1,
      );

      var json = command.toJson();
      DrawPathCommand deserializedCommand = DrawPathCommand.fromJson(json);

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

    test('Test DrawPathCommand serialization with multiple paths', () {
      PathWithActionHistory originalPath =
          DummyPathFactory.createPathWithActionHistory(5);
      Paint originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      DrawPathCommand command = DummyCommandFactory.createDrawPathCommand(
        originalPath,
        originalPaint,
        version: Version.v1,
      );

      var json = command.toJson();
      DrawPathCommand deserializedCommand = DrawPathCommand.fromJson(json);

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
