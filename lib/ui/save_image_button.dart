import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/domain/save_image.dart';
import 'package:paintroid/ui/save_image_dialog.dart';
import 'package:paintroid/workspace/workspace.dart';

class SaveImageButton extends ConsumerWidget {
  const SaveImageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final saveImage = ref.read(SaveImage.provider);
        final image = await ref.read(Workspace.provider).scaledCanvasImage;
        final imageData = await showGeneralDialog<SaveImageData?>(
          context: context,
          pageBuilder: (_, __, ___) => const SaveImageDialog(),
          barrierDismissible: true,
          barrierLabel: "Dismiss save image dialog box"
        );
        if (imageData != null) {
          await saveImage.call(
            name: imageData.name,
            type: imageData.format,
            quality: imageData.quality,
            image: image,
          );
        }
      },
      icon: const Icon(Icons.download),
    );
  }
}
