import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/object/io_handler.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/shared/pop_menu_button.dart';
import 'package:paintroid/ui/theme/theme.dart';

enum OverflowMenuOption {
  fullscreen,
  saveImage,
  saveProject,
  loadImage,
  newImage;

  String localizedLabel(AppLocalizations localizations) {
    switch (this) {
      case OverflowMenuOption.fullscreen:
        return localizations.menuHideMenu;
      case OverflowMenuOption.saveImage:
        return localizations.menuSaveImage;
      case OverflowMenuOption.loadImage:
        return localizations.menuLoadImage;
      case OverflowMenuOption.newImage:
        return localizations.menuNewImage;
      case OverflowMenuOption.saveProject:
        return localizations.menuSaveProject;
    }
  }
}

class OverflowMenu extends ConsumerStatefulWidget {
  const OverflowMenu({super.key});

  @override
  ConsumerState<OverflowMenu> createState() => _OverflowMenuState();
}

class _OverflowMenuState extends ConsumerState<OverflowMenu> {
  IOHandler get ioHandler => ref.read(IOHandler.provider);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return StyledPopMenuButton<OverflowMenuOption>(
      onSelected: _handleSelectedOption,
      itemBuilder: (BuildContext context) => OverflowMenuOption.values
          .map((option) => PopupMenuItem(
              value: option,
              child: Text(
                option.localizedLabel(localizations),
                style: PaintroidTheme.of(context).textTheme.bodyMedium,
              )))
          .toList(),
    );
  }

  void _handleSelectedOption(OverflowMenuOption option) {
    final ioHandler = ref.watch(IOHandler.provider);
    switch (option) {
      case OverflowMenuOption.fullscreen:
        _enterFullscreen();
        break;
      case OverflowMenuOption.saveImage:
        ioHandler.saveImage(context);
        break;
      case OverflowMenuOption.saveProject:
        ioHandler.saveProject(context);
        break;
      case OverflowMenuOption.loadImage:
        ioHandler.loadImage(context, this);
        break;
      case OverflowMenuOption.newImage:
        ioHandler.newImage(context, this);
        break;
    }
  }

  void _enterFullscreen() =>
      ref.read(workspaceStateProvider.notifier).toggleFullscreen(true);

}
