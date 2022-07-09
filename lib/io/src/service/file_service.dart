import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class IFileService {
  Future<void> saveToPhotos(String filename, Uint8List data);

  Future<File?> saveToDocuments(String filename, Uint8List data);

  static final provider = Provider<IFileService>((ref) => FileService());
}

class FileService implements IFileService {
  final photoLibraryChannel =
      const MethodChannel("org.catrobat.paintroid/photo_library")
        ..setMethodCallHandler((call) async {
          switch (call.method) {
            case "saveToPhotosCallback":
              debugPrint(call.arguments.toString());
              break;
          }
        });

  @override
  Future<void> saveToPhotos(String filename, Uint8List data) async {
    final args = {"fileName": filename, "data": data};
    try {
      await photoLibraryChannel.invokeMethod("saveToPhotos", args);
    } on PlatformException catch (e) {
      debugPrint(e.code);
    }
  }

  @override
  Future<File?> saveToDocuments(String filename, Uint8List data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(join(directory.path, filename));
    return await file.writeAsBytes(data);
  }
}
