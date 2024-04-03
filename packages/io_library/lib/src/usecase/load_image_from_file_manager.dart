// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

// Project imports:
import 'package:io_library/io_library.dart';

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

  LoadImageFromFileManager(
      this.fileService, this.imageService, this.permissionService);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    final permissionService = ref.watch(IPermissionService.provider);
    return LoadImageFromFileManager(
        fileService, imageService, permissionService);
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
            Uint8List bytes = await file.readAsBytes();
            CatrobatImage catrobatImage = CatrobatImage.fromBytes(bytes);
            Image? backgroundImage =
                await rebuildBackgroundImage(catrobatImage);
            return Result.ok(ImageFromFile.catrobatImage(
              catrobatImage,
              backgroundImage: backgroundImage,
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

  Future<Image?> rebuildBackgroundImage(CatrobatImage catrobatImage) async {
    if (catrobatImage.backgroundImage.isNotEmpty) {
      final backgroundImageData = base64Decode(catrobatImage.backgroundImage);
      final result =
          await imageService.import(Uint8List.fromList(backgroundImageData));
      return result.unwrapOrElse((failure) => throw failure.message);
    }
    return null;
  }
}
