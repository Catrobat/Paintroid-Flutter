import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/src/brush_tool.dart';
import 'package:paintroid/tool/src/tool.dart';
import 'package:paintroid/tool/src/tool_state_notifier.dart';

@immutable
class ToolState {
  final Tool currentTool;
  final bool isDown;

  static final provider = StateNotifierProvider<ToolStateNotifier, ToolState>(
    (ref) => ToolStateNotifier(
      ToolState(
        currentTool: ref.watch(BrushTool.provider),
        isDown: false,
      ),
    ),
  );

  const ToolState({
    required this.currentTool,
    required this.isDown,
  });

  ToolState copyWith({
    Tool? currentTool,
    bool? isDown,
  }) {
    return ToolState(
      currentTool: currentTool ?? this.currentTool,
      isDown: isDown ?? this.isDown,
    );
  }
}
