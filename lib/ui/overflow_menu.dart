import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:paintroid/io/io.dart';
import 'package:paintroid/workspace/workspace.dart';

enum OverflowMenuOption {
  fullscreen("Fullscreen"),
  saveImage("Save Image"),
  loadImage("Load Image");

  const OverflowMenuOption(this.label);

  final String label;
}

class OverflowMenu extends ConsumerStatefulWidget {
  const OverflowMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<OverflowMenu> createState() => _OverflowMenuState();
}

class _OverflowMenuState extends ConsumerState<OverflowMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OverflowMenuOption>(
      color: Theme.of(context).colorScheme.background,
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: (option) {
        switch (option) {
          case OverflowMenuOption.fullscreen:
            _enterFullscreen();
            break;
          case OverflowMenuOption.saveImage:
            _saveImage();
            break;
          case OverflowMenuOption.loadImage:
            _loadImage();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return OverflowMenuOption.values.map((option) {
          return PopupMenuItem(value: option, child: Text(option.label));
        }).toList();
      },
    );
  }

  void _loadImage() async {
    final loadImage = ref.read(LoadImage.provider);
    final image = await loadImage.prepareTask().run();
    image.fold(
      (failure) {
        if (failure != LoadImageFailure.userCancelled) {
          showToast(failure.message);
        }
      },
      (img) async {
        ref.read(WorkspaceState.provider.notifier).loadImage(img);
        final size = await ref.read(DrawCanvas.sizeProvider.future);
        ref.read(CanvasState.provider.notifier).updateCanvasSize(size);
      },
    );
  }

  void _saveImage() async {
    final imageData = await showSaveImageDialog(context);
    if (imageData == null) return;
    final saveImage = ref.read(SaveImage.provider);
    final scaleImage = ref.read(ScaleImage.provider);
    final canvasSize = await ref.read(DrawCanvas.sizeProvider.future);
    final workspaceState = ref.read(WorkspaceState.provider);
    final exportSize = workspaceState.exportSize;
    final loadedImage = workspaceState.loadedImage;
    final scaledImage =
        await scaleImage.call(canvasSize, exportSize, loadedImage);
    final either = await saveImage
        .prepareTask(metaData: imageData, image: scaledImage)
        .run();
    either.fold(
      (failure) => showToast(failure.message),
      (_) => showToast("Saved to Photos"),
    );
  }

  void _enterFullscreen() =>
      ref.read(WorkspaceState.provider.notifier).toggleFullscreen(true);
}
