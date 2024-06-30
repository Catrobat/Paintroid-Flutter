import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/core/providers/object/image_service.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';

class ImagePreview extends StatelessWidget {
  final Project? project;
  final double? width;
  final Color color;
  final IImageService imageService;

  const ImagePreview({
    super.key,
    this.width,
    required this.color,
    this.project,
    required this.imageService,
  });

  ImageProvider _getProjectPreviewImageProvider(Uint8List img) =>
      Image.memory(img, fit: BoxFit.cover).image;

  Uint8List? _getProjectPreview(String? path) =>
      imageService.getProjectPreview(path).when(
            ok: (preview) => preview,
            err: (failure) {
              ToastUtils.showShortToast(message: failure.message);
              return null;
            },
          );

  @override
  Widget build(BuildContext context) {
    Uint8List? img;
    if (project != null) {
      img = _getProjectPreview(project!.imagePreviewPath);
    }
    var imgPreview = BoxDecoration(color: color);
    if (img != null) {
      imgPreview = BoxDecoration(
        color: color,
        image: DecorationImage(
          image: _getProjectPreviewImageProvider(img),
        ),
      );
    }
    if (width != null) {
      return Container(
        width: width!,
        decoration: imgPreview,
      );
    } else {
      return Container(
        decoration: imgPreview,
      );
    }
  }
}
