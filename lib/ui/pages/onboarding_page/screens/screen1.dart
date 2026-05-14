import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/core/localization/app_localizations.dart';


class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      color: PaintroidTheme.of(context).surfaceColor,
      padding: const EdgeInsets.only(top: 100, left: 50, right: 50),
      child: Column(
        children: [
          Text(
            localizations!.welcome_to_pocket_paint,
            style: TextStyle(
              color: PaintroidTheme.of(context).onSurfaceColor,
              fontSize: 25,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              localizations.intro_welcome_text,
              style: TextStyle(
                color: PaintroidTheme.of(context).onSurfaceColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
