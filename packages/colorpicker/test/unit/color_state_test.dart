import 'package:colorpicker/src/state/color_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('updateColor updates the color correctly', () {
    Color newColor = Colors.blue.shade50;
    container.read(colorStateProvider.notifier).updateColor(newColor);
    expect(container.read(colorStateProvider), newColor);
  });
}
