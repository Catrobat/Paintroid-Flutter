import 'package:flutter/material.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

Future<bool?> showOverwriteDialog(BuildContext context){
  final localizations = AppLocalizations.of(context);
  return showGeneralDialog<bool>(
    context: context,
    pageBuilder: (_, __, ___) => GenericDialog(
      title: localizations.pocketpaintOverwriteTitle,
      text: localizations.pocketpaintOverwrite,
      actions: [
        GenericDialogAction(
          title: localizations.cancelButtonText.toUpperCase(),
          onPressed: () => Navigator.of(context).pop(true),
          identifier: WidgetIdentifier.genericDialogActionCancel,
        ),
        GenericDialogAction(
          title: localizations.overwriteButtonText.toUpperCase(),
          onPressed: () => Navigator.of(context).pop(false),
          identifier: WidgetIdentifier.genericDialogActionYes,
        ),
      ],
    ),
    barrierDismissible: true,
    barrierLabel: 'Show overwrite dialog',
  );
}