// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/tool.dart';

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
