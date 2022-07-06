import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/domain/save_image.dart';
import 'package:paintroid/workspace/workspace.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final saveImage = ref.read(SaveImage.provider);
        final image = await ref.read(Workspace.provider).scaledCanvasImage;
        await saveImage.call(
          name: 'bruh',
          type: FileType.jpg,
          image: image,
        );
      },
      icon: const Icon(Icons.download),
    );
  }
}
