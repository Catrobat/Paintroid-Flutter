// Project imports:
import 'package:paintroid/core/enums/image_format.dart';

abstract class ImageMetaData {
  final String name;
  final ImageFormat format;

  const ImageMetaData(this.name, this.format);

  @override
  String toString() => '$name.${format.extension}';
}

class JpgMetaData extends ImageMetaData {
  /// Value between 1-100 (both inclusive)
  final int quality;

  const JpgMetaData(String name, this.quality) : super(name, ImageFormat.jpg);

  @override
  String toString() => '$name.${format.extension} - $quality%';
}

class PngMetaData extends ImageMetaData {
  const PngMetaData(String name) : super(name, ImageFormat.png);
}

class CatrobatImageMetaData extends ImageMetaData {
  const CatrobatImageMetaData(String name)
      : super(name, ImageFormat.catrobatImage);
}


class OraMetaData extends ImageMetaData {
  const OraMetaData(String name) : super(name, ImageFormat.ora);
}