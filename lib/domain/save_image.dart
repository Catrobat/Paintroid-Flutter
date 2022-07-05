import 'dart:ui';

import 'package:paintroid/data/data.dart';

enum FileType {
  png("png"),
  jpg("jpg");

  const FileType(this.extension);

  final String extension;
}

class SaveImage {
  final IImageService imageService;
  final IFileService fileService;

  const SaveImage({required this.imageService, required this.fileService});

  Future<void> call({
    required String name,
    required FileType type,
    required Image image,
  }) async {
    final nameWithExt = "$name.${type.extension}";
    switch (type) {
      case FileType.png:
        final imageBytes = await imageService.exportAsPng(image);
        await fileService.saveToPhotos(nameWithExt, imageBytes);
        break;
      case FileType.jpg:
        final imageBytes = await imageService.exportAsJpg(image, 100);
        await fileService.saveToPhotos(nameWithExt, imageBytes);
        break;
    }
  }
}
