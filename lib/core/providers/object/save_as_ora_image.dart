// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

// Project imports:
import 'package:paintroid/core/models/ora_image.dart';
import 'package:paintroid/core/providers/object/file_service.dart';
import 'package:paintroid/core/providers/object/permission_service.dart';
import 'package:paintroid/core/utils/failure.dart';
import 'package:paintroid/core/utils/save_image_failure.dart';

class SaveAsOraImage {
  final IFileService _fileService;
  final IPermissionService _permissionService;

  SaveAsOraImage(this._fileService, this._permissionService);

  static final provider = Provider((ref) {
    final fileService = ref.watch(IFileService.provider);
    final permissionService = ref.watch(IPermissionService.provider);
    return SaveAsOraImage(fileService, permissionService);
  });

  Future<Result<File, Failure>> call(OraImage image, String fileName) async {
    if (!(await _permissionService.requestAccessToSharedFileStorage())) {
      return const Result.err(SaveImageFailure.permissionDenied);
    }

    final bytes = image.toBytes();
    return _fileService.save(fileName, bytes);
  }
}
