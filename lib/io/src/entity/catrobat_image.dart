import 'dart:ui';

import 'package:paintroid/command/command.dart' show Command;

class CatrobatImage {
  static const magicValue = 'CATROBAT';
  static const latestVersion = 1;

  final int version;
  final int width;
  final int height;
  final Iterable<Command> commands;
  final Image? backgroundImage;

  const CatrobatImage(
    this.commands,
    this.width,
    this.height,
    this.backgroundImage, {
    this.version = latestVersion,
  });
}
