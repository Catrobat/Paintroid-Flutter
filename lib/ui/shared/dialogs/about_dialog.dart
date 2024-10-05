import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/utils/open_url.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';
import 'package:paintroid/ui/shared/images/pocketpaint_logo_small.dart';
import 'package:paintroid/ui/theme/theme.dart';

Future<bool?> showMyAboutDialog(BuildContext context, String version) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => MyAboutDialog(version: version),
        barrierDismissible: true,
        barrierLabel: 'Show project details dialog box');

class MyAboutDialog extends ConsumerStatefulWidget {
  final String version;

  const MyAboutDialog({super.key, required this.version});

  @override
  ConsumerState<MyAboutDialog> createState() => _MyAboutDialogState();
}

class _MyAboutDialogState extends ConsumerState<MyAboutDialog> {
  static const license = 'GNU Affero General Public License, v3';
  static const content =
      'Pocket Paint is a picture editing library that is part of the Catrobat project.\n\nCatrobat is a visual programming language and set of creativity tools for smartphones.\n\nThe source code of Pocket Paint is mainly licensed under the $license.\nFor precise details of the license see the link below\n';
  static const urlLicenseDescription = '\nPocket Paint source code license';
  static const urlCatrobatDescription = '\nAbout Catrobat';
  static const urlLicense = 'https://developer.catrobat.org/licenses';
  static const urlCatrobat = 'https://catrobat.org';

  TextSpan _clickableText(String text, String url, TextStyle? style) =>
      TextSpan(
        text: text,
        style: style,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            openUrl(url);
          },
      );

  @override
  Widget build(BuildContext context) {
    final urlTextStyle = TextStyle(
      color: PaintroidTheme.of(context).orangeColor,
      fontSize: 18,
      decoration: TextDecoration.underline,
    );
    return GenericDialog(
      title: 'About',
      actions: [
        GenericDialogAction(
          title: 'DONE',
          onPressed: () => Navigator.of(context).pop(true),
          identifier: WidgetIdentifier.genericDialogActionDone,
        ),
      ],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const PocketPaintLogoSmall(),
          Text(
            'Version ${widget.version}',
            style: const TextStyle(fontSize: 9),
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: TextStyle(color: PaintroidTheme.of(context).shadowColor),
              children: [
                const TextSpan(text: content),
                _clickableText(
                  urlLicenseDescription,
                  urlLicense,
                  urlTextStyle,
                ),
                _clickableText(
                  urlCatrobatDescription,
                  urlCatrobat,
                  urlTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
