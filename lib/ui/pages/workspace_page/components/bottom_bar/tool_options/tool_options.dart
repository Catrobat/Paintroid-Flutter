import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/advanced_settings_panel_visibility_provider.dart';
import 'package:paintroid/core/providers/state/tool_options_visibility_state_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/advanced_settings_panel.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/clipboard_tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/shapes_tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/spray_tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/stroke_tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/text_tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/tool_option.dart';

class ToolOptions extends ConsumerWidget {
  const ToolOptions({super.key});

  final maxOpacity = 1.0;
  final minOpacity = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolOptionsVisible = ref.watch(toolOptionsVisibilityStateProvider);
    final advancedSettingsVisible =
        ref.watch(advancedSettingsPanelVisibilityProvider);
    final visible = toolOptionsVisible || advancedSettingsVisible;
    final currentToolType = ref.watch(
      toolBoxStateProvider.select((value) => value.currentTool.type),
    );

    return Padding(
      padding: !advancedSettingsVisible && currentToolType == ToolType.SHAPES
          ? EdgeInsets.zero
          : const EdgeInsets.all(8),
      child: ToolOption(
        isIgnoring: !visible,
        opacity: visible ? maxOpacity : minOpacity,
        child: advancedSettingsVisible
            ? const AdvancedSettingsPanel()
            : switch (currentToolType) {
                ToolType.BRUSH => const StrokeToolOptions(),
                ToolType.WATERCOLOR => const StrokeToolOptions(),
                ToolType.ERASER => const StrokeToolOptions(),
                ToolType.LINE => const StrokeToolOptions(),
                ToolType.SHAPES => const ShapesToolOptions(),
                ToolType.SPRAY => const SprayToolOptions(),
                ToolType.CLIPBOARD => const ClipboardToolOptions(),
                ToolType.TEXT => const TextToolOptions(),
                _ => Container(),
              },
      ),
    );
  }
}
