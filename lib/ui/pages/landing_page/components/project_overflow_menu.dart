// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/database/project_database.dart';
import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/ui/shared/dialogs/delete_project_dialog.dart';
import 'package:paintroid/ui/shared/dialogs/project_details_dialog.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';

enum ProjectOverflowMenuOption {
  deleteProject('Delete'),
  getDetails('Details');

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
  late ProjectDatabase database;

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(ProjectDatabase.provider);
    db.when(
      data: (value) => database = value,
      error: (err, stacktrace) =>
          ToastUtils.showShortToast(message: 'Error: $err'),
      loading: () {},
    );

    return PopupMenuButton(
      color: Theme.of(context).colorScheme.background,
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: _handleSelectedOption,
      itemBuilder: (BuildContext context) => ProjectOverflowMenuOption.values
          .map((option) =>
              PopupMenuItem(value: option, child: Text(option.label)))
          .toList(),
    );
  }

  void _handleSelectedOption(ProjectOverflowMenuOption option) {
    switch (option) {
      case ProjectOverflowMenuOption.deleteProject:
        _deleteProject();
        break;
      case ProjectOverflowMenuOption.getDetails:
        _showProjectDetails();
        break;
    }
  }

  Future<void> _deleteProject() async {
    bool? shouldDelete = await showDeleteDialog(context, widget.project.name);
    if (shouldDelete != null && shouldDelete) {
      try {
        final projectFile = File(widget.project.path);
        await projectFile.delete();
        if (widget.project.imagePreviewPath != null) {
          final previewFile = File(widget.project.imagePreviewPath!);
          await previewFile.delete();
        }
      } catch (err) {
        ToastUtils.showShortToast(message: err.toString());
      }
      if (widget.project.id != null) {
        await database.projectDAO.deleteProject(widget.project.id!);
        ref.invalidate(ProjectDatabase.provider);
      }
    }
  }

  Future<void> _showProjectDetails() async {
    await showDetailsDialog(context, widget.project);
  }
}
