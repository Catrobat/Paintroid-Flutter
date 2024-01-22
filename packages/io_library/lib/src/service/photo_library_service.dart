import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:io_library/io_library.dart';
import 'package:oxidized/oxidized.dart';

abstract class IPhotoLibraryService {
  Future<Result<Unit, Failure>> save(String filename, Uint8List data);

  Future<Result<Uint8List, Failure>> pick();

  static final provider = Provider<IPhotoLibraryService>(
    (ref) {
      const photoLibraryChannel =
          MethodChannel('org.catrobat.paintroid/photo_library');
      return PhotoLibraryService(ImagePicker(), photoLibraryChannel);
    },
  );
}

class PhotoLibraryService with LoggableMixin implements IPhotoLibraryService {
  PhotoLibraryService(this.imagePicker, this.photoLibraryChannel);

  final ImagePicker imagePicker;
  final MethodChannel photoLibraryChannel;

  @override
  Future<Result<Unit, Failure>> save(String name, Uint8List data) async {
    try {
      final args = {'fileName': name, 'data': data};
      await photoLibraryChannel.invokeMethod('saveToPhotos', args);
      return const Result.ok(unit);
    } catch (err, stacktrace) {
      logger.severe('Could not save photo to library', err, stacktrace);
      return const Result.err(SaveImageFailure.unidentified);
    }
  }

  @override
  Future<Result<Uint8List, Failure>> pick() async {
    try {
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      return file == null
          ? const Result.err(LoadImageFailure.userCancelled)
          : Result.ok(await file.readAsBytes());
    } catch (err, stacktrace) {
      logger.severe('Could not load photo from library', err, stacktrace);
      return const Result.err(LoadImageFailure.unidentified);
    }
  }
}
