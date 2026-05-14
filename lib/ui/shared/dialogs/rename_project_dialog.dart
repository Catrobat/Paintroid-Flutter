import 'package:flutter/material.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';
import 'package:paintroid/ui/shared/text_input_field.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

Future<String?> showRenameDialog(BuildContext context, String name) async {
  final localizations = AppLocalizations.of(context);
  final TextEditingController textFieldController = TextEditingController()
    ..text = name;

  final formKey = GlobalKey<FormState>(debugLabel: 'TextInputDialog Form');

  return showDialog<String>(
    context: context,
    builder: (context) {
      return GenericDialog(
        title: localizations!.project_rename_title.replaceAll('__name__', name),
        actions: [
          GenericDialogAction(
              title: localizations.cancel_button_text.toUpperCase(),
              onPressed: () => Navigator.of(context).pop(),
              identifier: WidgetIdentifier.genericDialogActionCancel),
          GenericDialogAction(
            title: localizations.project_rename.toUpperCase(),
            onPressed: () {
              final formState = formKey.currentState;
              if (formState == null || !formState.validate()) {
                return;
              }
              Navigator.of(context).pop(textFieldController.text);
            },
            identifier: WidgetIdentifier.genericDialogActionRename,
          ),
        ],
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextInputField(
                key: const Key('textInputField'),
                controller: textFieldController,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return localizations.dialog_error_project_name;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
