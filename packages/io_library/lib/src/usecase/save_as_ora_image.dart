import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';
import 'package:oxidized/oxidized.dart';

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
