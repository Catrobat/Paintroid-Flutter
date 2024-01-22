import 'package:flutter/material.dart';
import 'package:io_library/io_library.dart';

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
          ),
          GenericDialogAction(
            title: 'Yes',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      barrierDismissible: true,
      barrierLabel: 'Show overwrite dialog',
    );
