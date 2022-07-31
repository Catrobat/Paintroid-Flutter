import 'dart:ui';

import 'package:paintroid/io/io.dart';

class ImageFromFile {
  final Image? rasterImage;
  final CatrobatImage? catrobatImage;

  const ImageFromFile.catrobatImage(
    CatrobatImage image, {
    Image? backgroundImage,
  })  : catrobatImage = image,
        rasterImage = backgroundImage;

  const ImageFromFile.rasterImage(Image image)
      : rasterImage = image,
        catrobatImage = null;
}
