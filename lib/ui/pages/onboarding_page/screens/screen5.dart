import 'package:flutter/material.dart';

import 'package:paintroid/ui/shared/images/pocketpaint_intro_portrait.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

class Screen5 extends StatelessWidget {
  const Screen5({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      color: PaintroidTheme.of(context).surfaceColor,
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                localizations!.enjoy_pocket_paint,
                style: TextStyle(
                  color: PaintroidTheme.of(context).onSurfaceColor,
                  fontSize: 24,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                localizations.intro_get_started,
                style: TextStyle(
                  color: PaintroidTheme.of(context).onSurfaceColor,
                  fontSize: 15,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 10),
              child: const PocketPaintIntroPortrait(),
            ),
          ),
        ],
      ),
    );
  }
}
