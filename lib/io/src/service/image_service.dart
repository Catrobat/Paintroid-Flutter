import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/core/loggable_mixin.dart';

import '../failure/load_image_failure.dart';
import '../failure/save_image_failure.dart';

abstract class IImageService {
  Future<Result<ui.Image, Failure>> import(Uint8List fileData);

  Future<Result<Uint8List, Failure>> export(ui.Image image);

  /// Value between 1-100 (both inclusive)
  Future<Result<Uint8List, Failure>> exportAsJpg(ui.Image image, int quality);

  Future<Result<Uint8List, Failure>> exportAsPng(ui.Image image);

  static final provider = Provider<IImageService>((ref) => ImageService());
}

class ImageService with LoggableMixin implements IImageService {
  @override
  Future<Result<ui.Image, Failure>> import(Uint8List fileData) async {
    try {
      return Result.ok(await decodeImageFromList(fileData));
    } catch (e, stacktrace) {
      logger.severe("Couldn't decode image from fileData", e, stacktrace);
      return Result.err(LoadImageFailure.invalidImage);
    }
  }

  @override
  Future<Result<Uint8List, Failure>> export(ui.Image image) async {
    try {
      final byteData = await image.toByteData();
      if (byteData == null) throw "Unable to convert canvas Image to bytes";
      return Result.ok(byteData.buffer.asUint8List());
    } catch (err, stacktrace) {
      logger.severe("Could not export to Jpg", err, stacktrace);
      return Result.err(SaveImageFailure.unidentified);
    }
  }

  @override
  Future<Result<Uint8List, Failure>> exportAsJpg(
      ui.Image image, int quality) async {
    try {
      final byteData = await image.toByteData();
      if (byteData == null) throw "Unable to convert canvas Image to bytes";
      final rawBytes = byteData.buffer.asUint8List();
      final img = Image.fromBytes(image.width, image.height, rawBytes);
      return Result.ok(Uint8List.fromList(encodeJpg(img, quality: quality)));
    } catch (err, stacktrace) {
      logger.severe("Could not export to Jpg", err, stacktrace);
      return Result.err(SaveImageFailure.unidentified);
    }
  }

  @override
  Future<Result<Uint8List, Failure>> exportAsPng(ui.Image image) async {
    try {
      final byteData = await image.toByteData();
      if (byteData == null) throw "Unable to convert canvas Image to bytes";
      final rawBytes = byteData.buffer.asUint8List();
      final img = Image.fromBytes(image.width, image.height, rawBytes);
      return Result.ok(Uint8List.fromList(encodePng(img)));
    } catch (err, stacktrace) {
      logger.severe("Could not export to Png", err, stacktrace);
      return Result.err(SaveImageFailure.unidentified);
    }
  }
}
