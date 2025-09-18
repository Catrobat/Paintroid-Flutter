import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import '../utils/dummy_paint_factory.dart';

void main() {
  PaintConverter converter = const PaintConverter();

  group('Version 1', () {
    test('Basic Paint', () {
      Paint originalPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..strokeJoin = StrokeJoin.bevel
        ..blendMode = BlendMode.clear;

      var json = converter.toJson(originalPaint);

      Paint deserializedPaint = converter.fromJson(json);

      expect(
          DummyPaintFactory.comparePaint(
            deserializedPaint,
            originalPaint,
            version: Version.v1,
          ),
          isTrue);
    });

    test('Basic Paint', () {
      Paint originalPaint = Paint()
        ..color = Colors.yellow
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.miter
        ..blendMode = BlendMode.srcOver;

      var json = converter.toJson(originalPaint);

      Paint deserializedPaint = converter.fromJson(json);

      expect(
          DummyPaintFactory.comparePaint(
            deserializedPaint,
            originalPaint,
            version: Version.v1,
          ),
          isTrue);
    });

    test('Basic Paint', () {
      Paint originalPaint = Paint()
        ..color = Colors.green
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.square
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..blendMode = BlendMode.srcIn;

      var json = converter.toJson(originalPaint);

      Paint deserializedPaint = converter.fromJson(json);

      expect(
          DummyPaintFactory.comparePaint(
            deserializedPaint,
            originalPaint,
            version: Version.v1,
          ),
          isTrue);
    });

    test('Custom Color', () {
      Paint originalPaint = Paint()..color = Colors.red;

      var json = converter.toJson(originalPaint);

      Paint deserializedPaint = converter.fromJson(json);

      expect(deserializedPaint.color, equals(originalPaint.color));
    });

    test('Paint with and without MaskFilter handles serialization correctly',
        () {
      Paint paintWithMask = Paint()
        ..color = Colors.teal
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0);

      Map<String, dynamic> jsonWithMask = converter.toJson(paintWithMask);
      Paint deserializedPaintWithMask = converter.fromJson(jsonWithMask);

      expect(deserializedPaintWithMask.maskFilter, isNotNull,
          reason: 'MaskFilter should be present after deserialization');
      final expectedMaskFilter = MaskFilter.blur(BlurStyle.inner, 20.0);
      expect(deserializedPaintWithMask.maskFilter.toString(),
          equals(expectedMaskFilter.toString()),
          reason:
              'Deserialized MaskFilter should be BlurStyle.inner with sigma 20.0');

      expect(deserializedPaintWithMask.color, equals(paintWithMask.color));
      expect(deserializedPaintWithMask.strokeWidth,
          equals(paintWithMask.strokeWidth));
      expect(deserializedPaintWithMask.style, equals(paintWithMask.style));

      Paint paintWithoutMask = Paint()
        ..color = Colors.red
        ..strokeWidth = 1.0
        ..style = PaintingStyle.fill
        ..maskFilter = null;

      Map<String, dynamic> jsonWithoutMask = converter.toJson(paintWithoutMask);
      Paint deserializedPaintWithoutMask = converter.fromJson(jsonWithoutMask);

      expect(deserializedPaintWithoutMask.maskFilter, isNull,
          reason:
              'MaskFilter should be null after deserialization if originally null');
      expect(
          deserializedPaintWithoutMask.color, equals(paintWithoutMask.color));
    });
  });
}
