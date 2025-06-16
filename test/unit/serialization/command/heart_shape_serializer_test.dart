import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/heart_shape_command.dart';
import 'package:paintroid/core/enums/shape_style.dart'; // Added import
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

import '../utils/dummy_command_factory.dart';
import '../utils/dummy_paint_factory.dart';

void main() {
  group('Version 1', () {
    test('Test Star serialization', () {
      const type = SerializerType.HEART_SHAPE_COMMAND;
      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const center = Offset(100, 100);
      const width = 50.0;
      const height = 50.0;
      const angle = 0.0;

      final command = DummyCommandFactory.createHeartShapeCommand(
        originalPaint,
        width,
        height,
        angle,
        center,
        ShapeStyle.outline,
      );

      final deserializedCommand = HeartShapeCommand.fromJson(command.toJson());

      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(command.version, equals(deserializedCommand.version));
      expect(deserializedCommand.center, equals(center));
      expect(deserializedCommand.type, equals(type));
      expect(deserializedCommand.angle, equals(angle));
      expect(deserializedCommand.width, equals(width));
      expect(deserializedCommand.height, equals(height));
      expect(deserializedCommand.style, equals(ShapeStyle.outline));
    });
  });
}
