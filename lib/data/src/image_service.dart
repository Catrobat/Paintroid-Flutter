import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image/image.dart';

abstract class IImageService {
  /// Quality: 1-100
  Future<Uint8List> exportAsJpg(ui.Image image, int quality);

  Future<Uint8List> exportAsPng(ui.Image image);
}

class ImageService implements IImageService {
  const ImageService();

  @override
  Future<Uint8List> exportAsJpg(ui.Image image, int quality) async {
    final byteData = await image.toByteData();
    if (byteData == null) throw "Unable to convert canvas Image to bytes";
    final rawBytes = byteData.buffer.asUint8List();
    final img = Image.fromBytes(image.width, image.height, rawBytes);
    return Uint8List.fromList(encodeJpg(img, quality: quality));
  }

  @override
  Future<Uint8List> exportAsPng(ui.Image image) async {
    final byteData = await image.toByteData();
    if (byteData == null) throw "Unable to convert canvas Image to bytes";
    final rawBytes = byteData.buffer.asUint8List();
    final img = Image.fromBytes(image.width, image.height, rawBytes);
    return Uint8List.fromList(encodePng(img));
  }
}
