import 'dart:ui';

import 'package:paintroid/core/models/catrobat_image.dart';

class ImageFromFile {
  final Image? rasterImage;
  final CatrobatImage? catrobatImage;
  final List<Image>? oraImageLayers;

  const ImageFromFile.catrobatImage(
    CatrobatImage image, {
    Image? backgroundImage,
  })  : catrobatImage = image,
        oraImageLayers = null,
  rasterImage = backgroundImage;

  const ImageFromFile.rasterImage(Image image)
      : rasterImage = image,
        oraImageLayers = null,
        catrobatImage = null;
}
