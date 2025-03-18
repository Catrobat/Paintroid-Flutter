import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/database/project_database.dart';
import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/ui/shared/dialogs/delete_project_dialog.dart';
import 'package:paintroid/ui/shared/dialogs/project_details_dialog.dart';
import 'package:paintroid/ui/shared/dialogs/rename_project_dialog.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';

enum ProjectOverflowMenuOption {
  deleteProject('Delete'),
  getDetails('Details'),
  renameProject('Rename');

  const ProjectOverflowMenuOption(this.label);

  final String label;
}

class ProjectOverflowMenu extends ConsumerStatefulWidget {
  final Project project;

  const ProjectOverflowMenu({super.key, required this.project});

  @override
  ConsumerState<ProjectOverflowMenu> createState() =>
      _ProjectOverFlowMenuState();
}

class _ProjectOverFlowMenuState extends ConsumerState<ProjectOverflowMenu> {
  @override
  Widget build(BuildContext context) {
    final databaseAsync = ref.watch(ProjectDatabase.provider);

    return databaseAsync.when(
      data: (database) => PopupMenuButton(
        color: PaintroidTheme.of(context).backgroundColor,
        icon: const Icon(Icons.more_vert),
        shape: RoundedRectangleBorder(
          side: const BorderSide(),
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (option) => _handleSelectedOption(option, database),
        itemBuilder: (BuildContext context) =>
            ProjectOverflowMenuOption.values.map((option) {
          return PopupMenuItem(
            value: option,
            child: Text(
              option.label,
              style: TextStyle(
                color: PaintroidTheme.of(context).onBackgroundColor,
              ),
            ),
          );
        }).toList(),
      ),
      error: (err, _) {
        ToastUtils.showShortToast(message: 'Error: $err');
        return const SizedBox.shrink();
      },
      loading: () => const CircularProgressIndicator(),
    );
  }

  void _handleSelectedOption(
      ProjectOverflowMenuOption option, ProjectDatabase database) {
    switch (option) {
      case ProjectOverflowMenuOption.deleteProject:
        _deleteProject(database);
        break;
      case ProjectOverflowMenuOption.getDetails:
        _showProjectDetails();
        break;
      case ProjectOverflowMenuOption.renameProject:
        _renameProject(database);
        break;
    }
  }

  Future<void> _deleteProject(ProjectDatabase database) async {
    bool? shouldDelete = await showDeleteDialog(context, widget.project.name);
    if (shouldDelete ?? false) {
      try {
        final projectFile = File(widget.project.path);
        if (await projectFile.exists()) {
          await projectFile.delete();
        }
        if (widget.project.imagePreviewPath != null) {
          final previewFile = File(widget.project.imagePreviewPath!);
          if (await previewFile.exists()) {
            await previewFile.delete();
          }
        }
      } catch (err) {
        ToastUtils.showShortToast(message: err.toString());
      }
      if (widget.project.id == null) return;

      await database.projectDAO.deleteProject(widget.project.id!);
      ref.invalidate(ProjectDatabase.provider);
    }
  }

  Future<void> _showProjectDetails() async {
    await showDetailsDialog(context, widget.project);
  }

  Future<void> _renameProject(ProjectDatabase database) async {
    try {
      while (mounted) {
        String? name = await showRenameDialog(context, widget.project.name);
        if (name == null) return; // Handle user canceling the rename dialog

        Project? existingProject =
            await database.projectDAO.getProjectByName(name);

        if (existingProject == null) {
          Project? project =
              await database.projectDAO.getProjectByName(widget.project.name);

          if (project != null) {
            project.name = name;
            await database.projectDAO.deleteProject(project.id ?? -1);
            await database.projectDAO.insertProject(project);
            ref.invalidate(ProjectDatabase.provider);
          }
          break;
        }

        ToastUtils.showShortToast(
          message: 'A project with the name "$name" already exists.',
        );
      }
    } catch (err) {
      ToastUtils.showShortToast(message: err.toString());
    }
  }
}
