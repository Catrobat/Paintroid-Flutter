import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paintroid/core/models/loggable_mixin.dart';

import 'package:paintroid/core/utils/open_url.dart';
import 'package:paintroid/ui/shared/dialogs/about_dialog.dart';
import 'package:paintroid/ui/shared/pop_menu_button.dart';
import 'package:paintroid/ui/theme/theme.dart';
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
  const MainOverflowMenu({super.key});

  @override
  ConsumerState<MainOverflowMenu> createState() => _MainOverFlowMenuState();
}

class _MainOverFlowMenuState extends ConsumerState<MainOverflowMenu>
    with LoggableMixin {
  final feedbackUrl = 'mailto:support-paintroid@catrobat.org';
  final iOSAppId = 'org.catrobat.paintroidflutter';
  final androidAppId = 'org.catrobat.paintroid';

  @override
  Widget build(BuildContext context) {
    return StyledPopMenuButton<MainOverflowMenuOption>(
      onSelected: _handleSelectedOption,
      itemBuilder: (BuildContext context) => MainOverflowMenuOption.values
          .map(
            (option) => PopupMenuItem(
              value: option,
              child: Text(
                option.label,
                style: PaintroidTheme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _openStore() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final appId = Platform.isAndroid ? androidAppId : iOSAppId;
        final url = Uri.parse(
          Platform.isAndroid
              ? 'market://details?id=$appId'
              : 'https://apps.apple.com/app/$appId',
        );
        final launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          logger.severe('Could not launch app store URL: $url');
        }
      }
    } catch (err, stacktrace) {
      logger.severe('Failed to open app store', err, stacktrace);
    }
  }

  Future<void> _handleSelectedOption(MainOverflowMenuOption option) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    switch (option) {
      case MainOverflowMenuOption.rate:
        await _openStore();
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
