import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:tools/tools.dart';

class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const tools = ToolData.allToolsData;
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      childAspectRatio: 1.6,
      children: tools.map((toolData) {
        return ToolButton(
          toolData: toolData,
        );
      }).toList(),
    );
  }
}
