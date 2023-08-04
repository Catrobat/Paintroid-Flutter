import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/tool/tool.dart';

part 'toolbox_state_data.freezed.dart';

@immutable
@freezed
class ToolBoxStateData with _$ToolBoxStateData {
  const factory ToolBoxStateData({
    required Tool currentTool,
    required ToolType currentToolType,
    required bool isDown,
  }) = _ToolBoxStateData;
}
