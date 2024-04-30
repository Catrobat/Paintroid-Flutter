// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/ui/shared/imgs.dart';
import 'package:paintroid/ui/themes/theme/color_schemes.dart';

// Package imports:

class Screen5 extends StatelessWidget {
  const Screen5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightColorScheme.surface,
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'You are all set. Enjoy Pocket Paint.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'Get started and create a new masterpiece.',
                style: TextStyle(
                  color: Colors.white,
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
