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

  Future<void> pickImage(
    LoadImageFromPhotoLibrary loadImageFromPhotoLibrary,
    ui.Size canvasSize,
  ) async {
    final result = await loadImageFromPhotoLibrary.call();
    result.match(
      (image) {
        setImage(image, canvasSize);
      },
      (failure) {
        // If failed or cancelled, we don't change anything
      },
    );
  }

  void setImage(ui.Image image, ui.Size canvasSize) {
    importedImage = image;

    boundingBox.center = canvasSize.center(ui.Offset.zero);

    double initialWidth = image.width.toDouble();
    double initialHeight = image.height.toDouble();

    const double minInteractionSize = 100.0;
    if (initialWidth < minInteractionSize || initialHeight < minInteractionSize) {
      final double scale =
          dart_math.max(minInteractionSize / initialWidth, minInteractionSize / initialHeight);
      initialWidth *= scale;
      initialHeight *= scale;
    }

    final double maxW = canvasSize.width * 0.8;
    final double maxH = canvasSize.height * 0.8;
    if (initialWidth > maxW || initialHeight > maxH) {
      final double scale = dart_math.min(maxW / initialWidth, maxH / initialHeight);
      initialWidth *= scale;
      initialHeight *= scale;
    }

    boundingBox.width = initialWidth;
    boundingBox.height = initialHeight;
    boundingBox.angle = 0.0;
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
    final image = importedImage;
    if (image == null) return;

    boundingBox.drawGuides(canvas);

    final src = ui.Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = ui.Rect.fromLTWH(
      -boundingBox.width / 2,
      -boundingBox.height / 2,
      boundingBox.width,
      boundingBox.height,
    );

    canvas.save();
    canvas.translate(boundingBox.center.dx, boundingBox.center.dy);
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

    final pasteOffset = boundingBox.center;
    final pasteRotation = boundingBox.angle;
    final double pasteScale = boundingBox.width / image.width.toDouble();

    final command = commandFactory.createImportCommand(
      paint,
      bytes,
      pasteOffset,
      pasteScale,
      pasteRotation,
    );
    await command.prepareForRuntime();
    commandManager.addGraphicCommand(command);
  }

  @override
  void onPlus() {}

  @override
  void onUndo() => commandManager.undo();

  @override
  void onRedo() => commandManager.redo();
}
