import 'package:colorpicker/src/state/position_fraction_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'slider_state.g.dart';

@riverpod
class PositionNotifier extends _$PositionNotifier {
  @override
  double build() {
    return 0.0;
  }

  void updatePosition(
    double position,
    double widgetWidth,
  ) {
    if (position < 0.0) {
      position = 0.0;
    }
    if (position > widgetWidth) {
      position = widgetWidth;
    }
    state = position;
    ref.read(positionFractionNotifierProvider.notifier).updateFraction(
          position / widgetWidth,
        );
  }
}
