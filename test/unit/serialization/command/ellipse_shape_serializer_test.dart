import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

import '../utils/dummy_command_factory.dart';
import '../utils/dummy_paint_factory.dart';

void main() {
  group('Version 1', () {
    test('Test Ellipse serialization', () {
      const type = SerializerType.ELLIPSE_SHAPE_COMMAND;
      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const center = Offset(100, 100);
      const radius = 50.0;
      const angle = 0.0;
      final style = ShapeStyle.outline;

      final command = DummyCommandFactory.createEllipseShapeCommand(
        originalPaint,
        radius,
        radius,
        center,
        style,
        angle,
      );

      final deserializedCommand =
          EllipseShapeCommand.fromJson(command.toJson());

      expect(
          DummyPaintFactory.comparePaint(
            originalPaint,
            deserializedCommand.paint,
            version: Version.v1,
          ),
          isTrue);
      expect(command.version, equals(deserializedCommand.version));
      expect(deserializedCommand.center, equals(center));
      expect(deserializedCommand.width, equals(radius));
      expect(deserializedCommand.height, equals(radius));
      expect(deserializedCommand.type, equals(type));
    });
  });
}
