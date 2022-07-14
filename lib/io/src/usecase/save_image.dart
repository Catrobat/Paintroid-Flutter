import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:paintroid/core/failure.dart';

import '../service/file_service.dart';
import '../service/image_service.dart';

class SaveImage {
  final IImageService imageService;
  final IFileService fileService;

  const SaveImage(this.imageService, this.fileService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    return SaveImage(imageService, fileService);
  });

  TaskEither<Failure, Unit> prepareTask({
    required ImageMetaData metaData,
    required Image image,
  }) {
    final nameWithExt = "${metaData.name}.${metaData.format.extension}";
    switch (metaData.format) {
      case ImageFormat.png:
        return imageService.exportAsPng(image).flatMap((imageBytes) =>
            fileService.saveToPhotoLibrary(nameWithExt, imageBytes));
      case ImageFormat.jpg:
        return imageService.exportAsJpg(image, metaData.quality).flatMap(
            (imageBytes) =>
                fileService.saveToPhotoLibrary(nameWithExt, imageBytes));
    }
  }
}

enum ImageFormat {
  png("png"),
  jpg("jpg");

  const ImageFormat(this.extension);

  final String extension;
}

@immutable
class ImageMetaData {
  final String name;
  final ImageFormat format;

  /// From 1-100
  final int quality;

  const ImageMetaData(this.name, this.format, this.quality);

  @override
  String toString() => "$name.${format.extension}";
}
