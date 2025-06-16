import 'package:flutter/material.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/shapes_tool_shape_type_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/shapes_tool_shape_style_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/stroke_width_slider.dart';

class ShapesToolOptions extends StatelessWidget {
  const ShapesToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        StrokeWidthSlider(),
        Spacer(),
        Row(
          children: [
            Expanded(
              child: ShapesToolShapeTypeOptions(),
            ),
            SizedBox(width: 8),
            Expanded(child: ShapesToolShapeStyleOptions())
          ],
        ),
      ],
    );
  }
}
