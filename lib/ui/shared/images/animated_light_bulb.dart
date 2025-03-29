import 'package:flutter/material.dart';

class AnimatedLightBulb extends StatelessWidget {
  const AnimatedLightBulb({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        'assets/img/animated_light_bulb.gif',
        repeat: ImageRepeat.repeat,
        cacheWidth: 50,
        cacheHeight: 50,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}
