import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:archive/archive.dart';
import 'package:image/image.dart' as img;
import 'package:xml/xml.dart' as xml;
import 'package:paintroid/core/models/loggable_mixin.dart';

class ProcessOra with LoggableMixin {
  Future<List<ui.Image>> processOraFile(Archive archive) async {
    List<ui.Image> layers = [];
    ArchiveFile? stackXmlFile = archive.findFile('stack.xml');

    if (stackXmlFile == null) {
      logger.severe('Error: stack.xml not found in ORA file.');
      return layers;
    }

    if (stackXmlFile.content == null || stackXmlFile.content is! List<int>) {
      logger.severe('Error: stack.xml content is invalid.');
      return layers;
    }

    String xmlContent = String.fromCharCodes(stackXmlFile.content as List<int>);
    xml.XmlDocument document;
    try {
      document = xml.XmlDocument.parse(xmlContent);
    } catch (e, s) {
      logger.severe('Error parsing stack.xml', e, s);
      return layers;
    }

    var imageElement = document.rootElement;
    var stackElement = imageElement.findElements('stack').firstOrNull;

    if (stackElement == null) {
      logger.severe('Error: <stack> element not found in stack.xml.');
      return layers;
    }

    for (var layerElement in stackElement.findElements('layer')) {
      String? layerSrc = layerElement.getAttribute('src');
      if (layerSrc == null) {
        logger
            .warning('Warning: Layer element missing src attribute. Skipping.');
        continue;
      }

      ArchiveFile? imageFile = archive.findFile(layerSrc);
      if (imageFile == null || !imageFile.isFile) {
        logger.warning(
            'Warning: Image file $layerSrc not found in archive for a layer. Skipping.');
        continue;
      }

      if (imageFile.content == null || imageFile.content is! List<int>) {
        logger.warning(
            'Warning: Image file $layerSrc content is invalid. Skipping.');
        continue;
      }

      img.Image? decodedImage;
      try {
        decodedImage = img.decodeImage(imageFile.content as List<int>);
        if (decodedImage == null) {
          logger.warning(
              'Warning: decodeImage returned null for $layerSrc. Skipping.');
          continue;
        }
      } catch (e, s) {
        logger.severe('Error decoding image $layerSrc. Skipping.', e, s);
        continue;
      }

      ui.Image layerUiImage = await convertImgImageToUiImage(decodedImage);
      layers.add(layerUiImage);
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
