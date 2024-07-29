import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import 'package:paintroid/core/providers/object/image_service.dart';
import 'package:paintroid/core/providers/object/permission_service.dart';
import 'package:paintroid/core/providers/object/photo_library_service.dart';
import 'package:paintroid/core/utils/failure.dart';
import 'package:paintroid/core/utils/load_image_failure.dart';

class LoadImageFromPhotoLibrary {
  final IImageService imageService;
  final IPermissionService permissionService;
  final IPhotoLibraryService photoLibraryService;

  const LoadImageFromPhotoLibrary(
      this.imageService, this.permissionService, this.photoLibraryService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final permissionService = ref.watch(IPermissionService.provider);
    final photoLibraryService = ref.watch(IPhotoLibraryService.provider);
    return LoadImageFromPhotoLibrary(
        imageService, permissionService, photoLibraryService);
  });

  Future<Result<Image, Failure>> call() async {
    if (!(await permissionService.requestAccessToPickPhotos())) {
      return const Result.err(LoadImageFailure.permissionDenied);
    }
    return await photoLibraryService
        .pick()
        .andThenAsync((imageBytes) => imageService.import(imageBytes));
  }
}
