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

  Future<void> loadImage(ImageLocation location) async {
    switch (location) {
      case ImageLocation.photos:
        await _loadFromPhotos();
        break;
      case ImageLocation.files:
        await _loadFromFiles();
        break;
    }
  }

  Future<void> _loadFromPhotos() async {
    final loadImage = ref.read(LoadImageFromPhotoLibrary.provider);
    final result = await loadImage();
    result.when(
      ok: (img) async {
        ref.read(CanvasState.provider.notifier).clearCanvasAndCommandHistory();
        ref.read(WorkspaceState.provider.notifier).setBackgroundImage(img);
      },
      err: (failure) {
        if (failure != LoadImageFailure.userCancelled) {
          showToast(failure.message);
        }
      },
    );
  }

  Future<void> _loadFromFiles() async {
    final loadImage = ref.read(LoadImageFromFileManager.provider);
    final result = await loadImage();
    result.when(
      ok: (imageFromFile) async {
        ref.read(CanvasState.provider.notifier).clearCanvasAndCommandHistory();
        if (imageFromFile.catrobatImage != null) {
          final commands = imageFromFile.catrobatImage!.commands;
          ref.read(CommandManager.provider).clearHistory(newCommands: commands);
          ref.read(CanvasState.provider.notifier).reCacheImageForAllCommands();
        }
        final workspaceNotifier = ref.read(WorkspaceState.provider.notifier);
        imageFromFile.rasterImage == null
            ? workspaceNotifier.clearBackgroundImageAndResetDimensions()
            : workspaceNotifier.setBackgroundImage(imageFromFile.rasterImage!);
      },
      err: (failure) {
        if (failure != LoadImageFailure.userCancelled) {
          showToast(failure.message);
        }
      },
    );
  }

  Future<void> saveImage(ImageMetaData imageData) async {
    if (imageData is JpgMetaData || imageData is PngMetaData) {
      await _saveAsRasterImage(imageData);
    } else if (imageData is CatrobatImageMetaData) {
      await _saveAsCatrobatImage(imageData);
    }
  }

  Future<void> _saveAsRasterImage(ImageMetaData imageData) async {
    final image = await ref
        .read(RenderImageForExport.provider)
        .call(keepTransparency: imageData.format != ImageFormat.jpg);
    await ref.read(SaveAsRasterImage.provider).call(imageData, image).when(
          ok: (_) => showToast("Saved to Photos"),
          err: (failure) => showToast(failure.message),
        );
  }

  Future<void> _saveAsCatrobatImage(CatrobatImageMetaData imageData) async {
    final commands = ref.read(CommandManager.provider).history;
    final workspaceState = ref.read(WorkspaceState.provider);
    final imgWidth = workspaceState.exportSize.width.toInt();
    final imgHeight = workspaceState.exportSize.height.toInt();
    final catrobatImage = CatrobatImage(
        commands, imgWidth, imgHeight, workspaceState.backgroundImage);
    final saveAsCatrobatImage = ref.read(SaveAsCatrobatImage.provider);
    final result = await saveAsCatrobatImage(imageData, catrobatImage);
    result.when(
      ok: (file) => showToast("Saved successfully"),
      err: (failure) => showToast(failure.message),
    );
  }
}