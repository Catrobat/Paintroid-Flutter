import 'package:colorpicker/utils/assets.dart';
import 'package:flutter/material.dart';

class CheckerboardSquare extends StatelessWidget {
  const CheckerboardSquare({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: PackageAssets.getCheckerboardImgAsset(),
          fit: BoxFit.contain,
          repeat: ImageRepeat.repeat,
        ),
      ),
    );
  }
}
