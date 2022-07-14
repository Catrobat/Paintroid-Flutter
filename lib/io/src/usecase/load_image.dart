import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:paintroid/core/failure.dart';

import '../service/file_service.dart';
import '../service/image_service.dart';

class LoadImage {
  final IImageService imageService;
  final IFileService fileService;

  const LoadImage(this.imageService, this.fileService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    return LoadImage(imageService, fileService);
  });

  TaskEither<Failure, Image> prepareTask() => fileService
      .loadFromPhotoLibrary()
      .flatMap((imageBytes) => imageService.import(imageBytes));
}
