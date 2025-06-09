import 'package:paintroid/core/providers/state/text_tool_options_state_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_tool_options_state_provider.g.dart';

@riverpod
class TextToolOptionsStateProvider extends _$TextToolOptionsStateProvider {
  @override
  TextToolOptionsStateData build() => const TextToolOptionsStateData();

  void updateText(String text) {
    state = state.copyWith(text: text);
  }

  void toggleBold() {
    state = state.copyWith(isBold: !state.isBold);
  }

  void toggleItalic() {
    state = state.copyWith(isItalic: !state.isItalic);
  }

  void setFontFamily(String fontFamily) {
    state = state.copyWith(fontFamily: fontFamily);
  }

  void setFontSize(double size) {
    if(state.fontSize == size) return; 
    state = state.copyWith(fontSize: size);
  }

  void toggleUnderline() {
    state = state.copyWith(isUnderline: !state.isUnderline);
  }

  void setAutoSize(bool value) {
    if(state.isAutoSize == value) return; 
    state = state.copyWith(isAutoSize: value);
  }
}
