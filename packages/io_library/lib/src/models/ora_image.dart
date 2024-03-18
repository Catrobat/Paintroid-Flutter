import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:archive/archive.dart';

class OraImage {
  final int width;
  final int height;
  final List<img.Image> layers;
  final String xmlMetadata;

  OraImage({
    required this.width,
    required this.height,
    required this.layers,
    required this.xmlMetadata,
  });

  Uint8List toBytes() {
    final archive = Archive();

    for (int i = 0; i < layers.length; i++) {
      final layer = layers[i];
      final encoder = img.PngEncoder();
      final layerData = encoder.encodeImage(layer);
      archive.addFile(ArchiveFile('layer_$i.png', layerData.length, layerData));
    }

    final encodedXml = utf8.encode(xmlMetadata);
    archive.addFile(ArchiveFile('stack.xml', encodedXml.length, encodedXml));

    final zipEncoder = ZipEncoder();
    return Uint8List.fromList(zipEncoder.encode(archive)!);
  }
}
