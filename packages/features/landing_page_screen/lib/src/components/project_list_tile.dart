import 'package:component_library/component_library.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:io_library/io_library.dart';
import 'package:landing_page_screen/landing_page_screen.dart';

class ProjectListTile extends StatelessWidget {
  final Project project;
  final IImageService imageService;
  final int index;
  final VoidCallback onTap;

  const ProjectListTile({
    super.key,
    required this.project,
    required this.imageService,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Card(
      child: ListTile(
        tileColor: PaintroidTheme.of(context).primaryColor,
        leading: ImagePreview(
          project: project,
          imageService: imageService,
          width: 80,
          color: PaintroidTheme.of(context).onSurfaceColor,
        ),
        dense: false,
        title: Text(
          project.name,
          style: TextStyle(color: PaintroidTheme.of(context).onSurfaceColor),
        ),
        subtitle: Text(
          'last modified: ${dateFormat.format(project.lastModified)}',
          style: TextStyle(color: PaintroidTheme.of(context).onSurfaceColor),
        ),
        trailing: ProjectOverflowMenu(
          key: Key('ProjectOverflowMenu Key$index'),
          project: project,
        ),
        enabled: true,
        onTap: onTap,
      ),
    );
  }
}
