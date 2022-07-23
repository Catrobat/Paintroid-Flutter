import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/core/loggable_mixin.dart';
import 'package:paintroid/io/io.dart';

extension on File {
  String? get extension {
    final list = path.split(".");
    if (list.isEmpty) return null;
    return list.last;
  }
}

class LoadImageFromFileManager with LoggableMixin {
  final IFileService fileService;
  final IImageService imageService;
  final CommandManager commandManager;
  final CatrobatImageSerializer catrobatImageSerializer;

  LoadImageFromFileManager(this.fileService, this.imageService,
      this.commandManager, this.catrobatImageSerializer);

  static final provider = Provider((ref) {
    final imageService = ref.watch(IImageService.provider);
    final fileService = ref.watch(IFileService.provider);
    final commandManager = ref.watch(CommandManager.provider);
    const ver = CatrobatImage.latestVersion;
    final serializer = ref.watch(CatrobatImageSerializer.provider(ver));
    return LoadImageFromFileManager(
        fileService, imageService, commandManager, serializer);
  });

  TaskEither<Failure, Image?> prepareTask() =>
      fileService.pick().flatMap((file) {
        try {
          switch (file.extension) {
            case "jpg":
            case "jpeg":
            case "png":
              return imageService.import(file.readAsBytesSync()).flatMap((img) {
                commandManager.resetHistory();
                return TaskEither.right(img);
              });
            case "catrobat-image":
              final image =
                  catrobatImageSerializer.fromBytes(file.readAsBytesSync());
              final task =
                  image.loadedImage != null && image.loadedImage!.isNotEmpty
                      ? imageService.import(image.loadedImage!)
                      : TaskEither<Failure, Image?>.right(null);
              return task.flatMap((img) {
                commandManager.resetHistory(newCommands: image.commands);
                return TaskEither.right(img);
              });
            default:
              return TaskEither.left(LoadImageFailure.invalidImage);
          }
        } on FileSystemException catch (err, stacktrace) {
          logger.severe("Failed to read file", err, stacktrace);
          return TaskEither.left(LoadImageFailure.invalidImage);
        } catch (err, stacktrace) {
          logger.severe("Could not load image", err, stacktrace);
          return TaskEither.left(LoadImageFailure.unidentified);
        }
      });
}
