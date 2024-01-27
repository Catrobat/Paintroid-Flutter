import 'package:flutter/cupertino.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/src/components/bottom_bar/stroke_cap_tool_option.dart';
import 'package:workspace_screen/src/components/bottom_bar/stroke_width_tool_option.dart';

class ToolOptionsConfig {
  static final ToolOptionsConfig _instance = ToolOptionsConfig._internal();

  factory ToolOptionsConfig() {
    return _instance;
  }

  ToolOptionsConfig._internal();

  List<Widget> getToolSpecificOptions(ToolType toolType) {
    switch (toolType) {
      case ToolType.BRUSH:
      case ToolType.ERASER:
        return _defaultOptions;
      default:
        return [];
    }
  }

  final List<Widget> _defaultOptions = [
    const StrokeWidthToolOption(),
    const Spacer(),
    const StrokeCapToolOption(),
  ];
}
