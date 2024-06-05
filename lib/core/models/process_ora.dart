// Dart imports:
import 'dart:typed_data';
import 'dart:ui' as ui;

// Package imports:
import 'package:archive/archive.dart';
import 'package:image/image.dart' as img;

class ProcessOra {
  Future<List<ui.Image>> processOraFile(Archive archive) async {
    List<ui.Image> layers = [];

    for (var file in archive) {
      if (file.isFile &&
              (file.name.endsWith('.png') || file.name.endsWith('.jpg')) ||
          file.name.endsWith('.ora')) {
        img.Image? decodedImage = img.decodeImage(file.content as List<int>);

        if (decodedImage != null) {
          ui.Image layer = await convertImgImageToUiImage(decodedImage);
          layers.add(layer);
        }
      }
    }

    return layers;
  }

  Future<ui.Image> convertImgImageToUiImage(img.Image image) async {
    List<int> pngBytes = img.encodePng(image);

    final codec = await ui.instantiateImageCodec(Uint8List.fromList(pngBytes));
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
