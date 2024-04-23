// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

// Project imports:
import 'package:io_library/io_library.dart';

class SaveAsCatrobatImage with LoggableMixin {
  final IFileService _fileService;
  final IPermissionService permissionService;

  SaveAsCatrobatImage(this._fileService, this.permissionService);

  static final provider = Provider((ref) {
    final fileService = ref.watch(IFileService.provider);
    final permissionService = ref.watch(IPermissionService.provider);
    return SaveAsCatrobatImage(fileService, permissionService);
  });

  Future<Result<File, Failure>> call(
      CatrobatImageMetaData data, CatrobatImage image, bool isAProject) async {
    if (!(await permissionService.requestAccessToSharedFileStorage())) {
      return const Result.err(SaveImageFailure.permissionDenied);
    }
    final nameWithExt = '${data.name}.${data.format.extension}';
    try {
      final bytes = image.toBytes();
      if (isAProject) {
        return _fileService.saveToApplicationDirectory(nameWithExt, bytes);
      }
      return _fileService.save(nameWithExt, bytes);
    } catch (err, stacktrace) {
      logger.severe(
          'Failed to serialize CatrobatImage object', err, stacktrace);
      return const Result.err(SaveImageFailure.unidentified);
    }
  }
}
