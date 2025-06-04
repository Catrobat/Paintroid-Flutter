import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_tool_options_state_provider.g.dart';

@riverpod
class TextToolOptionsStateProvider extends _$TextToolOptionsStateProvider {
  @override
  String build() => '';

  void update(String text) {
    state = text;
  }
}
