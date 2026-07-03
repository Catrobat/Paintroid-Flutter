import 'package:flutter/material.dart';

import 'package:paintroid/ui/pages/onboarding_page/components/bottom_nav_bar_container.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';
import 'package:paintroid/ui/shared/icon_svg.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_bottom_nav_bar.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  List<String> titles = [
    'Brush',
    'Hand',
    'Eraser',
    'Line',
    'Shapes',
    'Fill',
    'Spray can',
    'Cursor',
    'Text',
    'Stamp',
    'Transform',
    'Import image',
    'Pipette',
    'Watercolor',
    'Smudge',
    'Clip area',
  ];

  List<String> icons = [
    'assets/svg/ic_brush.svg',
    'assets/svg/ic_hand.svg',
    'assets/svg/ic_eraser.svg',
    'assets/svg/ic_line.svg',
    'assets/svg/ic_shapes.svg',
    'assets/svg/ic_fill.svg',
    'assets/svg/ic_spray_can.svg',
    'assets/svg/ic_cursor.svg',
    'assets/svg/ic_text.svg',
    'assets/svg/ic_stamp.svg',
    'assets/svg/ic_transform.svg',
    'assets/svg/ic_import.svg',
    'assets/svg/ic_pipette.svg',
    'assets/svg/ic_watercolor.svg',
    'assets/svg/ic_smudge.svg',
    'assets/svg/ic_clipping.svg',
  ];

  List<String> descriptions = [
    'Tap on the symbols on the bottom bar to change the color or the brush size.',
    'Move your finger to move the canvas.',
    'Remove parts of the image like with an eraser.',
    'Draw a straight line.',
    'Choose a shape and tap on the checkmark to insert the selected shape.',
    'Tap on the image to fill an area with the selected color.',
    'Move your finger on the image to create a spray can pattern.',
    'Position the cursor where you want to draw. Tap to activate the cursor. Move your finger to draw. Tap again to deactivate.',
    'Write text and format it. Resize the text box afterwards. Tap on the checkmark to insert the text on the image.',
    'Move and resize the rectangle to cover the area you want to stamp. Tap on copy or cut to select the area. Move it, then tap on paste to stamp.',
    'Use to transform the image.',
    'Import an image from the gallery to the stamp tool.',
    'Tap on the image to select a color.',
    'Similar to the brush tool with a watercolor effect. However you can also change the strength of the brush with the slider in the color menu.',
    'Move your finger on the image on different drawings to smudge them.',
    'Mark area which should not be erased.',
  ];

  String titleText = 'Tools';
  String descText = 'Select the tool you want to use.';
  String? toolIconSrc;

  void toolPressed(int i) {
    setState(() {
      titleText = titles[i];
      descText = descriptions[i];
      toolIconSrc = icons[i];
    });
  }

  List<BottomNavItemData> _getBottomNavItems(int l, int r) {
  return List.generate(
    r - l + 1,
    (i) {
      final index = l + i;

      return BottomNavItemData(
        label: titles[index],
        icon: BottomBarIcon(asset: icons[index]),
        onPressed: () => toolPressed(index),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    var title = Row(
      children: [
        Text(
          titleText,
          style: PaintroidTheme.of(context).descStyle,
          textAlign: TextAlign.start,
        ),
        toolIconSrc != null
            ? Container(
                padding: const EdgeInsets.only(left: 50.0),
                child: IconSvg(
                  path: toolIconSrc!,
                  height: 24.0,
                  width: 24.0,
                  color: PaintroidTheme.of(context).onSurfaceColor,
                ),
              )
            : const SizedBox(),
      ],
    );

    var desc = Text(
      descText,
      style: PaintroidTheme.of(context).descStyle,
      textAlign: TextAlign.start,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        color: PaintroidTheme.of(context).surfaceColor,
        padding: const EdgeInsets.only(top: 60, left: 50, right: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: desc,
              ),
            ),
            const Spacer(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Tap on a tool to get more information',
                  style: TextStyle(
                    color: PaintroidTheme.of(context).onSurfaceColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),         
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBarContainer(
              items: _getBottomNavItems(0, 3),
            
          ),
          BottomNavigationBarContainer(
              items: _getBottomNavItems(4, 7),
            
          ),
            BottomNavigationBarContainer(
              items: _getBottomNavItems(8, 11),
            
          ),
          BottomNavigationBarContainer(
              items: _getBottomNavItems(12, 15),
            ),
          ],
        )
    );
  }
}
