import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image/image.dart';
import 'package:paintroid/core/loggable_mixin.dart';

abstract class IImageService {
  TaskOption<ui.Image> import(Uint8List fileData);

  /// Quality: 1-100
  TaskOption<Uint8List> exportAsJpg(ui.Image image, int quality);

  TaskOption<Uint8List> exportAsPng(ui.Image image);

  static final provider = Provider<IImageService>(
    (ref) => ImageService(),
  );
}

class ImageService with LoggableMixin implements IImageService {
  ImageService();

  @override
  TaskOption<ui.Image> import(Uint8List fileData) => TaskOption(() async {
        try {
          return Some(await decodeImageFromList(fileData));
        } catch (e, stacktrace) {
          log.severe("Couldn't decode image from fileData", e, stacktrace);
          return const None();
        }
      });

  @override
  TaskOption<Uint8List> exportAsJpg(ui.Image image, int quality) =>
      TaskOption(() async {
        try {
          final byteData = await image.toByteData();
          if (byteData == null) throw "Unable to convert canvas Image to bytes";
          final rawBytes = byteData.buffer.asUint8List();
          final img = Image.fromBytes(image.width, image.height, rawBytes);
          return Some(Uint8List.fromList(encodeJpg(img, quality: quality)));
        } catch (err, stacktrace) {
          log.severe("Could not export to Jpg", err, stacktrace);
          return const None();
        }
      });

  @override
  TaskOption<Uint8List> exportAsPng(ui.Image image) => TaskOption(() async {
        try {
          final byteData = await image.toByteData();
          if (byteData == null) throw "Unable to convert canvas Image to bytes";
          final rawBytes = byteData.buffer.asUint8List();
          final img = Image.fromBytes(image.width, image.height, rawBytes);
          return Some(Uint8List.fromList(encodePng(img)));
        } catch (err, stacktrace) {
          log.severe("Could not export to Jpg", err, stacktrace);
          return const None();
        }
      });
}
