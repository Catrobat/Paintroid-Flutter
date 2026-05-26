import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/utils/color_utils.dart';

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
    expect(container.read(paintProvider).color.toValue(), newColor.toValue());
  });

  test('updateBlendMode updates the blend mode correctly', () {
    BlendMode newMode = BlendMode.clear;
    container.read(paintProvider.notifier).updateBlendMode(newMode);
    expect(container.read(paintProvider).blendMode, newMode);
  });
  test('updateAntialiasing should update the active paint', () {
    final notifier = container.read(paintProvider.notifier);
    notifier.updateAntialiasing(false);
    final state = container.read(paintProvider);
    expect(state.isAntiAlias, isFalse);
  });

  test('strokeWidth <= 1 should force antialiasing off', () {
      final notifier = container.read(paintProvider.notifier);
      notifier.updateAntialiasing(true);
      notifier.updateStrokeWidth(1.0);
      final state = container.read(paintProvider);
      expect(state.isAntiAlias, isFalse);
    });

  test('build sets default values correctly', () {
    Paint paintState = container.read(paintProvider);

    expect(paintState.style, PaintingStyle.stroke);
    expect(paintState.strokeJoin, StrokeJoin.round);
    expect(paintState.color.toValue(), const Color(0xff00abbb).toValue());
    expect(paintState.strokeCap, StrokeCap.round);
    expect(paintState.strokeWidth, 25);
  });
}
