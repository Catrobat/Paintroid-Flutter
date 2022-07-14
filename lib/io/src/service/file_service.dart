import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paintroid/core/loggable_mixin.dart';

abstract class IFileService {
  TaskOption<Unit> saveToPhotoLibrary(String filename, Uint8List data);

  TaskOption<Uint8List> loadFromPhotoLibrary();

  static final provider = Provider<IFileService>(
    (ref) => FileService(ImagePicker()),
  );
}

class FileService with LoggableMixin implements IFileService {
  late final photoLibraryChannel =
      const MethodChannel("org.catrobat.paintroid/photo_library")
        ..setMethodCallHandler((call) async {
          switch (call.method) {
            case "saveToPhotosCallback":
              Map<String, dynamic> response = Map.from(call.arguments);
              if (response["success"] == true) {
                _savePhotoCompleter.complete(null);
              } else {
                _savePhotoCompleter.completeError(response["error"]);
              }
              break;
          }
        });

  final ImagePicker imagePicker;
  final _savePhotoCompleter = Completer<void>();

  FileService(this.imagePicker);

  @override
  TaskOption<Unit> saveToPhotoLibrary(String filename, Uint8List data) =>
      TaskOption(() async {
        try {
          final args = {"fileName": filename, "data": data};
          await photoLibraryChannel.invokeMethod("saveToPhotos", args);
          await _savePhotoCompleter.future;
          return Option.of(unit);
        } catch (err, stacktrace) {
          log.severe("Could not load photo from library", err, stacktrace);
          return const None();
        }
      });

  @override
  TaskOption<Uint8List> loadFromPhotoLibrary() => TaskOption(() async {
        try {
          final file = await imagePicker.pickImage(source: ImageSource.gallery);
          return Option.fromNullable(await file?.readAsBytes());
        } catch (err, stacktrace) {
          log.severe("Could not load photo from library", err, stacktrace);
          return const None();
        }
      });
}
