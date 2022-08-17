import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/command/command.dart' show CommandManager;
import 'package:paintroid/io/io.dart';
import 'package:paintroid/workspace/workspace.dart';

import '../core/failure.dart';

class IOHandler {
  final Ref ref;

  const IOHandler(this.ref);

  static final provider = Provider((ref) => IOHandler(ref));

  /// Returns [true] if the image was saved successfully
  Future<File?> saveImage(
      BuildContext context, ImageMetaData? imageMetaData) async {
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);
    if (imageMetaData == null) {
      imageMetaData = await showSaveImageDialog(context, false);
      if (imageMetaData == null) return null;
    }
    final savedFile = await workspaceStateNotifier
        .performIOTask(() => _saveImageWith(imageMetaData!));
    // todo: fix this condition
    workspaceStateNotifier.updateLastSavedCommandCount();
    return savedFile;
  }

  /// Returns [true] if -
  /// - There was no unsaved work, or
  /// - The unsaved work was saved successfully
  Future<File?> handleUnsavedChanges(BuildContext context, State state) async {
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);
    if (!workspaceStateNotifier.hasSavedLastWork) {
      final shouldDiscard = await showDiscardChangesDialog(context);
      if (shouldDiscard == null || !state.mounted) return null;
      if (!shouldDiscard) {
        final didSave = await saveImage(context, null);
        return didSave;
      }
    }
    return null;
  }

  /// Returns [true] if the image was loaded successfully
  Future<bool> loadImage(
      BuildContext context, State state, bool unsavedChanges) async {
    if (unsavedChanges) {
      final shouldContinue = await handleUnsavedChanges(context, state);
      if (shouldContinue != null) return false;
    }
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
    if (shouldContinue == null) return false;
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
        return loadFromFiles(null);
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

  Future<bool> loadFromFiles(Result<File, Failure>? file) async {
    final loadImage = ref.read(LoadImageFromFileManager.provider);
    final result = await loadImage(file);
    return result.when(
      ok: (imageFromFile) async {
        final canvasStateNotifier = ref.read(CanvasState.provider.notifier);
        imageFromFile.rasterImage == null
            ? canvasStateNotifier.clearBackgroundImageAndResetDimensions()
            : canvasStateNotifier
                .setBackgroundImage(imageFromFile.rasterImage!);
        if (imageFromFile.catrobatImage != null) {
          final commands = imageFromFile.catrobatImage!.commands;
          canvasStateNotifier.resetCanvasWithNewCommands(commands);
        } else {
          canvasStateNotifier.resetCanvasWithNewCommands([]);
        }
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

  Future<File?> _saveImageWith(ImageMetaData imageData) async {
    File? savedFile;
    if (imageData is JpgMetaData || imageData is PngMetaData) {
      await _saveAsRasterImage(imageData);
    } else if (imageData is CatrobatImageMetaData) {
      savedFile = await _saveAsCatrobatImage(imageData);
    }
    return savedFile;
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

  Future<String?> getPreviewPath(ImageMetaData imageData) async {
    final image = await ref
        .read(RenderImageForExport.provider)
        .call(keepTransparency: imageData.format != ImageFormat.jpg);
    final fileService = ref.watch(IFileService.provider);
    final pngImage = await ref.read(IImageService.provider).exportAsPng(image);
    final img = pngImage.when(
      ok: (img) async {
        final previewFile =
            await fileService.saveToApplicationDirectory(imageData.name, img);
        return previewFile.when(
          ok: (file) => file.path,
          err: (failure) {
            showToast(failure.message);
            return null;
          },
        );
      },
      err: (failure) {
        showToast(failure.message);
        return null;
      },
    );
    return img;
  }

  Future<File?> _saveAsCatrobatImage(CatrobatImageMetaData imageData) async {
    final commands = ref.read(CommandManager.provider).history;
    final canvasState = ref.read(CanvasState.provider);
    final imgWidth = canvasState.size.width.toInt();
    final imgHeight = canvasState.size.height.toInt();
    final catrobatImage = CatrobatImage(
        commands, imgWidth, imgHeight, canvasState.backgroundImage);
    final saveAsCatrobatImage = ref.read(SaveAsCatrobatImage.provider);
    final result = await saveAsCatrobatImage(imageData, catrobatImage);
    File? savedFile;
    result.when(
      ok: (file) {
        showToast("Saved successfully");
        savedFile = file;
      },
      err: (failure) => showToast(failure.message),
    );
    return savedFile;
  }
}
