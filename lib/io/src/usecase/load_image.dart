import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/image_service.dart';

class LoadImage {
  final IImageService imageService;

  const LoadImage(this.imageService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    return LoadImage(imageService);
  });

  Future<Image?> call() => imageService.loadFromPhotoLibrary();
}
