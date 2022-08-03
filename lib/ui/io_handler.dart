import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/command/command.dart' show CommandManager;
import 'package:paintroid/io/io.dart';
import 'package:paintroid/workspace/workspace.dart';

class IOHandler {
  final Ref ref;

  const IOHandler(this.ref);

  static final provider = Provider((ref) => IOHandler(ref));

  /// Returns [true] if the image was saved successfully
  Future<bool> saveImage(BuildContext context) async {
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);
    final imageData = await showSaveImageDialog(context);
    if (imageData == null) return false;
    final didSave = await workspaceStateNotifier
        .performIOTask(() => _saveImageWith(imageData));
    if (!didSave) return false;
    workspaceStateNotifier.updateLastSavedCommandCount();
    return true;
  }

  /// Returns [true] if -
  /// - There was no unsaved work, or
  /// - The unsaved work was saved successfully
  Future<bool> handleUnsavedChanges(BuildContext context, State state) async {
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);
    if (!workspaceStateNotifier.hasSavedLastWork) {
      final shouldDiscard = await showDiscardChangesDialog(context);
      if (shouldDiscard == null || !state.mounted) return false;
      if (!shouldDiscard) {
        final didSave = await saveImage(context);
        if (!didSave) return false;
      }
    }
    return true;
  }

  /// Returns [true] if the image was loaded successfully
  Future<bool> loadImage(BuildContext context, State state) async {
    final shouldContinue = await handleUnsavedChanges(context, state);
    if (!shouldContinue) return false;
    if (Platform.isIOS) {
      if (!state.mounted) return false;
      final location = await showLoadImageDialog(context);
      if (location == null) return false;
      return ref
          .read(WorkspaceState.provider.notifier)
          .performIOTask(() => _loadImageFrom(location));
    } else {
      return ref
          .read(WorkspaceState.provider.notifier)
          .performIOTask(() => _loadImageFrom(ImageLocation.files));
    }
  }

  /// Returns [true] if a new image canvas was created successfully
  Future<bool> newImage(BuildContext context, State state) async {
    final shouldContinue = await handleUnsavedChanges(context, state);
    if (!shouldContinue) return false;
    ref.read(CanvasState.provider.notifier)
      ..clearBackgroundImageAndResetDimensions()
      ..resetCanvasWithNewCommands([]);
    ref.read(WorkspaceState.provider.notifier).updateLastSavedCommandCount();
    return true;
  }

  Future<bool> _loadImageFrom(ImageLocation location) async {
    switch (location) {
      case ImageLocation.photos:
        return _loadFromPhotos();
      case ImageLocation.files:
        return _loadFromFiles();
    }
  }

  Future<bool> _loadFromPhotos() async {
    final loadImage = ref.read(LoadImageFromPhotoLibrary.provider);
    final result = await loadImage();
    return result.when(
      ok: (img) async {
        ref.read(CanvasState.provider.notifier)
          ..setBackgroundImage(img)
          ..resetCanvasWithNewCommands([]);
        return true;
      },
      err: (failure) async {
        if (failure != LoadImageFailure.userCancelled) {
          showToast(failure.message);
        }
        return false;
      },
    );
  }

  Future<bool> _loadFromFiles() async {
    final loadImage = ref.read(LoadImageFromFileManager.provider);
    final result = await loadImage();
    return result.when(
      ok: (imageFromFile) async {
        final canvasStateNotifier = ref.read(CanvasState.provider.notifier);
        if (imageFromFile.catrobatImage != null) {
          final commands = imageFromFile.catrobatImage!.commands;
          canvasStateNotifier.resetCanvasWithNewCommands(commands);
        } else {
          canvasStateNotifier.resetCanvasWithNewCommands([]);
        }
        imageFromFile.rasterImage == null
            ? canvasStateNotifier.clearBackgroundImageAndResetDimensions()
            : canvasStateNotifier
                .setBackgroundImage(imageFromFile.rasterImage!);
        return true;
      },
      err: (failure) {
        if (failure != LoadImageFailure.userCancelled) {
          showToast(failure.message);
        }
        return false;
      },
    );
  }

  Future<bool> _saveImageWith(ImageMetaData imageData) async {
    if (imageData is JpgMetaData || imageData is PngMetaData) {
      return _saveAsRasterImage(imageData);
    } else if (imageData is CatrobatImageMetaData) {
      return _saveAsCatrobatImage(imageData);
    }
    return false;
  }

  Future<bool> _saveAsRasterImage(ImageMetaData imageData) async {
    final image = await ref
        .read(RenderImageForExport.provider)
        .call(keepTransparency: imageData.format != ImageFormat.jpg);
    return ref.read(SaveAsRasterImage.provider).call(imageData, image).when(
      ok: (_) {
        showToast("Saved to Photos");
        return true;
      },
      err: (failure) {
        showToast(failure.message);
        return false;
      },
    );
  }

  Future<bool> _saveAsCatrobatImage(CatrobatImageMetaData imageData) async {
    final commands = ref.read(CommandManager.provider).history;
    final canvasState = ref.read(CanvasState.provider);
    final imgWidth = canvasState.size.width.toInt();
    final imgHeight = canvasState.size.height.toInt();
    final catrobatImage = CatrobatImage(
        commands, imgWidth, imgHeight, canvasState.backgroundImage);
    final saveAsCatrobatImage = ref.read(SaveAsCatrobatImage.provider);
    final result = await saveAsCatrobatImage(imageData, catrobatImage);
    return result.when(
      ok: (file) {
        showToast("Saved successfully");
        return true;
      },
      err: (failure) {
        showToast(failure.message);
        return false;
      },
    );
  }
}
