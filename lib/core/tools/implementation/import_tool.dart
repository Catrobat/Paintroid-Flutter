import 'dart:math' as dart_math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/providers/object/load_image_from_photo_library.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

class ImportTool extends Tool {
  final BoundingBox boundingBox;
  ui.Image? importedImage;
  bool _isInteracting = false;

  ImportTool({
    required super.commandManager,
    required super.commandFactory,
    required this.boundingBox,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  });

  Future<void> pickImage(LoadImageFromPhotoLibrary loadImageFromPhotoLibrary) async {
    final result = await loadImageFromPhotoLibrary.call();
    result.match(
      (image) {
        importedImage = image;
        // Keep the provider-created box centered on the canvas and reset its
        // transform for each newly selected image.
        boundingBox.width = image.width.toDouble();
        boundingBox.height = image.height.toDouble();
        boundingBox.angle = 0.0;
      },
      (failure) {
        // If failed or cancelled, we don't change anything
      },
    );
  }

  @override
  void onDown(ui.Offset point, Paint paint) {
    boundingBox.determineAction(point);
    _isInteracting = boundingBox.currentAction != BoundingBoxAction.none;
  }

  @override
  void onDrag(ui.Offset point, Paint paint) {
    if (_isInteracting) boundingBox.updateDrag(point);
  }

  @override
  void onUp(ui.Offset point, Paint paint) {
    if (_isInteracting) {
      boundingBox.endDrag();
      _isInteracting = false;
    }
  }

  @override
  void onCancel() {
    if (_isInteracting) {
      boundingBox.endDrag();
      _isInteracting = false;
    }
  }

  void paint(Canvas canvas, Size size) {
    boundingBox.drawGuides(canvas);
    final image = importedImage;
    if (image == null) return;
    if (image.width == 0 || image.height == 0) return;

    final rect = boundingBox.rect;
    if (rect.width <= 0 || rect.height <= 0) return;

    double previewScale = 1.0;
    if (image.width > 0 &&
        image.height > 0 &&
        rect.width > 0 &&
        rect.height > 0) {
      final double widthScale = rect.width / image.width.toDouble();
      final double heightScale = rect.height / image.height.toDouble();
      previewScale = dart_math.min(widthScale, heightScale);
    }

    final double scaledWidth = image.width.toDouble() * previewScale;
    final double scaledHeight = image.height.toDouble() * previewScale;

    final src = ui.Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = ui.Rect.fromLTWH(
      -scaledWidth / 2,
      -scaledHeight / 2,
      scaledWidth,
      scaledHeight,
    );

    canvas.save();
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.rotate(boundingBox.angle);
    final paintImage = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImageRect(image, src, dst, paintImage);
    canvas.restore();
  }

  @override
  Future<void> onCheckmark(Paint paint) async {
    final image = importedImage;
    if (image == null) return;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    final bytes = byteData.buffer.asUint8List();

    final pasteOffset = boundingBox.rect.center;
    final pasteRotation = boundingBox.angle;

    double pasteScale = 1.0;
    if (image.width > 0 &&
        image.height > 0 &&
        boundingBox.rect.width > 0 &&
        boundingBox.rect.height > 0) {
      final double widthScale = boundingBox.rect.width / image.width.toDouble();
      final double heightScale =
          boundingBox.rect.height / image.height.toDouble();
      pasteScale = dart_math.min(widthScale, heightScale);
    } else if (image.width > 0 && boundingBox.rect.width > 0) {
      pasteScale = boundingBox.rect.width / image.width.toDouble();
    }

    final command = commandFactory.createClipboardCommand(
      paint,
      bytes,
      pasteOffset,
      pasteScale,
      pasteRotation,
    );
    await command.prepareForRuntime();
    commandManager.addGraphicCommand(command);
    importedImage = null;
  }

  @override
  void onPlus() {}

  @override
  void onUndo() => commandManager.undo();

  @override
  void onRedo() => commandManager.redo();
}
