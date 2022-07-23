import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image/image.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/core/loggable_mixin.dart';

import '../failure/load_image_failure.dart';
import '../failure/save_image_failure.dart';

abstract class IImageService {
  TaskEither<Failure, ui.Image> import(Uint8List fileData);

  TaskEither<Failure, Uint8List> export(ui.Image image);

  /// Value between 1-100 (both inclusive)
  TaskEither<Failure, Uint8List> exportAsJpg(ui.Image image, int quality);

  TaskEither<Failure, Uint8List> exportAsPng(ui.Image image);

  static final provider = Provider<IImageService>((ref) => ImageService());
}

class ImageService with LoggableMixin implements IImageService {
  @override
  TaskEither<Failure, ui.Image> import(Uint8List fileData) =>
      TaskEither(() async {
        try {
          return Right(await decodeImageFromList(fileData));
        } catch (e, stacktrace) {
          logger.severe("Couldn't decode image from fileData", e, stacktrace);
          return const Left(LoadImageFailure.invalidImage);
        }
      });

  @override
  TaskEither<Failure, Uint8List> export(ui.Image image) => TaskEither(() async {
        try {
          final byteData = await image.toByteData();
          if (byteData == null) throw "Unable to convert canvas Image to bytes";
          return Right(byteData.buffer.asUint8List());
        } catch (err, stacktrace) {
          logger.severe("Could not export to Jpg", err, stacktrace);
          return const Left(SaveImageFailure.unidentified);
        }
      });

  @override
  TaskEither<Failure, Uint8List> exportAsJpg(ui.Image image, int quality) =>
      TaskEither(() async {
        try {
          final byteData = await image.toByteData();
          if (byteData == null) throw "Unable to convert canvas Image to bytes";
          final rawBytes = byteData.buffer.asUint8List();
          final img = Image.fromBytes(image.width, image.height, rawBytes);
          return Right(Uint8List.fromList(encodeJpg(img, quality: quality)));
        } catch (err, stacktrace) {
          logger.severe("Could not export to Jpg", err, stacktrace);
          return const Left(SaveImageFailure.unidentified);
        }
      });

  @override
  TaskEither<Failure, Uint8List> exportAsPng(ui.Image image) =>
      TaskEither(() async {
        try {
          final byteData = await image.toByteData();
          if (byteData == null) throw "Unable to convert canvas Image to bytes";
          final rawBytes = byteData.buffer.asUint8List();
          final img = Image.fromBytes(image.width, image.height, rawBytes);
          return Right(Uint8List.fromList(encodePng(img)));
        } catch (err, stacktrace) {
          logger.severe("Could not export to Png", err, stacktrace);
          return const Left(SaveImageFailure.unidentified);
        }
      });
}
