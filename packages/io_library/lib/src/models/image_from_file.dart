import 'dart:ui';

import 'package:io_library/io_library.dart';

class ImageFromFile {
  final Image? rasterImage;
  final CatrobatImage? catrobatImage;
  final List<Image>? oraImageLayers;

  const ImageFromFile.catrobatImage(
    CatrobatImage image, {
    Image? backgroundImage,
  })  : catrobatImage = image,
        rasterImage = backgroundImage,
        oraImageLayers = null;

  const ImageFromFile.rasterImage(Image image)
      : rasterImage = image,
        catrobatImage = null,
        oraImageLayers = null;

  const ImageFromFile.oraImage(List<Image> layers)
      : oraImageLayers = layers,
        rasterImage = null,
        catrobatImage = null;
}
