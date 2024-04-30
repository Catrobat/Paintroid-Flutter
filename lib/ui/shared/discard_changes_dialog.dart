// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/ui/shared/generic_dialog.dart';

/// Returns [true] if user chose to discard changes or [null] if user
/// dismissed the dialog by tapping outside
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
