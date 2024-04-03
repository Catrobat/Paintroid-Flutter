// Flutter imports:
import 'package:flutter/material.dart';

class CheckerboardImg extends StatelessWidget {
  const CheckerboardImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'packages/component_library/assets/img/checkerboard.png',
        repeat: ImageRepeat.repeat,
        cacheWidth: 50,
        cacheHeight: 50,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}

class PocketPaintIntroLandscape extends StatelessWidget {
  const PocketPaintIntroLandscape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'packages/component_library/assets/img/pocketpaint_intro_landscape.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class PocketPaintIntroPortrait extends StatelessWidget {
  const PocketPaintIntroPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'packages/component_library/assets/img/pocketpaint_intro_portrait.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

class PocketPaintLogoSmall extends StatelessWidget {
  const PocketPaintLogoSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'packages/component_library/assets/img/pocketpaint_logo_small.png',
      ),
    );
  }
}
