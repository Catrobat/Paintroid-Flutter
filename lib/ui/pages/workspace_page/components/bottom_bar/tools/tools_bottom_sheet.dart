import 'package:flutter/material.dart';

import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tools/tool_button.dart';



class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const tools = ToolData.allToolsData;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return GridView.count(
      crossAxisCount: currentOrientation == Orientation.portrait ? 4 : 8,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      childAspectRatio: 1.0,
      children: tools.map((toolData) {
        return ToolButton(
          toolData: toolData,
        );
      }).toList(),
    );
  }
}
