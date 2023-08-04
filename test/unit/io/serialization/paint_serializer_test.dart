import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/io/serialization.dart';

void main() {
  final mockGraphicFactory = MockGraphicFactory();
  final paintSerializer = PaintSerializer(1, mockGraphicFactory);

  group('PaintSerializer', () {
    test(
        'serialize and deserialize with a Paint object having all default values',
        () async {
      final paint = Paint();

      final serialized =
          await paintSerializer.serializeWithLatestVersion(paint);
      final deserialized =
          await paintSerializer.deserializeWithLatestVersion(serialized);

      expect(deserialized.color, Colors.black);
      expect(deserialized.strokeWidth, 0.0);
      expect(deserialized.blendMode, BlendMode.srcOver);
      expect(deserialized.strokeCap, StrokeCap.butt);
      expect(deserialized.strokeJoin, StrokeJoin.miter);
      expect(deserialized.style, PaintingStyle.fill);
    });

    test('serialize and deserialize with different values', () async {
      final paint = Paint()
        ..blendMode = BlendMode.srcOver
        ..color = Colors.red
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 25.0
        ..style = PaintingStyle.stroke;

      final serialized =
          await paintSerializer.serializeWithLatestVersion(paint);
      final deserialized =
          await paintSerializer.deserializeWithLatestVersion(serialized);

      expect(deserialized.blendMode, paint.blendMode);
      expect(deserialized.color, paint.color);
      expect(deserialized.strokeCap, paint.strokeCap);
      expect(deserialized.strokeJoin, paint.strokeJoin);
      expect(deserialized.strokeWidth, paint.strokeWidth);
      expect(deserialized.style, paint.style);
    });
  });
}

class MockGraphicFactory extends GraphicFactory {}
