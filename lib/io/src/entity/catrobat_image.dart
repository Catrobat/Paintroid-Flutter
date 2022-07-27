import 'dart:typed_data';

import 'package:paintroid/command/command.dart' show Command;

class CatrobatImage {
  static const magicValue = "CATROBAT";
  static const latestVersion = 1;

  final int version;
  final Iterable<Command> commands;
  final Uint8List? backgroundImageData;

  const CatrobatImage(
    this.commands,
    this.backgroundImageData, {
    this.version = latestVersion,
  });
}
