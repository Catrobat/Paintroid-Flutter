import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_tool_options_state_data.freezed.dart';

@freezed
class TextToolOptionsStateData with _$TextToolOptionsStateData {
  const factory TextToolOptionsStateData({
    @Default('Enter Text') String text,
    @Default(30.0) double fontSize,
    @Default(true) bool isAutoSize,
    @Default(false) bool isBold,
    @Default(false) bool isItalic,
    @Default(false) bool isUnderline,
    @Default('Roboto') String fontFamily,
  }) = _TextToolOptionsStateData;
}
