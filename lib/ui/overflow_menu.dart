import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/io/io.dart';
import 'package:paintroid/io/src/entity/image_location.dart';
import 'package:paintroid/ui/io_handler.dart';
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
    final ioHandler = ref.watch(IOHandler.provider);
    return PopupMenuButton<OverflowMenuOption>(
      color: Theme.of(context).colorScheme.background,
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: (option) async {
        switch (option) {
          case OverflowMenuOption.fullscreen:
            _enterFullscreen();
            break;
          case OverflowMenuOption.saveImage:
            final imageData = await showSaveImageDialog(context);
            if (imageData == null) return; // User cancelled
            ioHandler.saveImage(imageData);
            break;
          case OverflowMenuOption.loadImage:
            if (Platform.isIOS) {
              final location = await showLoadImageDialog(context);
              if (location == null) return;
              ioHandler.loadImage(location);
            } else {
              ioHandler.loadImage(ImageLocation.files);
            }
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

  void _enterFullscreen() =>
      ref.read(WorkspaceState.provider.notifier).toggleFullscreen(true);
}
