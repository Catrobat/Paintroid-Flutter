import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class IFileService {
  Future<File?> saveToPhotos(String filename, Uint8List data);

  Future<File?> saveToDocuments(String filename, Uint8List data);
}

class FileService implements IFileService {
  final platform = const MethodChannel("org.catrobat.paintroid/photo_gallery");

  const FileService();

  @override
  Future<File?> saveToPhotos(String filename, Uint8List data) async {
    if (Platform.isAndroid) {
      final dirs =
          await getExternalStorageDirectories(type: StorageDirectory.pictures);
      final directory = dirs?[0];
      if (directory == null) return null;
      final file = File(join(directory.path, filename));
      return await file.writeAsBytes(data);
    } else if (Platform.isIOS) {
      final args = {"fileName": filename, "data": data};
      await platform.invokeMethod("saveToPhotos", args);
    }
    return null;
  }

  @override
  Future<File?> saveToDocuments(String filename, Uint8List data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(join(directory.path, filename));
    return await file.writeAsBytes(data);
  }
}
