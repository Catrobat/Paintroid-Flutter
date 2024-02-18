import 'package:command/graphic_factory/graphic_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tools/tools.dart';

class MockGraphicFactory extends Mock implements GraphicFactory {}

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
    container
        .read(brushToolStateProvider.notifier)
        .updateStrokeWidth(newStrokeWidth);
    expect(container.read(brushToolStateProvider).paint.strokeWidth,
        newStrokeWidth);
  });

  test('updateStrokeCap updates the stroke cap correctly', () {
    var newStrokeCap = StrokeCap.butt;
    container
        .read(brushToolStateProvider.notifier)
        .updateStrokeCap(newStrokeCap);
    expect(
        container.read(brushToolStateProvider).paint.strokeCap, newStrokeCap);
  });

  test('updateColor updates the color correctly', () {
    Color newColor = Colors.blue.shade50;
    container.read(brushToolStateProvider.notifier).updateColor(newColor);
    expect(container.read(brushToolStateProvider).paint.color, newColor);
  });

  test('updateBlendMode updates the blend mode correctly', () {
    BlendMode newMode = BlendMode.clear;
    container.read(brushToolStateProvider.notifier).updateBlendMode(newMode);
    expect(container.read(brushToolStateProvider).paint.blendMode, newMode);
  });

  test('build sets default values correctly', () {
    Paint paintState = container.read(brushToolStateProvider).paint;

    expect(paintState.style, PaintingStyle.stroke);
    expect(paintState.strokeJoin, StrokeJoin.round);
    expect(paintState.color, const Color(0xFF830000));
    expect(paintState.strokeCap, StrokeCap.round);
    expect(paintState.strokeWidth, 25);
  });
}
