import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import '../utils/dummy_paint_factory.dart';

void main() {
  group('Version 1', () {
    test('Test Circle (as Ellipse) serialization', () {
      const type = SerializerType.ELLIPSE_SHAPE_COMMAND;
      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const center = Offset(100, 100);
      const radius = 50.0;

      final command = EllipseShapeCommand(
        originalPaint,
        radius,
        radius,
        center,
        angle: 0.0,
        version: Version.v1,
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
      expect(deserializedCommand.version, equals(command.version));
      expect(deserializedCommand.center, equals(center));
      // For a circle, radiusX and radiusY are the same.
      // The EllipseShapeCommand stores them as radiusX and radiusY.
      expect(deserializedCommand.radiusX, equals(radius));
      expect(deserializedCommand.radiusY, equals(radius));
      expect(deserializedCommand.angle, equals(0.0));
      expect(deserializedCommand.type, equals(type));
    });

    test('Test Ellipse (non-circular, rotated) serialization', () {
      const type = SerializerType.ELLIPSE_SHAPE_COMMAND;
      final originalPaint = DummyPaintFactory.createPaint(version: Version.v1);
      const center = Offset(150, 250);
      const radiusX = 80.0;
      const radiusY = 45.0;
      const angle = 0.785;

      final command = EllipseShapeCommand(
        originalPaint,
        radiusX,
        radiusY,
        center,
        angle: angle,
        version: Version.v1,
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
      expect(deserializedCommand.version, equals(command.version));
      expect(deserializedCommand.center, equals(center));
      expect(deserializedCommand.radiusX, equals(radiusX));
      expect(deserializedCommand.radiusY, equals(radiusY));
      expect(deserializedCommand.angle, equals(angle));
      expect(deserializedCommand.type, equals(type));
    });
  });
}
