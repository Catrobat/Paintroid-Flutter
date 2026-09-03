import 'package:flutter/cupertino.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/tolerance_slider.dart';

class FillToolOptions extends StatelessWidget {
  const FillToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Spacer(),
      ToleranceSlider(),
    ]);
  }
}
