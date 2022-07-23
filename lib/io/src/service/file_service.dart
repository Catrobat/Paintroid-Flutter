import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/core/loggable_mixin.dart';
import 'package:paintroid/io/io.dart';

abstract class IFileService {
  TaskEither<Failure, File> save(String filename, Uint8List data);

  TaskEither<Failure, File> pick();

  static final provider = Provider<IFileService>((ref) => FileService());
}

class FileService with LoggableMixin implements IFileService {
  @override
  TaskEither<Failure, File> pick() => TaskEither(() async {
        try {
          final result =
              await FilePicker.platform.pickFiles(allowCompression: false);
          if (result == null) {
            return const Left(LoadImageFailure.userCancelled);
          }
          if (result.files.single.path == null) {
            throw "file path is null";
          } else {
            return Right(File(result.files.single.path!));
          }
        } catch (err, stacktrace) {
          logger.severe("Could not load file", err, stacktrace);
          return const Left(LoadImageFailure.unidentified);
        }
      });

  @override
  TaskEither<Failure, File> save(String filename, Uint8List data) =>
      TaskEither(() async {
        try {
          final saveDirectory = await FilePicker.platform.getDirectoryPath();
          if (saveDirectory == null) {
            return const Left(SaveImageFailure.userCancelled);
          }
          final file =
              await File("$saveDirectory/$filename").create(recursive: true);
          return Right(await file.writeAsBytes(data));
        } catch (err, stacktrace) {
          logger.severe("Could not save file", err, stacktrace);
          return const Left(SaveImageFailure.unidentified);
        }
      });
}
