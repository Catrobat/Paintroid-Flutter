import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:paintroid/core/failure.dart';

import '../entity/image_format.dart';
import '../service/image_service.dart';
import '../service/photo_library_service.dart';

class SaveImage {
  final IImageService imageService;
  final IPhotoLibraryService photoLibraryService;

  const SaveImage(this.imageService, this.photoLibraryService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final photoLibraryService = ref.watch(IPhotoLibraryService.provider);
    return SaveImage(imageService, photoLibraryService);
  });

  TaskEither<Failure, Unit> prepareTask({
    required ImageMetaData metaData,
    required Image image,
  }) {
    final nameWithExt = "${metaData.name}.${metaData.format.extension}";
    switch (metaData.format) {
      case ImageFormat.png:
        return imageService.exportAsPng(image).flatMap(
            (imageBytes) => photoLibraryService.save(nameWithExt, imageBytes));
      case ImageFormat.jpg:
        return imageService.exportAsJpg(image, metaData.quality).flatMap(
            (imageBytes) => photoLibraryService.save(nameWithExt, imageBytes));
    }
  }
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
