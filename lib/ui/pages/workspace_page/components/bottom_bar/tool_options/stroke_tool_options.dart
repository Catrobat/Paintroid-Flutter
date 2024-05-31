// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/stroke_cap_tool_option.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/stroke_width_tool_option.dart';

// Project imports:

class StrokeToolOptions extends StatelessWidget {
  const StrokeToolOptions({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      StrokeWidthToolOption(),
      Spacer(),
      StrokeCapToolOption(),
    ]);
  }
}
