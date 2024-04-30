// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:io_library/io_library.dart';

abstract class IFileService {
  Future<Result<File, Failure>> save(String filename, Uint8List data);

  Future<Result<File, Failure>> saveToApplicationDirectory(
      String filename, Uint8List data);

  Future<Result<File, Failure>> pick();

  Result<File, Failure> getFile(String path);

  Future<int> getNextImageNumber();

  Future<int> getNextProjectNumber();

  static final provider = Provider<IFileService>((ref) => FileService());

  Future<bool> checkIfFileExistsInApplicationDirectory(String fileName);

  Future<Result<FileSystemEntity, Failure>> deleteFileInApplicationDirectory(
      String fileName);
}

class FileService with LoggableMixin implements IFileService {
  @override
  Future<Result<File, Failure>> pick() async {
    try {
      final result =
          await FilePicker.platform.pickFiles(allowCompression: false);
      if (result == null) {
        return const Result.err(LoadImageFailure.userCancelled);
      }
      if (result.files.single.path == null) {
        throw 'file path is null';
      } else {
        return Result.ok(File(result.files.single.path!));
      }
    } catch (err, stacktrace) {
      logger.severe('Could not load file', err, stacktrace);
      return const Result.err(LoadImageFailure.unidentified);
    }
  }

  @override
  Future<Result<File, Failure>> save(String filename, Uint8List data) async {
    try {
      final saveDirectory = await FilePicker.platform.getDirectoryPath();
      if (saveDirectory == null) {
        return const Result.err(SaveImageFailure.userCancelled);
      }
      final file =
          await File('$saveDirectory/$filename').create(recursive: true);
      return Result.ok(await file.writeAsBytes(data));
    } catch (err, stacktrace) {
      logger.severe('Could not save file', err, stacktrace);
      return const Result.err(SaveImageFailure.unidentified);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<bool> checkIfFileExistsInApplicationDirectory(String fileName) async {
    String saveDirectory = '${await _localPath}/$fileName';
    return File(saveDirectory).exists();
  }

  @override
  Future<Result<FileSystemEntity, Failure>> deleteFileInApplicationDirectory(
      String fileName) async {
    try {
      String saveDirectory = '${await _localPath}/$fileName';
      return Result.ok(await File(saveDirectory).delete());
    } catch (err, stacktrace) {
      logger.severe('Could not delete file', err, stacktrace);
      return const Result.err(SaveImageFailure.deletionFailed);
    }
  }

  @override
  Future<Result<File, Failure>> saveToApplicationDirectory(
      String filename, Uint8List data) async {
    try {
      String saveDirectory = '${await _localPath}/$filename';
      final file = await File(saveDirectory).create(recursive: true);
      return Result.ok(await file.writeAsBytes(data));
    } catch (err, stacktrace) {
      logger.severe('Could not save file', err, stacktrace);
      return const Result.err(SaveImageFailure.unidentified);
    }
  }

  @override
  Result<File, Failure> getFile(String path) {
    try {
      return Result.ok(File(path));
    } catch (err, stacktrace) {
      logger.severe('Could not load file', err, stacktrace);
      return const Result.err(LoadImageFailure.unidentified);
    }
  }

  @override
  Future<int> getNextImageNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int lastNumber = prefs.getInt('lastImageNumber') ?? 0;
    int nextNumber = lastNumber + 1;
    await prefs.setInt('lastImageNumber', nextNumber);
    return nextNumber;
  }

  @override
  Future<int> getNextProjectNumber() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = await directory.list().toList();
    int maxNum = 0;

    for (var file in files) {
      if (file is File) {
        final fileName = file.path.split('/').last;

        if (fileName.startsWith('project')) {
          final match = RegExp(r'project(\d+)').firstMatch(fileName);
          if (match != null) {
            final numString = match.group(1);
            if (numString != null) {
              final num = int.tryParse(numString) ?? 0;

              if (num > maxNum) {
                maxNum = num;
              }
            }
          }
        }
      }
    }

    return maxNum + 1;
  }
}
