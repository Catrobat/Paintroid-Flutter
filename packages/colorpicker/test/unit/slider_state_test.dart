import 'package:colorpicker/src/state/slider_state.dart';
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

  test('updatePosition updates the position correctly', () {
    double position = 30.0;
    double widgetWidth = 100.0;
    container.read(positionNotifierProvider.notifier).updatePosition(
          position,
          widgetWidth,
        );
    expect(container.read(positionNotifierProvider), position);
  });
}
