import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';

class BottomNavBar extends ConsumerWidget {
  static const height = 64.0;

  const BottomNavBar({Key? key}) : super(key: key);

  void _onNavigationItemSelected(
      int index, BuildContext context, WidgetRef ref) {
    BottomNavBarItem item = BottomNavBarItem.values[index];
    switch (item) {
      case BottomNavBarItem.TOOLS:
        showToolBottomSheet(context);
        break;
      case BottomNavBarItem.CURRENT_TOOL:
        handleToolOptionsVisibility(ref);
        break;
      default:
        return;
    }
  }

  void showToolBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => const SizedBox(
        height: 270,
        child: ToolsBottomSheet(),
      ),
    );
  }

  void handleToolOptionsVisibility(WidgetRef ref) {
    ref.read(toolOptionsVisibilityStateProvider.notifier).toggleVisibility();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    return NavigationBarTheme(
      data: WidgetThemes.bottomNavBarThemeData,
      child: NavigationBar(
        height: height,
        onDestinationSelected: (index) =>
            _onNavigationItemSelected(index, context, ref),
        destinations: [
          NavigationDestination(
            label: localizations.tools,
            icon: const BottomBarIcon(asset: 'assets/svg/ic_tools.svg'),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ToolType currentToolType = ref.watch(
                toolBoxStateProvider.select((value) => value.currentToolType),
              );

              final currentToolData = ToolData.allToolsData.firstWhere(
                (toolData) => toolData.type == currentToolType,
                orElse: () => ToolData.BRUSH,
              );

              return NavigationDestination(
                label: currentToolData.name,
                icon: BottomBarIcon(asset: currentToolData.svgAssetPath),
              );
            },
          ),
          NavigationDestination(
            label: localizations.color,
            icon: Icon(
              Icons.check_box_outline_blank,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
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
}
