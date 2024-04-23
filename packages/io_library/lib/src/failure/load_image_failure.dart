// Project imports:
import 'package:io_library/io_library.dart';

class LoadImageFailure extends Failure {
  const LoadImageFailure._(super.message);

  static const permissionDenied =
      LoadImageFailure._('Permission to view photos is denied in settings');
  static const userCancelled =
      LoadImageFailure._('User did not choose an image');
  static const invalidImage = LoadImageFailure._('Invalid image');
  static const unidentified = LoadImageFailure._('Could not load image');
}
