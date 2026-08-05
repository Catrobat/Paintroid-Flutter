import 'package:flutter/material.dart';

import 'package:paintroid/ui/pages/onboarding_page/components/bottom_nav_bar_container.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';
import 'package:paintroid/ui/shared/icon_svg.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  List<String> titles = [];
  List<String> descriptions = [];

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
    'assets/svg/ic_clipboard.svg',
    'assets/svg/ic_transform.svg',
    'assets/svg/ic_import.svg',
    'assets/svg/ic_pipette.svg',
    'assets/svg/ic_watercolor.svg',
    'assets/svg/ic_smudge.svg',
    'assets/svg/ic_clipping.svg',
  ];

  String titleText = '';
  String descText = '';
  String? toolIconSrc;

  void toolPressed(int i) {
    setState(() {
      titleText = titles[i];
      descText = descriptions[i];
      toolIconSrc = icons[i];
    });
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
    final localizations = AppLocalizations.of(context);

    titles = [
      localizations.buttonBrush, 
      localizations.buttonHand,
      localizations.buttonEraser,
      localizations.buttonLine,
      localizations.buttonShape,
      localizations.buttonFill,
      localizations.buttonSprayCan,
      localizations.buttonCursor,
      localizations.buttonText,
      localizations.buttonClipboard,
      localizations.buttonTransform,
      localizations.buttonImportImage,
      localizations.buttonPipette,
      localizations.buttonWatercolor,
      localizations.buttonSmudge,
      localizations.buttonClip
    ];

    descriptions = [
      localizations.helpContentBrush, 
      localizations.helpContentHand,
      localizations.helpContentEraser,
      localizations.helpContentLine,
      localizations.helpContentShape,
      localizations.helpContentFill,
      localizations.helpContentSprayCan,
      localizations.helpContentCursor,
      localizations.helpContentText,
      localizations.helpContentClipboard,
      localizations.helpContentTransform,
      localizations.helpContentImportPng,
      localizations.helpContentEyedropper,
      localizations.helpContentWatercolor,
      localizations.helpContentSmudge,
      localizations.helpContentClip
    ];
    

    var title = Row(
      children: [
        Text(
          titleText != ''? titleText : localizations.dialogToolsTitle,
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
      descText != '' ? descText : localizations.introBottomNavigationToolsDescription,
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
                  localizations.introToolMoreInformation,
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
