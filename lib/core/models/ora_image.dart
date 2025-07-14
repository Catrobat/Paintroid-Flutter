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

    final mimetypeContent = utf8.encode('image/openraster');
    archive.addFile(
      ArchiveFile('mimetype', mimetypeContent.length, mimetypeContent)
        ..compress = false,
    );

    for (int i = 0; i < layers.length; i++) {
      final layer = layers[i];
      final encoder = img.PngEncoder();
      final layerData = encoder.encodeImage(layer);
      archive.addFile(
          ArchiveFile('data/layer_$i.png', layerData.length, layerData));
    }

    final encodedXml = utf8.encode(xmlMetadata);
    archive.addFile(ArchiveFile('stack.xml', encodedXml.length, encodedXml));

    final zipEncoder = ZipEncoder();
    return Uint8List.fromList(zipEncoder.encode(archive)!);
  }

  static String generateXmlMetadataForOra(
      List<img.Image> layers, int width, int height) {
    var buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<image w="$width" h="$height">');
    buffer.writeln('  <stack>');

    for (int i = 0; i < layers.length; i++) {
      final layerName = 'Layer $i';
      final layerSrc = 'data/layer_$i.png';
      buffer.writeln(
          '    <layer name="$layerName" src="$layerSrc" x="0" y="0" opacity="1.0" visibility="visible"/>');
    }

    buffer.writeln('  </stack>');
    buffer.writeln('</image>');
    return buffer.toString();
  }
}
