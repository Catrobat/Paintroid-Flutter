import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:oxidized/oxidized.dart';
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

  Future<Result<Unit, Failure>> call(ImageMetaData data, Image image) {
    final nameWithExt = "${data.name}.${data.format.extension}";
    return (data is JpgMetaData
            ? imageService.exportAsJpg(image, data.quality)
            : imageService.exportAsPng(image))
        .andThenAsync(
            (imageBytes) => photoLibraryService.save(nameWithExt, imageBytes));
  }
}
