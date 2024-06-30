import 'package:flutter/widgets.dart';

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
