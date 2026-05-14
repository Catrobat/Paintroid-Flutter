import 'package:flutter/material.dart';

import 'package:paintroid/ui/shared/images/pocketpaint_intro_landscape.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      color: PaintroidTheme.of(context).surfaceColor,
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                localizations!.landscape,
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
                localizations.intro_landscape_text,
                style: TextStyle(
                  color: PaintroidTheme.of(context).onSurfaceColor,
                  fontSize: 15,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          const Expanded(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
              child: PocketPaintIntroLandscape(),
            ),
          ),
        ],
      ),
    );
  }
}
