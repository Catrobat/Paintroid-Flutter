import 'package:colorpicker/colorpicker.dart';
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
    final currentPaint = ref.watch(brushToolStateProvider).paint;

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
                      color: Colors.white,
                      width: 1.4,
                    ),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              )),
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

void _showColorPicker(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ColorPicker(
        currentColor: ref.watch(brushToolStateProvider).paint.color,
        onColorChanged: (newColor) {
          ref.read(brushToolStateProvider.notifier).updateColor(newColor);
        },
      ),
    ),
  );
}
