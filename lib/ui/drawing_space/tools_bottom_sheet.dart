import 'package:flutter/material.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/shared/tool_button.dart';

class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const tools = ToolData.allToolsData;
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 0.0,
      childAspectRatio: 1.2,
      children: tools.map((toolData) {
        return ToolButton(
          toolData: toolData,
        );
      }).toList(),
    );
  }
}
