import 'package:flutter/material.dart';

import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_app_bar.dart';
import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_bottom_nav_bar.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/drawing_canvas.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<String> titles = [];
  List<String> descriptions = [];

  String titleText = '';
  String descText = '';

  void onPressed(int i) {
    setState(() {
      titleText = titles[i];
      descText = descriptions[i];
    });
  }

  void tools() => onPressed(0);

  void current() => onPressed(1);

  void color() => onPressed(2);

  void layers() => onPressed(3);

  void undo() => onPressed(4);

  void redo() => onPressed(5);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    titles = [
      localizations.bottomNavigationTools,
      localizations.bottomNavigationCurrent,
      localizations.bottomNavigationColor,
      localizations.bottomNavigationLayers,
      localizations.buttonUndo,
      localizations.buttonRedo
    ];

    descriptions = [
      localizations.introBottomNavigationToolsDescription,
      localizations.introBottomNavigationCurrentDescription,
      localizations.introBottomNavigationColorDescription,
      localizations.introBottomNavigationLayersDescription,
      localizations.helpContentUndo,
      localizations.helpContentRedo
    ];

    var title = Text(
      titleText != '' ? titleText : localizations.morePossibilities,
      style: PaintroidTheme.of(context).titleStyle,
      textAlign: TextAlign.start,
    );

    var desc = Text(
      descText != '' ? descText : localizations.introPossibilitiesText,
      style: PaintroidTheme.of(context).descStyle,
      textAlign: TextAlign.start,
    );

    return Scaffold(
      appBar: OnboardingPageAppBar(
        title: localizations.pocketpaintAppName,
        onPressed: [undo, redo],
      ),
      backgroundColor: Colors.grey.shade400,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Center(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Transform.scale(
                    scale: 0.85,
                    child: const DrawingCanvas(),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color.fromARGB(220, 0, 151, 167),
              padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: desc,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: OnboardingPageBottomNavigationBar(
        onPressedFunctions: [tools, current, color, layers],
        barItems: [
          BottomNavigationBarItem(
            label: localizations.bottomNavigationTools,
            icon: BottomBarIcon(asset: 'assets/svg/ic_tools.svg'),
          ),
          BottomNavigationBarItem(
            label: localizations.bottomNavigationCurrent,
            icon: BottomBarIcon(asset: 'assets/svg/ic_hand.svg'),
          ),
          BottomNavigationBarItem(
            label: localizations.bottomNavigationColor,
            icon: Icon(
              Icons.check_box_outline_blank,
              size: 24,
              color: PaintroidTheme.of(context).onSurfaceColor,
            ),
          ),
          BottomNavigationBarItem(
              label: localizations.bottomNavigationLayers,
              icon: BottomBarIcon(asset: 'assets/svg/ic_layers.svg')),
        ],
      ),
    );
  }
}
