import 'package:flutter/material.dart';
import 'package:paintroid/tool/src/tool_types.dart';
import 'package:paintroid/ui/shared/icon_button_with_label.dart';

class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const tools = ToolData.allToolsData;
    return FractionallySizedBox(
      heightFactor: 0.54,
      child: Column(
        children: List.generate(tools.length ~/ 4, (index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (index2) {
              var tool = tools[index * 4 + index2];
              return IconButtonWithLabel(
                svgAssetPath: tool.svgAssetPath,
                label: tool.name,
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
