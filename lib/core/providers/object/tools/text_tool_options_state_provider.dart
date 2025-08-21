import 'package:paintroid/core/providers/state/text_tool_options_state_data.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/text_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_tool_options_state_provider.g.dart';

@riverpod
class TextToolOptionsStateProvider extends _$TextToolOptionsStateProvider {
  @override
  TextToolOptionsStateData build() {
    return const TextToolOptionsStateData();
  }

  void updateText(String text) {
    state = state.copyWith(text: text);
    _updateTextTool();
  }

  void toggleBold() {
    state = state.copyWith(isBold: !state.isBold);
    _updateTextTool();
  }

  void toggleItalic() {
    state = state.copyWith(isItalic: !state.isItalic);
    _updateTextTool();
  }

  void setFontFamily(String fontFamily) {
    state = state.copyWith(fontFamily: fontFamily);
    _updateTextTool();
  }

  void setFontSize(double size) {
    if (state.fontSize == size) {
      return;
    }
    // Only update font size if not in a build/paint phase
    Future.microtask(() {
      state = state.copyWith(fontSize: size);
      _updateTextTool();
    });
  }

  void toggleUnderline() {
    state = state.copyWith(isUnderline: !state.isUnderline);
    _updateTextTool();
  }

  void setAutoSize(bool value) {
    if (state.isAutoSize == value) {
      return;
    }
    state = state.copyWith(isAutoSize: value);
    _updateTextTool();
  }

  void _updateTextTool() {
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    if (currentTool is TextTool) {
      currentTool.updateOptions(state);
    }
  }
}
