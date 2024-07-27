import 'package:flutter/material.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/shapes_tool_transformation_mode_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/stroke_width_tool_option.dart';

class ShapesToolOptions extends StatelessWidget {
  const ShapesToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        StrokeWidthToolOption(),
        Spacer(),
        ShapesToolTransformationModeOptions(),
      ],
    );
  }
}
