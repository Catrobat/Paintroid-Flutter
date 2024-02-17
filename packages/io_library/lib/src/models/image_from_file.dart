import 'dart:ui';

import 'package:io_library/io_library.dart';

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
