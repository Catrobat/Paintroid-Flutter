import 'package:flutter/material.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';

Future<bool?> showOverwriteDialog(BuildContext context) =>
    showGeneralDialog<bool>(
      context: context,
      pageBuilder: (_, __, ___) => GenericDialog(
        title: 'Overwrite',
        text: 'Are you sure you want to overwrite the existing'
            ' file?\n\nThis action cannot be undone.',
        actions: [
          GenericDialogAction(
            title: 'Cancel',
            onPressed: () => Navigator.of(context).pop(true),
            identifier: WidgetIdentifier.genericDialogActionCancel,
          ),
          GenericDialogAction(
            title: 'Yes',
            onPressed: () => Navigator.of(context).pop(false),
            identifier: WidgetIdentifier.genericDialogActionYes,
          ),
        ],
      ),
      barrierDismissible: true,
      barrierLabel: 'Show overwrite dialog',
    );
