import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';
import 'package:oxidized/oxidized.dart';

class SaveAsCatrobatImage with LoggableMixin {
  final IFileService _fileService;
  final IPermissionService permissionService;
  final CatrobatImageSerializer _catrobatImageSerializer;

  SaveAsCatrobatImage(
      this._fileService, this.permissionService, this._catrobatImageSerializer);

  static final provider = Provider((ref) {
    final fileService = ref.watch(IFileService.provider);
    final permissionService = ref.watch(IPermissionService.provider);
    const ver = CatrobatImage.latestVersion;
    final serializer = ref.watch(CatrobatImageSerializer.provider(ver));
    return SaveAsCatrobatImage(fileService, permissionService, serializer);
  });

  Future<Result<File, Failure>> call(
      CatrobatImageMetaData data, CatrobatImage image, bool isAProject) async {
    if (!(await permissionService.requestAccessToSharedFileStorage())) {
      return const Result.err(SaveImageFailure.permissionDenied);
    }
    final nameWithExt = '${data.name}.${data.format.extension}';
    try {
      final bytes = await _catrobatImageSerializer.toBytes(image);
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
