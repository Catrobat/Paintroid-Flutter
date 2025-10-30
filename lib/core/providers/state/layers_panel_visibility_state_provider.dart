import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layers_panel_visibility_state_provider.g.dart';

@riverpod
class LayersPanelVisibilityStateProvider
    extends _$LayersPanelVisibilityStateProvider {
  void toggleVisibility() {
    state = !state;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }

  @override
  bool build() {
    return false;
  }
}
