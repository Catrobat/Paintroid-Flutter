// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
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
                      onPressed: () => Navigator.of(context).pop(false)),
                  GenericDialogAction(
                      title: 'Delete',
                      onPressed: () => Navigator.of(context).pop(true)),
                ]),
        barrierDismissible: true,
        barrierLabel: 'Show delete project dialog box');
