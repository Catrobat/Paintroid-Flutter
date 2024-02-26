import 'package:flutter/material.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/src/components/bottom_bar/tools/tool_button.dart';
import 'package:workspace_screen/workspace_screen.dart';

class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const tools = ToolData.allToolsData;
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: tools.map((toolData) {
          return ToolButton(
            toolData: toolData,
          );
        }).toList(),
      ),
    );
  }
}
