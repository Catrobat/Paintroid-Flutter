import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../ui/color_schemes.dart';

Future<bool?> showMyAboutDialog(BuildContext context, String version) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => MyAboutDialog(version: version),
        barrierDismissible: true,
        barrierLabel: "Show project details dialog box");

class MyAboutDialog extends ConsumerStatefulWidget {
  final String version;

  const MyAboutDialog({Key? key, required this.version}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'About',
        style: TextStyle(color: lightColorScheme.primary),
      ),
      actions: [_okButton],
      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icon/pocketpaint_logo_small.png'),
          Text(
            "Version ${widget.version}",
            style: const TextStyle(fontSize: 9),
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                const TextSpan(text: content),
                TextSpan(
                  text: urlLicenseDescription,
                  style: const TextStyle(
                      color: Color(0xFFE68B00),
                      fontSize: 18,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse(urlLicense);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                ),
                TextSpan(
                  text: urlCatrobatDescription,
                  style: const TextStyle(
                      color: Color(0xFFE68B00),
                      fontSize: 18,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse(urlCatrobat);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton get _okButton => ElevatedButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text("DONE", style: TextStyle(color: Colors.white)),
      );
}
