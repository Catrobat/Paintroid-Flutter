import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paintroid/domain/save_image.dart';
import 'package:paintroid/workspace/workspace.dart';

import 'save_image_dialog.dart';

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
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);
      ref.read(WorkspaceStateNotifier.provider.notifier).loadImage(image);
    }
  }

  void _saveImage() async {
    final saveImage = ref.read(SaveImage.provider);
    final image = await ref.read(Workspace.provider).scaledCanvasImage;
    final imageData = await showGeneralDialog<SaveImageData?>(
        context: context,
        pageBuilder: (_, __, ___) => const SaveImageDialog(),
        barrierDismissible: true,
        barrierLabel: "Dismiss save image dialog box");
    if (imageData != null) {
      await saveImage.call(
        name: imageData.name,
        type: imageData.format,
        quality: imageData.quality,
        image: image,
      );
    }
  }

  void _enterFullscreen() =>
      ref.read(WorkspaceStateNotifier.provider.notifier).toggleFullscreen(true);
}
