import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/tools/tool.dart';

part 'toolbox_state_data.freezed.dart';

@immutable
@freezed
class ToolBoxStateData with _$ToolBoxStateData {
  const factory ToolBoxStateData({
    required Tool currentTool,
    required bool isDown,
  }) = _ToolBoxStateData;
}
