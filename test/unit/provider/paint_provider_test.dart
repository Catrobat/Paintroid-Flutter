// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/providers/state/paint_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('updateStrokeWidth updates the stroke width correctly', () {
    double newStrokeWidth = 30.0;
    container.read(paintProvider.notifier).updateStrokeWidth(newStrokeWidth);
    expect(container.read(paintProvider).strokeWidth, newStrokeWidth);
  });

  test('updateStrokeCap updates the stroke cap correctly', () {
    var newStrokeCap = StrokeCap.butt;
    container.read(paintProvider.notifier).updateStrokeCap(newStrokeCap);
    expect(container.read(paintProvider).strokeCap, newStrokeCap);
  });

  test('updateColor updates the color correctly', () {
    Color newColor = Colors.blue.shade50;
    container.read(paintProvider.notifier).updateColor(newColor);
    expect(container.read(paintProvider).color, newColor);
  });

  test('updateBlendMode updates the blend mode correctly', () {
    BlendMode newMode = BlendMode.clear;
    container.read(paintProvider.notifier).updateBlendMode(newMode);
    expect(container.read(paintProvider).blendMode, newMode);
  });

  test('build sets default values correctly', () {
    Paint paintState = container.read(paintProvider);

    expect(paintState.style, PaintingStyle.stroke);
    expect(paintState.strokeJoin, StrokeJoin.round);
    expect(paintState.color, const Color(0xff00abbb));
    expect(paintState.strokeCap, StrokeCap.round);
    expect(paintState.strokeWidth, 25);
  });
}
