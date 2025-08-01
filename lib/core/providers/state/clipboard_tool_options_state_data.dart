import 'package:freezed_annotation/freezed_annotation.dart';

part 'clipboard_tool_options_state_data.freezed.dart';

@freezed
class ClipboardToolOptionsStateData with _$ClipboardToolOptionsStateData {
  const factory ClipboardToolOptionsStateData({
    @Default(false) bool hasCopiedContent,
  }) = _ClipboardToolOptionsStateData;
}
