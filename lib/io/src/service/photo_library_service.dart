import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/core/loggable_mixin.dart';

import '../failure/load_image_failure.dart';
import '../failure/save_image_failure.dart';

abstract class IPhotoLibraryService {
  TaskEither<Failure, Unit> save(String filename, Uint8List data);

  TaskEither<Failure, Uint8List> pick();

  static final provider = Provider<IPhotoLibraryService>(
    (ref) {
      const photoLibraryChannel =
          MethodChannel("org.catrobat.paintroid/photo_library");
      return PhotoLibraryService(ImagePicker(), photoLibraryChannel);
    },
  );
}

class PhotoLibraryService with LoggableMixin implements IPhotoLibraryService {
  PhotoLibraryService(this.imagePicker, this.photoLibraryChannel);

  final ImagePicker imagePicker;
  final MethodChannel photoLibraryChannel;

  @override
  TaskEither<Failure, Unit> save(String name, Uint8List data) =>
      TaskEither(() async {
        try {
          final args = {"fileName": name, "data": data};
          await photoLibraryChannel.invokeMethod("saveToPhotos", args);
          return const Right(unit);
        } on PlatformException catch (err, stacktrace) {
          if (err.code == "PERMISSION_DENIED") {
            log.warning("User explicitly denied permission to save images", err,
                stacktrace);
            return const Left(SaveImageFailure.permissionDenied);
          } else {
            log.severe("Could not save photo to library", err, stacktrace);
            return const Left(SaveImageFailure.unidentified);
          }
        } catch (err, stacktrace) {
          log.severe("Could not save photo to library", err, stacktrace);
          return const Left(SaveImageFailure.unidentified);
        }
      });

  @override
  TaskEither<Failure, Uint8List> pick() => TaskEither(() async {
        try {
          final file = await imagePicker.pickImage(source: ImageSource.gallery);
          return file == null
              ? const Left(LoadImageFailure.userCancelled)
              : Right(await file.readAsBytes());
        } on PlatformException catch (err, stacktrace) {
          // This error code is from ImagePicker
          if (err.code == "photo_access_denied") {
            log.warning("User explicitly denied permission to load images", err,
                stacktrace);
            return const Left(LoadImageFailure.permissionDenied);
          } else {
            log.severe("Could not load photo from library", err, stacktrace);
            return const Left(LoadImageFailure.unidentified);
          }
        } catch (err, stacktrace) {
          log.severe("Could not load photo from library", err, stacktrace);
          return const Left(LoadImageFailure.unidentified);
        }
      });
}
