import 'package:flutter/material.dart';

import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';

Future<bool?> showDiscardChangesDialog(BuildContext context) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => GenericDialog(
                title: 'Discard changes',
                text:
                    'You have not saved your last changes. They will be lost!',
                actions: [
                  GenericDialogAction(
                      title: 'Discard',
                      onPressed: () => Navigator.of(context).pop(true)),
                  GenericDialogAction(
                      title: 'Save',
                      onPressed: () => Navigator.of(context).pop(false)),
                ]),
        barrierDismissible: true,
        barrierLabel: 'Dismiss discard changes dialog box');
