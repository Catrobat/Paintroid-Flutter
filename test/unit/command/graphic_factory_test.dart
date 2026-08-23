import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';

void main() {
  group('GraphicFactory Antialiasing Tests', () {
    test('createFillPaint should inherit isAntiAlias from basePaint', () {

      final basePaint = Paint()..isAntiAlias = false;
      final resultPaint = GraphicFactory.createFillPaint(basePaint);
      
      expect(resultPaint.isAntiAlias, isFalse);
    });

    test('createStrokePaint should inherit isAntiAlias from basePaint', () {

      final basePaint = Paint()..isAntiAlias = false;
      final resultPaint = GraphicFactory.createStrokePaint(basePaint);
      
      expect(resultPaint.isAntiAlias, isFalse);
    });

    test('createWatercolorPaint should inherit isAntiAlias from originalPaint', () {

      const factory = GraphicFactory();
      final basePaint = Paint()..isAntiAlias = false;
      final resultPaint = factory.createWatercolorPaint(basePaint, 5.0);

      expect(resultPaint.isAntiAlias, isFalse);
    });

    test('copyPaint should inherit isAntiAlias from original', () {
      const factory = GraphicFactory();
      final basePaint = Paint()..isAntiAlias = false;
      final resultPaint = factory.copyPaint(basePaint);

      expect(resultPaint.isAntiAlias, isFalse);
    });
  });
}