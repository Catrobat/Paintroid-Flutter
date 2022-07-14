import 'package:paintroid/core/failure.dart';

class LoadImageFailure extends Failure {
  const LoadImageFailure._(super.message);

  static const permissionDenied =
      LoadImageFailure._("Permission to view photos is denied in settings");
  static const unidentified = LoadImageFailure._("Could not load image");
}
