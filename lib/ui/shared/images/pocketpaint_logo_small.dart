import 'package:flutter/widgets.dart';

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
