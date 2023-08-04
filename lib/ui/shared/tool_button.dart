import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/shared/icon_button_with_label.dart';

class ToolButton extends StatelessWidget {
  final ToolData toolData;

  const ToolButton({
    Key? key,
    required this.toolData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return IconButtonWithLabel(
          icon: SvgPicture.asset(
            toolData.svgAssetPath,
            height: 24,
            width: 24,
            color: Colors.white,
          ),
          label: toolData.name,
          onPressed: () {
            Navigator.pop(context);
            ref.read(toolBoxStateProvider.notifier).switchTool(toolData);
          },
        );
      },
    );
  }
}
