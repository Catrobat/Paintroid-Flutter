import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:archive/archive.dart';
import 'package:image/image.dart' as img;

class ProcessOra {
  Future<List<ui.Image>> processOraFile(Archive archive) async {
    List<ui.Image> layers = [];

    for (var file in archive) {
      if (file.isFile && (file.name.endsWith('.png') || file.name.endsWith('.jpg')) || file.name.endsWith('.ora')) {
        // Decode the image using the image package
        print("Processing layer: ${file.name}");
        img.Image? decodedImage = img.decodeImage(file.content as List<int>);

        if (decodedImage != null) {
          // Convert the img.Image to ui.Image
          print("Decoded layer: ${file.name}");
          ui.Image layer = await convertImgImageToUiImage(decodedImage);
          layers.add(layer);
          print("Converted layer: ${file.name}");
        }
        else {
          print("Failed to decode layer: ${file.name}");
        }
      }
    }

    return layers;
  }

  Future<ui.Image> convertImgImageToUiImage(img.Image image) async {
    // This function converts an img.Image object to a ui.Image object.
    // Encode the image to a PNG
    List<int> pngBytes = img.encodePng(image);

    // Use a codec to decode the PNG bytes to a ui.Image
    final codec = await ui.instantiateImageCodec(Uint8List.fromList(pngBytes));
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
