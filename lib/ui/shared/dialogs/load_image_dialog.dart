import 'package:flutter/material.dart';
import 'package:paintroid/core/enums/image_location.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';

Future<ImageLocation?> showLoadImageDialog(BuildContext context) =>
    showGeneralDialog<ImageLocation>(
        context: context,
        pageBuilder: (_, __, ___) => GenericDialog(
              title: 'Load image',
              text: 'Where do you want to load the image from?',
              actions: [
                GenericDialogAction(
                  title: 'Photos',
                  onPressed: () =>
                      Navigator.of(context).pop(ImageLocation.photos),
                  identifier: WidgetIdentifier.genericDialogActionPhotos,
                ),
                GenericDialogAction(
                  title: 'Files',
                  onPressed: () =>
                      Navigator.of(context).pop(ImageLocation.files),
                  identifier: WidgetIdentifier.genericDialogActionFiles,
                ),
              ],
            ),
        barrierDismissible: true,
        barrierLabel: 'Dismiss load image dialog box');
