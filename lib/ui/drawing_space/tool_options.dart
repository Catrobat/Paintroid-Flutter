import 'package:flutter/material.dart';
import 'package:paintroid/ui/drawing_space/bottom_brush_tool_options.dart';
import 'package:paintroid/ui/drawing_space/top_brush_tool_options.dart';

class ToolOptions extends StatelessWidget {
  const ToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TopBrushToolOptions(),
          Spacer(),
          BottomBrushToolOptions(),
        ],
      ),
    );
  }
}
