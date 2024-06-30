import 'package:flutter/widgets.dart';

class CheckerboardImage extends StatelessWidget {
  const CheckerboardImage({super.key});

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
