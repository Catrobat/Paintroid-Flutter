import 'package:colorpicker/src/state/color_picker_state_provider.dart';
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
    final state = container.read(colorPickerStateProvider.notifier);
    const newColor = Colors.red;
    state.updateColor(newColor);
    expect(container.read(colorPickerStateProvider).currentColor, newColor);
  });

  test('updateOpacity updates the opacity correctly', () {
    final state = container.read(colorPickerStateProvider.notifier);
    const newOpacity = 0.5;
    state.updateOpacity(newOpacity);
    expect(container.read(colorPickerStateProvider).currentOpacity, newOpacity);
  });
}
