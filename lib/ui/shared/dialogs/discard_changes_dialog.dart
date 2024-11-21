import 'package:flutter/material.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
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
                    onPressed: () => Navigator.of(context).pop(true),
                    identifier: WidgetIdentifier.genericDialogActionDiscard,
                  ),
                  GenericDialogAction(
                    title: 'Save',
                    onPressed: () => Navigator.of(context).pop(false),
                    identifier: WidgetIdentifier.genericDialogActionSave,
                  ),
                ]),
        barrierDismissible: true,
        barrierLabel: 'Dismiss discard changes dialog box');
