import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/rectangle_shape_command.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

import '../utils/dummy_command_factory.dart';
import '../utils/dummy_paint_factory.dart';

void main() {
  group('Version 1', () {
    test('Test RectangleShapeCommand serialization', () {
      const type = SerializerType.RECTANGLE_SHAPE_COMMAND;

      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const originalTopLeft = Offset(0, 0);
      const originalTopRight = Offset(1, 0);
      const originalBottomLeft = Offset(0, 1);
      const originalBottomRight = Offset(1, 1);

      final command = DummyCommandFactory.createRectangleShapeCommand(
        originalPaint,
        originalTopLeft,
        originalTopRight,
        originalBottomLeft,
        originalBottomRight,
        version: Version.v1,
      );

      final deserializedCommand =
          RectangleShapeCommand.fromJson(command.toJson());

      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(command.version, equals(deserializedCommand.version));
      expect(deserializedCommand.topLeft, equals(originalTopLeft));
      expect(deserializedCommand.topRight, equals(originalTopRight));
      expect(deserializedCommand.bottomLeft, equals(originalBottomLeft));
      expect(deserializedCommand.bottomRight, equals(originalBottomRight));
      expect(deserializedCommand.type, equals(type));
    });
  });
}
