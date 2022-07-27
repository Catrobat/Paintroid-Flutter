import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/core/failure.dart';

import '../service/image_service.dart';
import '../service/photo_library_service.dart';

class LoadImageFromPhotoLibrary {
  final IImageService imageService;
  final IPhotoLibraryService photoLibraryService;

  const LoadImageFromPhotoLibrary(this.imageService, this.photoLibraryService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final photoLibraryService = ref.watch(IPhotoLibraryService.provider);
    return LoadImageFromPhotoLibrary(imageService, photoLibraryService);
  });

  Future<Result<Image, Failure>> call() => photoLibraryService
      .pick()
      .andThenAsync((imageBytes) => imageService.import(imageBytes));
}
