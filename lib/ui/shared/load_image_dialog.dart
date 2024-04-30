// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/core/models/enums/image_location.dart';
import 'package:paintroid/ui/shared/generic_dialog.dart';

/// Returns [null] if user dismissed the dialog by tapping outside
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
                        Navigator.of(context).pop(ImageLocation.photos)),
                GenericDialogAction(
                    title: 'Files',
                    onPressed: () =>
                        Navigator.of(context).pop(ImageLocation.files))
              ],
            ),
        barrierDismissible: true,
        barrierLabel: 'Dismiss load image dialog box');
