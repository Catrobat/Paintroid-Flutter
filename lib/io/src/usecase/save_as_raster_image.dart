import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:fpdart/fpdart.dart' show TaskEither, Unit;
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/io/io.dart';

class SaveAsRasterImage {
  final IImageService imageService;
  final IPhotoLibraryService photoLibraryService;

  const SaveAsRasterImage(this.imageService, this.photoLibraryService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final photoLibraryService = ref.watch(IPhotoLibraryService.provider);
    return SaveAsRasterImage(imageService, photoLibraryService);
  });

  TaskEither<Failure, Unit> prepareTaskForJpg(JpgMetaData data, Image image) {
    final nameWithExt = "${data.name}.${data.format.extension}";
    return imageService.exportAsJpg(image, data.quality).flatMap(
        (imageBytes) => photoLibraryService.save(nameWithExt, imageBytes));
  }

  TaskEither<Failure, Unit> prepareTaskForPng(PngMetaData data, Image image) {
    final nameWithExt = "${data.name}.${data.format.extension}";
    return imageService.exportAsPng(image).flatMap(
        (imageBytes) => photoLibraryService.save(nameWithExt, imageBytes));
  }
}
