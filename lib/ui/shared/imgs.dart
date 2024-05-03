// Flutter imports:
import 'package:flutter/material.dart';

class CheckerboardImg extends StatelessWidget {
  const CheckerboardImg({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'assets/img/checkerboard.png',
        repeat: ImageRepeat.repeat,
        cacheWidth: 50,
        cacheHeight: 50,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}

class PocketPaintIntroLandscape extends StatelessWidget {
  const PocketPaintIntroLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'assets/img/pocketpaint_intro_landscape.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class PocketPaintIntroPortrait extends StatelessWidget {
  const PocketPaintIntroPortrait({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'assets/img/pocketpaint_intro_portrait.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

class PocketPaintLogoSmall extends StatelessWidget {
  const PocketPaintLogoSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'assets/img/pocketpaint_logo_small.png',
      ),
    );
  }
}
