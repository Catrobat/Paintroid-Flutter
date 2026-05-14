import 'package:flutter/material.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

Future<bool?> showDeleteDialog(BuildContext context, String name){
  final localizations = AppLocalizations.of(context);
  return showGeneralDialog<bool>(
    context: context,
    pageBuilder: (_, __, ___) => GenericDialog(
            title: localizations!.project_delete_title.replaceAll('__name__', name),
            text: localizations.project_delete_dialog,
            actions: [
              GenericDialogAction(
                title: localizations.cancel_button_text.toUpperCase(),
                onPressed: () => Navigator.of(context).pop(false),
                identifier: WidgetIdentifier.genericDialogActionCancel,
              ),
              GenericDialogAction(
                title: localizations.delete_button_text.toUpperCase(),
                onPressed: () => Navigator.of(context).pop(true),
                identifier: WidgetIdentifier.genericDialogActionDelete,
              ),
            ]),
    barrierDismissible: true,
    barrierLabel: 'Show delete project dialog box');
}