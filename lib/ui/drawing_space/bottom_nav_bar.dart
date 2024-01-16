import 'package:colorpicker/colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/app_localizations.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/drawing_space/tools_bottom_sheet.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';
import 'package:paintroid/ui/styles.dart';

Color selectedColor = Colors.black;
final selectedColorProvider = StateProvider<Color>((ref) => Colors.black);

class BottomNavBar extends StatefulWidget {
  static const height = 64.0;

  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onNavigationItemSelected(int index, BuildContext context) {
    if (index == 0) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => const SizedBox(
          height: 270,
          child: ToolsBottomSheet(),
        ),
      );
    }
    if (index == 2) {
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
            currentColor: Colors.black,
            onColorChanged: (color) {},
          ),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return NavigationBarTheme(
      data: WidgetThemes.bottomNavBarThemeData,
      child: NavigationBar(
        height: BottomNavBar.height,
        onDestinationSelected: (index) =>
            _onNavigationItemSelected(index, context),
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
              Icons.square,
              size: 24,
              color: selectedColor,
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
