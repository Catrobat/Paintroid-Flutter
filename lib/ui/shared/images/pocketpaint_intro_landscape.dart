import 'package:flutter/widgets.dart';

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
