import 'dart:io';

import 'package:component_library/component_library.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';

enum ProjectOverflowMenuOption {
  deleteProject('Delete'),
  getDetails('Details');

  const ProjectOverflowMenuOption(this.label);

  final String label;
}

class ProjectOverflowMenu extends ConsumerStatefulWidget {
  final Project project;
  final Color? iconColor;

  const ProjectOverflowMenu({
    Key? key,
    required this.project,
    this.iconColor,
  }) : super(key: key);

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

    Widget icon = widget.iconColor != null
        ? Icon(Icons.more_vert, color: widget.iconColor)
        : const Icon(Icons.more_vert);

    return PopupMenuButton<ProjectOverflowMenuOption>(
      color: Theme.of(context).colorScheme.background,
      icon: icon,
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
