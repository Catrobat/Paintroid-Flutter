import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/data/data.dart';

enum ImageFormat {
  png("png"),
  jpg("jpg");

  const ImageFormat(this.extension);

  final String extension;
}

class SaveImage {
  final IImageService imageService;
  final IFileService fileService;

  const SaveImage({required this.imageService, required this.fileService});

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    return SaveImage(imageService: imageService, fileService: fileService);
  });

  Future<void> call({
    required String name,
    required ImageFormat type,
    required Image image,
    /// From 1-100
    int quality = 100,
  }) async {
    final nameWithExt = "$name.${type.extension}";
    switch (type) {
      case ImageFormat.png:
        final imageBytes = await imageService.exportAsPng(image);
        await fileService.saveToPhotos(nameWithExt, imageBytes);
        break;
      case ImageFormat.jpg:
        final imageBytes = await imageService.exportAsJpg(image, quality);
        await fileService.saveToPhotos(nameWithExt, imageBytes);
        break;
    }
  }
}
