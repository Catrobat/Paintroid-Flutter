import 'package:flutter/material.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';

Future<bool?> showDeleteDialog(BuildContext context, String name) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => GenericDialog(
                title: 'Delete $name',
                text: 'Do you really want to delete your project?',
                actions: [
                  GenericDialogAction(
                    title: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(false),
                    identifier: WidgetIdentifier.genericDialogActionCancel,
                  ),
                  GenericDialogAction(
                    title: 'Delete',
                    onPressed: () => Navigator.of(context).pop(true),
                    identifier: WidgetIdentifier.genericDialogActionDelete,
                  ),
                ]),
        barrierDismissible: true,
        barrierLabel: 'Show delete project dialog box');
