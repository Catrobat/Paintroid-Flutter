import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paintroid/ui/color_schemes.dart';
import 'package:paintroid/ui/onboarding/bottom_nav_bar_container.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

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

  var title = const Row(
    children: [
      Text(
        'Tools',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        textAlign: TextAlign.start,
      )
    ],
  );

  Icon? toolIcon;

  var desc = const Text(
    'Select the tool you want to use.',
    style: TextStyle(
      color: Colors.white,
      fontSize: 15,
    ),
    textAlign: TextAlign.start,
  );

  void toolPressed(int i) {
    setState(
      () {
        title = Row(
          children: [
            Text(
              titles[i],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              textAlign: TextAlign.start,
            ),
            Container(
              padding: const EdgeInsets.only(left: 50),
              child: SvgPicture.asset(
                icons[i],
                height: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        );

        desc = Text(
          descriptions[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          textAlign: TextAlign.start,
        );
      },
    );
  }

  void brush() => toolPressed(0);

  void hand() => toolPressed(1);

  void eraser() => toolPressed(2);

  void line() => toolPressed(3);

  void shapes() => toolPressed(4);

  void fill() => toolPressed(5);

  void sprayCan() => toolPressed(6);

  void cursor() => toolPressed(7);

  void text() => toolPressed(8);

  void stamp() => toolPressed(9);

  void transform() => toolPressed(10);

  void importImage() => toolPressed(11);

  void pipette() => toolPressed(12);

  void watercolor() => toolPressed(13);

  void smudge() => toolPressed(14);

  void clipArea() => toolPressed(15);

  List<BottomNavigationBarItem> _getBottomNavigationBarItems(int l, int r) {
    List<BottomNavigationBarItem> items = List.generate(
      r - l + 1,
      (i) {
        return BottomNavigationBarItem(
          label: titles[l + i],
          icon: BottomBarIcon(asset: icons[l + i]),
        );
      },
    );
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        color: lightColorScheme.surface,
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
                child: const Text(
                  'Tap on a tool to get more information',
                  style: TextStyle(
                    color: Colors.white,
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
            navBarItems: _getBottomNavigationBarItems(0, 3),
            onPressedFunctions: [brush, hand, eraser, line],
          ),
          BottomNavigationBarContainer(
            navBarItems: _getBottomNavigationBarItems(4, 7),
            onPressedFunctions: [shapes, fill, sprayCan, cursor],
          ),
          BottomNavigationBarContainer(
            navBarItems: _getBottomNavigationBarItems(8, 11),
            onPressedFunctions: [text, stamp, transform, importImage],
          ),
          BottomNavigationBarContainer(
            navBarItems: _getBottomNavigationBarItems(12, 15),
            onPressedFunctions: [pipette, watercolor, smudge, clipArea],
          ),
        ],
      ),
    );
  }
}
