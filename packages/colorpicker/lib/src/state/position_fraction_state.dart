import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position_fraction_state.g.dart';

@riverpod
class PositionFractionNotifier extends _$PositionFractionNotifier {
  @override
  double build() {
    return 0.0;
  }

  void updateFraction(double newFraction) {
    state = newFraction;
  }
}
