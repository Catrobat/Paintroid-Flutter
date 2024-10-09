import 'package:paintroid/core/providers/state/layer_menu_state_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layer_menu_state_provider.g.dart';

@Riverpod(keepAlive: true)
class LayerMenuStateProvider extends _$LayerMenuStateProvider {
  @override
  LayerMenuStateData build() {
    return const LayerMenuStateData(
      isVisible: false,
    );
  }

  void toggleVisibility() {
    state = state.copyWith(isVisible: !state.isVisible);
  }

  void hide() {
    state = state.copyWith(isVisible: false);
  }
}
