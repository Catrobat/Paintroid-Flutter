import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/io/io.dart';
import 'package:paintroid/ui/io_handler.dart';
import 'package:paintroid/workspace/workspace.dart';

enum OverflowMenuOption {
  fullscreen("Fullscreen"),
  saveImage("Save Image"),
  loadImage("Load Image"),
  newImage("New Image");

  const OverflowMenuOption(this.label);

  final String label;
}

class OverflowMenu extends ConsumerStatefulWidget {
  const OverflowMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<OverflowMenu> createState() => _OverflowMenuState();
}

class _OverflowMenuState extends ConsumerState<OverflowMenu> {
  late final ioHandler = ref.read(IOHandler.provider);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OverflowMenuOption>(
      color: Theme.of(context).colorScheme.background,
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: _handleSelectedOption,
      itemBuilder: (BuildContext context) {
        return OverflowMenuOption.values.map((option) {
          return PopupMenuItem(value: option, child: Text(option.label));
        }).toList();
      },
    );
  }

  void _handleSelectedOption(OverflowMenuOption option) {
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
      case OverflowMenuOption.newImage:
        _newImage();
        break;
    }
  }

  void _enterFullscreen() =>
      ref.read(WorkspaceState.provider.notifier).toggleFullscreen(true);

  Future<void> _saveImage() async {
    final imageData = await showSaveImageDialog(context);
    if (imageData == null) return;
    await ioHandler.saveImage(imageData);
    ref.read(WorkspaceState.provider.notifier).updateLastSavedCommandCount();
  }

  /// Returns [true] if user didn't tap outside of any dialogs
  /// or if there is no unsaved work
  Future<bool> _handleUnsavedChanges() async {
    final workspaceStateNotifier = ref.read(WorkspaceState.provider.notifier);
    if (!workspaceStateNotifier.hasSavedLastWork) {
      final shouldDiscard = await showDiscardChangesDialog(context);
      if (shouldDiscard == null || !mounted) return false;
      if (!shouldDiscard) {
        final imageData = await showSaveImageDialog(context);
        if (imageData == null) return false;
        await ioHandler.saveImage(imageData);
        workspaceStateNotifier.updateLastSavedCommandCount();
      }
    }
    return true;
  }

  Future<void> _loadImage() async {
    final shouldContinue = await _handleUnsavedChanges();
    if (!shouldContinue) return;
    if (Platform.isIOS) {
      if (!mounted) return;
      final location = await showLoadImageDialog(context);
      if (location == null) return;
      await ioHandler.loadImage(location);
    } else {
      await ioHandler.loadImage(ImageLocation.files);
    }
  }

  Future<void> _newImage() async {
    final shouldContinue = await _handleUnsavedChanges();
    if (!shouldContinue) return;
    ref.read(CanvasState.provider.notifier).clearCanvasAndCommandHistory();
    ref.read(WorkspaceState.provider.notifier).resetWorkspace();
  }
}
