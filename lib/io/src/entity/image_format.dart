part of 'image_meta_data.dart';

enum ImageFormat {
  png('png'),
  jpg('jpg'),
  catrobatImage('catrobat-image');

  const ImageFormat(this.extension);

  final String extension;
}
