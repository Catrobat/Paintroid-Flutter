import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

abstract class IImageService {
  Future<ui.Image?> loadFromPhotoLibrary();

  /// Quality: 1-100
  Future<Uint8List> exportAsJpg(ui.Image image, int quality);

  Future<Uint8List> exportAsPng(ui.Image image);

  static final provider = Provider<IImageService>(
    (ref) => ImageService(ImagePicker()),
  );
}

class ImageService implements IImageService {
  final ImagePicker imagePicker;

  const ImageService(this.imagePicker);

  @override
  Future<ui.Image?> loadFromPhotoLibrary() async {
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      return await decodeImageFromList(bytes);
    }
    return null;
  }

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
