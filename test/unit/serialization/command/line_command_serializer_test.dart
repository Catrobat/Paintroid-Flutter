import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import '../utils/dummy_command_factory.dart';
import '../utils/dummy_paint_factory.dart';
import '../utils/dummy_path_factory.dart';

void main() {
  group('Version 1', () {
    test('Test LineCommand serialization as sourcePath', () {
      final originalPath = DummyPathFactory.createPathWithActionHistory(1);
      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const startPoint = Offset(0, 0);
      const endPoint = Offset(1, 1);

      final command = DummyCommandFactory.createLineCommand(
        originalPath,
        originalPaint,
        startPoint,
        endPoint,
        version: Version.v1,
      );
      command.setAsSourcePath();

      final json = command.toJson();
      final deserializedCommand = LineCommand.fromJson(json);

      expect(command.version, equals(deserializedCommand.version));
      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(originalPath, equals(deserializedCommand.path));
      expect(startPoint, equals(deserializedCommand.startPoint));
      expect(endPoint, equals(deserializedCommand.endPoint));
      expect(true, command.isSourcePath);
    });

    test('Test LineCommand serialization not as sourcePath', () {
      final originalPath = DummyPathFactory.createPathWithActionHistory(1);
      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const startPoint = Offset(0, 0);
      const endPoint = Offset(1, 1);

      final command = DummyCommandFactory.createLineCommand(
        originalPath,
        originalPaint,
        startPoint,
        endPoint,
        version: Version.v1,
      );

      final json = command.toJson();
      final deserializedCommand = LineCommand.fromJson(json);

      expect(command.version, equals(deserializedCommand.version));
      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(originalPath, equals(deserializedCommand.path));
      expect(startPoint, equals(deserializedCommand.startPoint));
      expect(endPoint, equals(deserializedCommand.endPoint));
      expect(false, command.isSourcePath);
    });
  });
}
