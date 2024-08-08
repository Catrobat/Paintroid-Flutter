import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import 'package:paintroid/core/models/catrobat_image.dart';
import 'package:paintroid/core/models/image_meta_data.dart';
import 'package:paintroid/core/models/loggable_mixin.dart';
import 'package:paintroid/core/providers/object/file_service.dart';
import 'package:paintroid/core/providers/object/permission_service.dart';
import 'package:paintroid/core/utils/failure.dart';
import 'package:paintroid/core/utils/save_image_failure.dart';

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
