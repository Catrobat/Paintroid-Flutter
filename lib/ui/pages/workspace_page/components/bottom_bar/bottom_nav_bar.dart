// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorpicker/colorpicker.dart';

// Project imports:
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/tool_options_visibility_state_provider.dart';
import 'package:paintroid/core/providers/state/tools/brush/brush_tool_state_provider.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar_items.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tools/tools_bottom_sheet.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';
import 'package:paintroid/ui/theme/theme.dart';

class BottomNavBar extends ConsumerWidget {
  static const height = 64.0;

  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentToolData = getCurrentToolData(ref);
    final currentPaint = ref.watch(brushToolStateProvider).paint;

    return NavigationBarTheme(
      data: PaintroidTheme.of(context).bottomNavBarThemeData,
      child: NavigationBar(
        height: height,
        onDestinationSelected: (index) =>
            _onNavigationItemSelected(index, context, ref),
        destinations: [
          NavigationDestination(
            key: const ValueKey(BottomNavBarItem.TOOLS),
            label: localizations.tools,
            icon: const BottomBarIcon(asset: 'assets/svg/ic_tools.svg'),
          ),
          NavigationDestination(
            label: currentToolData.name,
            icon: BottomBarIcon(asset: currentToolData.svgAssetPath),
          ),
          NavigationDestination(
            label: localizations.color,
            icon: InkWell(
              child: Container(
                height: 24.0,
                width: 24.0,
                decoration: BoxDecoration(
                  color: currentPaint.color,
                  border: Border.all(
                    color: PaintroidTheme.of(context).onSurfaceColor,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
          ),
          NavigationDestination(
            label: localizations.layers,
            icon: const BottomBarIcon(asset: 'assets/svg/ic_layers.svg'),
          ),
        ],
      ),
    );
  }

  ToolData getCurrentToolData(WidgetRef ref) {
    final ToolType currentToolType = ref.watch(
      toolBoxStateProvider.select((value) => value.currentToolType),
    );

    final currentToolData = ToolData.allToolsData.firstWhere(
      (toolData) => toolData.type == currentToolType,
      orElse: () => ToolData.BRUSH,
    );
    return currentToolData;
  }
}

void _onNavigationItemSelected(int index, BuildContext context, WidgetRef ref) {
  BottomNavBarItem item = BottomNavBarItem.values[index];
  switch (item) {
    case BottomNavBarItem.TOOLS:
      _showToolBottomSheet(context);
      break;
    case BottomNavBarItem.TOOL_OPTIONS:
      _handleToolOptionsVisibility(ref);
      break;
    case BottomNavBarItem.COLOR:
      _showColorPicker(context, ref);
      break;
    default:
      return;
  }
}

void _showToolBottomSheet(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => SizedBox(
      height: screenHeight * 0.5,
      child: const ToolsBottomSheet(),
    ),
  );
}

void _handleToolOptionsVisibility(WidgetRef ref) {
  ref.read(toolOptionsVisibilityStateProvider.notifier).toggleVisibility();
}

void _showColorPicker(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext dialogContext) => Container(
      height: MediaQuery.of(dialogContext).size.height * 0.7,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: PaintroidTheme.of(dialogContext).onSurfaceColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
      child: ColorPicker(
        currentColor: ref.watch(brushToolStateProvider).paint.color,
        onColorChanged: (newColor) {
          ref.read(brushToolStateProvider.notifier).updateColor(newColor);
        },
      ),
    ),
  );
}
