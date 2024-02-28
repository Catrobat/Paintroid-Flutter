import 'package:colorpicker/src/state/position_fraction_state.dart';
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

  test('updateFraction updates the fraction correctly', () {
    double newFraction = 0.3;
    container
        .read(positionFractionNotifierProvider.notifier)
        .updateFraction(newFraction);
    expect(container.read(positionFractionNotifierProvider), newFraction);
  });
}
