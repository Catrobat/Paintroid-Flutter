import 'dart:typed_data';

import 'package:floor/floor.dart';

@entity
class Project {
  String name;
  String path;
  DateTime lastModified;
  DateTime creationDate;
  String? resolution;
  String? format;
  int? size;
  String? imagePreviewPath;
  @PrimaryKey(autoGenerate: true)
  final int? id;

  Project({
    required this.name,
    required this.path,
    required this.lastModified,
    required this.creationDate,
    this.resolution,
    this.format,
    this.size,
    this.imagePreviewPath,
    this.id,
  });
}
