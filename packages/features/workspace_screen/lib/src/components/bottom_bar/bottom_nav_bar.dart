import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';

class BottomNavBar extends ConsumerWidget {
  static const height = 64.0;

  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentToolData = getCurrentToolData(ref);

    return NavigationBarTheme(
      data: PaintroidTheme.of(context).bottomNavBarThemeData,
      child: NavigationBar(
        height: height,
        onDestinationSelected: (index) =>
            _onNavigationItemSelected(index, context, ref),
        destinations: [
          NavigationDestination(
            label: localizations.tools,
            icon: const BottomBarIcon(asset: 'assets/svg/ic_tools.svg'),
          ),
          NavigationDestination(
            label: currentToolData.name,
            icon: BottomBarIcon(asset: currentToolData.svgAssetPath),
          ),
          NavigationDestination(
            label: localizations.color,
            icon: Icon(
              Icons.check_box_outline_blank,
              size: 24,
              color: PaintroidTheme.of(context).onSurfaceColor,
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
    default:
      return;
  }
}

void _showToolBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => const SizedBox(
      height: 270,
      child: ToolsBottomSheet(),
    ),
  );
}

void _handleToolOptionsVisibility(WidgetRef ref) {
  ref.read(toolOptionsVisibilityStateProvider.notifier).toggleVisibility();
}
