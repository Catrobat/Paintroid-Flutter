// Dart imports:
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/painting.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:oxidized/oxidized.dart';

// Project imports:
import 'package:paintroid/core/models/loggable_mixin.dart';
import 'package:paintroid/core/models/ora_image.dart';
import 'package:paintroid/core/utils/failure.dart';
import 'package:paintroid/core/utils/load_image_failure.dart';
import 'package:paintroid/core/utils/save_image_failure.dart';

abstract class IImageService {
  Future<Result<ui.Image, Failure>> import(Uint8List fileData);

  /// Value between 1-100 (both inclusive)
  Future<Result<Uint8List, Failure>> exportAsJpg(ui.Image image, int quality);

  Future<Result<Uint8List, Failure>> exportAsPng(ui.Image image);

  Future<Result<Uint8List, Failure>> exportAsOra(ui.Image image);

  Result<Uint8List, Failure> getProjectPreview(String? path);

  static final provider = Provider<IImageService>((ref) => ImageService());
}

class ImageService with LoggableMixin implements IImageService {
  @override
  Future<Result<ui.Image, Failure>> import(Uint8List fileData) async {
    try {
      return Result.ok(await decodeImageFromList(fileData));
    } catch (e, stacktrace) {
      logger.severe("Couldn't decode image from fileData", e, stacktrace);
      return const Result.err(LoadImageFailure.invalidImage);
    }
  }

  @override
  Future<Result<Uint8List, Failure>> exportAsJpg(
      ui.Image image, int quality) async {
    try {
      final byteData = await image.toByteData();
      if (byteData == null) throw 'Unable to convert canvas Image to bytes';
      final rawBytes = byteData.buffer.asUint8List();
      final img = Image.fromBytes(image.width, image.height, rawBytes);
      return Result.ok(Uint8List.fromList(encodeJpg(img, quality: quality)));
    } catch (err, stacktrace) {
      logger.severe('Could not export to Jpg', err, stacktrace);
      return const Result.err(SaveImageFailure.unidentified);
    }
  }

  @override
  Future<Result<Uint8List, Failure>> exportAsPng(ui.Image image) async {
    try {
      final byteData = await image.toByteData();
      if (byteData == null) throw 'Unable to convert canvas Image to bytes';
      final rawBytes = byteData.buffer.asUint8List();
      final img = Image.fromBytes(image.width, image.height, rawBytes);
      return Result.ok(Uint8List.fromList(encodePng(img)));
    } catch (err, stacktrace) {
      logger.severe('Could not export to Png', err, stacktrace);
      return const Result.err(SaveImageFailure.unidentified);
    }
  }

  @override
  Future<Result<Uint8List, Failure>> exportAsOra(ui.Image image) async {
    try {
      final img.Image layer = await convertUiImageToImgImage(image);
      final oraImage = OraImage(
        width: image.width,
        height: image.height,
        layers: [layer],
        xmlMetadata: generateXmlMetadataForOra([layer]),
      );
      final bytes = oraImage.toBytes();
      return Result.ok(bytes);
    } catch (err, stacktrace) {
      logger.severe('Could not export to Ora', err, stacktrace);
      return const Result.err(SaveImageFailure.unidentified);
    }
  }

  Future<img.Image> convertUiImageToImgImage(ui.Image uiImage) async {
    final byteData =
        await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    final buffer = byteData!.buffer.asUint8List();

    return img.Image.fromBytes(
      uiImage.width,
      uiImage.height,
      buffer,
      format: img.Format.rgba,
    );
  }

  String generateXmlMetadataForOra(List<img.Image> layers) {
    var buffer = StringBuffer();
    buffer.writeln('<image>');

    for (int i = 0; i < layers.length; i++) {
      buffer.writeln(
          '<layer name="Layer $i" src="data/layer_$i.png" x="0" y="0" opacity="1.0"/>');
    }

    buffer.writeln('</image>');
    return buffer.toString();
  }

  @override
  Result<Uint8List, Failure> getProjectPreview(String? path) {
    try {
      if (path == null) throw 'Unable to get the project preview';
      final file = File(path);
      return Result.ok(file.readAsBytesSync());
    } catch (err, stacktrace) {
      logger.severe('Could not get the project preview', err, stacktrace);
      return const Result.err(LoadImageFailure.invalidImage);
    }
  }
}
