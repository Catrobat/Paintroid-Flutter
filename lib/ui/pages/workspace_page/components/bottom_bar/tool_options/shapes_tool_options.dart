import 'package:flutter/material.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/shapes_tool_shape_type_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/shapes_tool_shape_style_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/stroke_width_slider.dart';

class ShapesToolOptions extends StatelessWidget {
  const ShapesToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StrokeWidthSlider(),
        ),
        Spacer(),
        ShapesToolShapeTypeOptions(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ShapesToolShapeStyleOptions(),
        ),
      ],
    );
  }
}
