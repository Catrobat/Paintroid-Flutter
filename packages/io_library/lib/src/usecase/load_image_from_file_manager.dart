import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';
import 'package:oxidized/oxidized.dart';

extension on File {
  String? get extension {
    final list = path.split('.');
    if (list.isEmpty) return null;
    return list.last;
  }
}

class LoadImageFromFileManager with LoggableMixin {
  final IFileService fileService;
  final IImageService imageService;
  final IPermissionService permissionService;
  final CatrobatImageSerializer catrobatImageSerializer;

  LoadImageFromFileManager(this.fileService, this.imageService,
      this.permissionService, this.catrobatImageSerializer);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    final permissionService = ref.watch(IPermissionService.provider);
    const ver = CatrobatImage.latestVersion;
    final serializer = ref.watch(CatrobatImageSerializer.provider(ver));
    return LoadImageFromFileManager(
        fileService, imageService, permissionService, serializer);
  });

  Future<Result<ImageFromFile, Failure>> call(
      Result<File, Failure>? file) async {
    if (file == null) {
      if (!(await permissionService.requestAccessToSharedFileStorage())) {
        return const Result.err(SaveImageFailure.permissionDenied);
      }
      file = await fileService.pick();
    }

    return await file.andThenAsync((file) async {
      try {
        switch (file.extension) {
          case 'jpg':
          case 'jpeg':
          case 'png':
            return imageService
                .import(await file.readAsBytes())
                .map((img) => ImageFromFile.rasterImage(img));
          case 'catrobat-image':
            final image = await catrobatImageSerializer
                .fromBytes(await file.readAsBytes());
            return Result.ok(ImageFromFile.catrobatImage(
              image,
              backgroundImage: image.backgroundImage,
            ));
          default:
            return const Result.err(LoadImageFailure.invalidImage);
        }
      } on FileSystemException catch (err, stacktrace) {
        logger.severe('Failed to read file', err, stacktrace);
        return const Result.err(LoadImageFailure.invalidImage);
      } catch (err, stacktrace) {
        logger.severe('Could not load image', err, stacktrace);
        return const Result.err(LoadImageFailure.unidentified);
      }
    });
  }
}
