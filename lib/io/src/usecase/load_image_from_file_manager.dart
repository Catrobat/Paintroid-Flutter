import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/core/loggable_mixin.dart';
import 'package:paintroid/io/io.dart';

extension on File {
  String? get extension {
    final list = path.split(".");
    if (list.isEmpty) return null;
    return list.last;
  }
}

class LoadImageFromFileManager with LoggableMixin {
  final IFileService fileService;
  final IImageService imageService;
  final CatrobatImageSerializer catrobatImageSerializer;

  LoadImageFromFileManager(
      this.fileService, this.imageService, this.catrobatImageSerializer);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    const ver = CatrobatImage.latestVersion;
    final serializer = ref.watch(CatrobatImageSerializer.provider(ver));
    return LoadImageFromFileManager(fileService, imageService, serializer);
  });

  TaskEither<Failure, ImageFromFile> prepareTask() =>
      fileService.pick().flatMap((file) {
        try {
          switch (file.extension) {
            case "jpg":
            case "jpeg":
            case "png":
              return imageService.import(file.readAsBytesSync()).flatMap((img) {
                return TaskEither.right(ImageFromFile.rasterImage(img));
              });
            case "catrobat-image":
              final image =
                  catrobatImageSerializer.fromBytes(file.readAsBytesSync());
              final task = image.backgroundImageData != null &&
                      image.backgroundImageData!.isNotEmpty
                  ? imageService.import(image.backgroundImageData!)
                  : TaskEither<Failure, Image?>.right(null);
              return task.flatMap((img) {
                return TaskEither.right(
                    ImageFromFile.catrobatImage(image, backgroundImage: img));
              });
            default:
              return TaskEither.left(LoadImageFailure.invalidImage);
          }
        } on FileSystemException catch (err, stacktrace) {
          logger.severe("Failed to read file", err, stacktrace);
          return TaskEither.left(LoadImageFailure.invalidImage);
        } catch (err, stacktrace) {
          logger.severe("Could not load image", err, stacktrace);
          return TaskEither.left(LoadImageFailure.unidentified);
        }
      });
}
