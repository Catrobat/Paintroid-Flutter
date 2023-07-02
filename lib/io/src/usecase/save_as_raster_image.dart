import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/io/io.dart';

class SaveAsRasterImage {
  final IImageService imageService;
  final IPermissionService permissionService;
  final IPhotoLibraryService photoLibraryService;

  const SaveAsRasterImage(
      this.imageService, this.permissionService, this.photoLibraryService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final permissionService = ref.watch(IPermissionService.provider);
    final photoLibraryService = ref.watch(IPhotoLibraryService.provider);
    return SaveAsRasterImage(
        imageService, permissionService, photoLibraryService);
  });

  Future<Result<Unit, Failure>> call(ImageMetaData data, Image image) async {
    final nameWithExt = "${data.name}.${data.format.extension}";
    if (!(await permissionService.requestAccessForSavingToPhotos())) {
      return Result.err(SaveImageFailure.permissionDenied);
    }
    return await (data is JpgMetaData
            ? imageService.exportAsJpg(image, data.quality)
            : imageService.exportAsPng(image))
        .andThenAsync(
            (imageBytes) => photoLibraryService.save(nameWithExt, imageBytes));
  }
}
