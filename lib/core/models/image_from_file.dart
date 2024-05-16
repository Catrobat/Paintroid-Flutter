// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/models/catrobat_image.dart';

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
