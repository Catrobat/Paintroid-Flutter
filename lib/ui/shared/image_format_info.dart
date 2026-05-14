import 'package:flutter/material.dart';

import 'package:paintroid/core/enums/image_format.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

extension on ImageFormat {
  TextSpan info(AppLocalizations localizations) {
    switch (this) {
      case ImageFormat.png:
        return TextSpan(
            text: localizations.pocketpaint_png_message_dialog);
      case ImageFormat.jpg:
        return TextSpan(
          text: localizations.pocketpaint_jpg_message_dialog,
        );
      case ImageFormat.catrobatImage:
        return TextSpan(
            text: localizations.pocketpaint_catrobat_message_dialog);
    }
  }
}

class ImageFormatInfo extends StatelessWidget {
  final ImageFormat format;

  const ImageFormatInfo(this.format, {super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Row(
      children: [
        Icon(Icons.info_outline, color: PaintroidTheme.of(context).shadowColor),
        VerticalDivider(
          width: 8,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        Flexible(
          child: Text.rich(
            format.info(localizations!),
            style: TextStyle(
              fontSize: 11,
              color: PaintroidTheme.of(context).shadowColor,
            ),
          ),
        )
      ],
    );
  }
}
