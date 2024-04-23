import 'dart:io';

import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum MainOverflowMenuOption {
  rate('Rate us!'),
  help('Help'),
  about('About'),
  feedback('Feedback');

  const MainOverflowMenuOption(this.label);

  final String label;
}

class MainOverflowMenu extends ConsumerStatefulWidget {
  const MainOverflowMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<MainOverflowMenu> createState() => _MainOverFlowMenuState();
}

class _MainOverFlowMenuState extends ConsumerState<MainOverflowMenu> {
  final feedbackUrl = 'mailto:support-paintroid@catrobat.org';
  final iOSAppId = 'org.catrobat.paintroidflutter';
  final androidAppId = 'org.catrobat.paintroid';

  @override
  Widget build(BuildContext context) {
    return StyledPopMenuButton<MainOverflowMenuOption>(
      onSelected: _handleSelectedOption,
      itemBuilder: (BuildContext context) => MainOverflowMenuOption.values
          .map((option) => PopupMenuItem(
              value: option,
              child: Text(option.label, style: TextThemes.menuItem)))
          .toList(),
    );
  }

  void _openStore() {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? androidAppId : iOSAppId;
      final url = Uri.parse(
        Platform.isAndroid
            ? 'market://details?id=$appId'
            : 'https://apps.apple.com/at/app/pocket-code/id1117935892',
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _handleSelectedOption(MainOverflowMenuOption option) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    switch (option) {
      case MainOverflowMenuOption.rate:
        _openStore();
        break;
      case MainOverflowMenuOption.help:
        if (mounted) {
          await Navigator.pushNamed(context, '/OnboardingPage');
        }
        break;
      case MainOverflowMenuOption.about:
        if (mounted) {
          showMyAboutDialog(context, version);
        }
        break;
      case MainOverflowMenuOption.feedback:
        openUrl(feedbackUrl);
        break;
    }
  }
}
