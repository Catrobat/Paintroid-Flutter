// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:component_library/component_library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tools/tools.dart';

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
          icon: IconSvg(
            path: toolData.svgAssetPath,
            height: 24.0,
            width: 24.0,
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
