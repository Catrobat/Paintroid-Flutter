import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paintroid/data/model/project.dart';
import 'package:paintroid/io/src/service/image_service.dart';

class ImagePreview extends StatelessWidget {
  final Project? project;
  final double? width;
  final Color color;
  final IImageService imageService;

  const ImagePreview({
    Key? key,
    this.width,
    required this.color,
    this.project,
    required this.imageService,
  }) : super(key: key);

  ImageProvider _getProjectPreviewImageProvider(Uint8List img) =>
      Image.memory(img, fit: BoxFit.cover).image;

  Uint8List? _getProjectPreview(String? path) =>
      imageService.getProjectPreview(path).when(
            ok: (preview) => preview,
            err: (failure) {
              Fluttertoast.showToast(msg: failure.message);
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
