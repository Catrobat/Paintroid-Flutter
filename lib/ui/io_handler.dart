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
  Future<bool> saveImage(BuildContext context) async {
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);
    final imageMetaData = await showSaveImageDialog(context, false);
    if (imageMetaData == null) {
      return false;
    }
    final isFileSaved = await workspaceStateNotifier
        .performIOTask(() => _saveImageWith(imageMetaData));
    workspaceStateNotifier.updateLastSavedCommandCount();
    return isFileSaved;
  }

  Future<File?> saveProject(ImageMetaData imageMetaData) async {
    if (imageMetaData is! CatrobatImageMetaData) return null;
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);
    final savedFile = await workspaceStateNotifier
        .performIOTask(() => _saveAsCatrobatImage(imageMetaData, true));
    if (savedFile != null) workspaceStateNotifier.updateLastSavedCommandCount();
    return savedFile;
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
  Future<bool> loadImage(
      BuildContext context, State state, bool unsavedChanges) async {
    if (unsavedChanges) {
      final shouldContinue = await handleUnsavedChanges(context, state);
      if (!shouldContinue) return false;
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
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);

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
        workspaceStateNotifier.updateLastSavedCommandCount();
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
    bool isImageSaved = false;
    if (imageData is JpgMetaData || imageData is PngMetaData) {
      isImageSaved = await _saveAsRasterImage(imageData);
    } else if (imageData is CatrobatImageMetaData) {
      final savedFile = await _saveAsCatrobatImage(imageData, false);
      isImageSaved = (savedFile != null);
    }
    return isImageSaved;
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
    return pngImage.when(
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
  }

  Future<File?> _saveAsCatrobatImage(
      CatrobatImageMetaData imageData, bool isAProject) async {
    final commands = ref.read(CommandManager.provider).history;
    final canvasState = ref.read(CanvasState.provider);
    final imgWidth = canvasState.size.width.toInt();
    final imgHeight = canvasState.size.height.toInt();
    final catrobatImage = CatrobatImage(
        commands, imgWidth, imgHeight, canvasState.backgroundImage);
    final saveAsCatrobatImage = ref.read(SaveAsCatrobatImage.provider);
    final result =
        await saveAsCatrobatImage(imageData, catrobatImage, isAProject);
    return result.when(
      ok: (file) {
        showToast("Saved successfully");
        return file;
      },
      err: (failure) {
        showToast(failure.message);
        return null;
      },
    );
  }
}
