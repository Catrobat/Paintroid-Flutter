// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:io_library/io_library.dart';
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
  });
}
