import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/circle_shape_command.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

import '../utils/dummy_command_factory.dart';
import '../utils/dummy_paint_factory.dart';

void main() {
  group('Version 1', () {
    test('Test Circle serialization', () {
      const type = SerializerType.CIRCLE_SHAPE_COMMAND;
      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const center = Offset(100, 100);
      const radius = 50.0;

      final command = DummyCommandFactory.createCircleShapeCommand(
        originalPaint,
        radius,
        center,
        version: Version.v1,
      );

      final deserializedCommand = CircleShapeCommand.fromJson(command.toJson());

      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(command.version, equals(deserializedCommand.version));
      expect(deserializedCommand.center, equals(center));
      expect(deserializedCommand.radius, equals(radius));
      expect(deserializedCommand.type, equals(type));
    });
  });
}
