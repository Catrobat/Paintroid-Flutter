import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'slider_position_state.g.dart';

@riverpod
class SliderPositionState extends _$SliderPositionState {
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
  }
}
