import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:paintroid/core/failure.dart';

import '../service/file_service.dart';
import '../service/image_service.dart';

class LoadImage {
  final IImageService imageService;
  final IFileService fileService;

  final loadImageFailure = const Failure("Failed to load image");

  const LoadImage(this.imageService, this.fileService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    return LoadImage(imageService, fileService);
  });

  TaskEither<Failure, Image> prepareTask() {
    return TaskEither(() async {
      final option = await fileService
          .loadFromPhotoLibrary()
          .flatMap((imageBytes) => imageService.import(imageBytes))
          .run();
      return option.toEither(() => loadImageFailure);
    });
  }
}
