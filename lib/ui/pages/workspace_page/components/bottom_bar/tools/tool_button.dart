// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/shared/icon_button_with_label.dart';
import 'package:paintroid/ui/shared/icon_svg.dart';
import 'package:paintroid/ui/theme/theme.dart';

class ToolButton extends StatelessWidget {
  final ToolData toolData;

  const ToolButton({
    super.key,
    required this.toolData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          width: 50.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: IconButtonWithLabel(
              icon: IconSvg(
                path: toolData.svgAssetPath,
                height: 30.0,
                width: 30.0,
                color: PaintroidTheme.of(context).onSurfaceColor,
              ),
              label: toolData.name,
              key: ValueKey(toolData.name),
              onPressed: () {
                Navigator.pop(context);
                ref.read(toolBoxStateProvider.notifier).switchTool(toolData);
              },
            ),
          ),
        );
      },
    );
  }
}
