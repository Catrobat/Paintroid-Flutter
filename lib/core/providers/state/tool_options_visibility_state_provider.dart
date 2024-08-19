import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tool_options_visibility_state_provider.g.dart';

@riverpod
class ToolOptionsVisibilityStateProvider
    extends _$ToolOptionsVisibilityStateProvider {
  void toggleVisibility() {
    state = !state;
  }

  @override
  bool build() {
    return true;
  }
}
