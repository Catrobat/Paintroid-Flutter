import 'package:flutter/material.dart';
import 'package:colorpicker/src/constants/color_picker_constants.dart';

class CustomTabWidget extends StatelessWidget {
  final Icon iconWidget;
  final int index;
  final TabController tabController;
  final double selectedIndicatorHeight;
  final double unselectedIndicatorHeight;

  const CustomTabWidget({
    super.key,
    required this.iconWidget,
    required this.index,
    required this.tabController,
    required this.selectedIndicatorHeight,
    required this.unselectedIndicatorHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
        animation: tabController,
        builder: (BuildContext context, Widget? child) {
          final bool isSelected = tabController.index == index;
          return GestureDetector(
            onTap: () {
              if (tabController.index != index) {
                tabController.animateTo(index);
              }
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.only(bottom: 2.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return hueSweepGradient.createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: IconTheme(
                        data: const IconThemeData(
                          color: Colors.white,
                        ),
                        child: iconWidget,
                      ),
                    )),
                  ),
                  Container(
                    height: isSelected
                        ? selectedIndicatorHeight
                        : unselectedIndicatorHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? colorScheme.primary : theme.dividerColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
