import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipping_tool_state_provider.g.dart';

@riverpod
class ClippingToolState extends _$ClippingToolState {
  @override
  bool build() {
    return false;
  }

  void setHasActiveClipPath(bool hasActive) {
    state = hasActive;
  }

  void clearClipPath() {
    state = false;
  }

  bool get hasActiveClipPath => state;
}
