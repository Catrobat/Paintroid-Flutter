import 'package:flutter/cupertino.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/stroke_cap_chips.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/stroke_width_slider.dart';

class StrokeToolOptions extends StatelessWidget {
  const StrokeToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      StrokeWidthSlider(),
      Spacer(),
      StrokeCapChips(),
    ]);
  }
}
