import 'package:flutter/cupertino.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/widgets/radius_slider.dart';

class SprayToolOptions extends StatelessWidget {
  const SprayToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      RadiusSlider(),
      Spacer(),
    ]);
  }
}
