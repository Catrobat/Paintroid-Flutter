import 'package:flutter/material.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';

Future<bool?> showDiscardChangesDialog(BuildContext context) {
  final localizations = AppLocalizations.of(context);
  return showGeneralDialog<bool>(
      context: context,
      pageBuilder: (_, __, ___) => GenericDialog(
              title: localizations.closingSecurityQuestionTitle,
              text:  localizations.closingSecurityQuestion,
              actions: [
                GenericDialogAction(
                  title: localizations.discardButtonText.toUpperCase(),
                  onPressed: () => Navigator.of(context).pop(true),
                  identifier: WidgetIdentifier.genericDialogActionDiscard,
                ),
                GenericDialogAction(
                  title: localizations.saveButtonText.toUpperCase(),
                  onPressed: () => Navigator.of(context).pop(false),
                  identifier: WidgetIdentifier.genericDialogActionSave,
                ),
              ]),
      barrierDismissible: true,
      barrierLabel: 'Dismiss discard changes dialog box');
}