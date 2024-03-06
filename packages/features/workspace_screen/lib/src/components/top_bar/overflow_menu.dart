import 'package:component_library/component_library.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';
import 'package:l10n/l10n.dart';
import 'package:oxidized/oxidized.dart';
import 'package:toast/toast.dart';
import 'package:workspace_screen/workspace_screen.dart';
import 'package:share/share.dart';

enum OverflowMenuOption {
  fullscreen,
  saveImage,
  saveProject,
  loadImage,
  newImage,
  share;

  String localizedLabel(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    switch (this) {
      case OverflowMenuOption.fullscreen:
        return localizations.fullscreen;
      case OverflowMenuOption.saveImage:
        return localizations.saveImage;
      case OverflowMenuOption.loadImage:
        return localizations.loadImage;
      case OverflowMenuOption.newImage:
        return localizations.newImage;
      case OverflowMenuOption.saveProject:
        return localizations.saveProject;
      case OverflowMenuOption.share:
        return localizations.share;
    }
  }
}

class OverflowMenu extends ConsumerStatefulWidget {
  const OverflowMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<OverflowMenu> createState() => _OverflowMenuState();
}

class _OverflowMenuState extends ConsumerState<OverflowMenu> {
  IOHandler get ioHandler => ref.read(IOHandler.provider);

  @override
  Widget build(BuildContext context) {
    return StyledPopMenuButton<OverflowMenuOption>(
      onSelected: _handleSelectedOption,
      itemBuilder: (BuildContext context) => OverflowMenuOption.values
          .map((option) => PopupMenuItem(
          value: option,
          child: Text(
            option.localizedLabel(context),
            style: TextThemes.menuItem,
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
        _saveProject();
        break;
      case OverflowMenuOption.loadImage:
        ioHandler.loadImage(context, this, true);
        break;
      case OverflowMenuOption.newImage:
        ioHandler.newImage(context, this);
        break;
      case OverflowMenuOption.share:
        _shareContent();
        break;
    }
  }

  void _enterFullscreen() =>
      ref.read(WorkspaceState.provider.notifier).toggleFullscreen(true);

  Future<bool> _showOverwriteDialog() async {
    return await showOverwriteDialog(context) ?? false;
  }

  Future<bool> _deleteFileAndAssociatedProject(CatrobatImageMetaData imageData,
      ProjectDatabase db, IFileService fileService) async {
    final fileName = '${imageData.name}.${imageData.format.extension}';

    final result = await fileService.deleteFileInApplicationDirectory(fileName);
    if (result is Err) {
      Toast.show(
        'Could not delete the file while overwriting!',
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
      return false;
    }

    final oldProject = await db.projectDAO.getProjectByName(imageData.name);
    final oldProjectId = oldProject?.id;
    if (oldProject != null && oldProjectId != null) {
      await db.projectDAO.deleteProject(oldProjectId);
      ref.invalidate(ProjectDatabase.provider);
    }

    return true;
  }

  Future<bool> _checkIfFileExistsAndConfirmOverwrite(
      CatrobatImageMetaData imageData, ProjectDatabase db) async {
    final fileService = ref.watch(IFileService.provider);
    final fileName = '${imageData.name}.${imageData.format.extension}';
    final fileExists =
    await fileService.checkIfFileExistsInApplicationDirectory(fileName);

    if (fileExists) {
      final overWriteCanceled = await _showOverwriteDialog();
      if (overWriteCanceled) {
        Toast.show(
          'Project not saved!',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
        return false;
      }
      return await _deleteFileAndAssociatedProject(imageData, db, fileService);
    }

    return true;
  }



  void _shareContent() {

    Share.share('Check out this great app!');
  }


  Future<void> _saveProject() async {
    final imageData = await showSaveImageDialog(context, true);

    if (imageData == null) {
      return;
    }

    final catrobatImageData = imageData as CatrobatImageMetaData;

    final db = await ref.read(ProjectDatabase.provider.future);

    if (!await _checkIfFileExistsAndConfirmOverwrite(catrobatImageData, db)) {
      return;
    }

    if (mounted) {
      final savedProject = await ioHandler.saveProject(catrobatImageData);
      if (savedProject != null) {
        String? imagePreview =
        await ioHandler.getPreviewPath(catrobatImageData);
        Project projectNew = Project(
          name: catrobatImageData.name,
          path: savedProject.path,
          lastModified: DateTime.now(),
          creationDate: DateTime.now(),
          resolution: '',
          format: catrobatImageData.format.name,
          size: await savedProject.length(),
          imagePreviewPath: imagePreview,
        );

        await db.projectDAO.insertProject(projectNew);
      }
    }
  }
}
