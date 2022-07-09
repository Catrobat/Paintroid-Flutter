import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/file_service.dart';
import '../service/image_service.dart';

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
    required ImageMetaData metaData,
    required Image image,
  }) async {
    final nameWithExt = "$metaData.name.${metaData.format.extension}";
    switch (metaData.format) {
      case ImageFormat.png:
        final imageBytes = await imageService.exportAsPng(image);
        await fileService.saveToPhotos(nameWithExt, imageBytes);
        break;
      case ImageFormat.jpg:
        final imageBytes =
            await imageService.exportAsJpg(image, metaData.quality);
        await fileService.saveToPhotos(nameWithExt, imageBytes);
        break;
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
